Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaCJJ7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:59:20 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55056 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaCJJ7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:59:19 -0400
MIME-Version: 1.0
In-Reply-To: <531C2097.5020004@roeck-us.net>
References: <CAOMwXhPXPN+21N11cHBENvw0QZ1qPvo9GTbM9V2SwDmgBQZssw@mail.gmail.com>
	<20140307162524.6abd34be@endymion.delvare>
	<CAOMwXhOB=1HA57jwKCx3-hU8A_ypjrm0J3R9huO25xa4B_gw8w@mail.gmail.com>
	<20140307163717.336873f5@endymion.delvare>
	<CAOMwXhPpObWqd1vR3t+ifKd-_ZbnGTm1TNNUakmVAR3CB=pzTg@mail.gmail.com>
	<20140307181718.GA1027@roeck-us.net>
	<531BACD9.9050206@roeck-us.net>
	<CAOMwXhNcoe4oWbijJ7s3o-E6k0FtfJSXZM2g=RC3S2FzvX_VdQ@mail.gmail.com>
	<531C2097.5020004@roeck-us.net>
Date: Mon, 10 Mar 2014 09:59:18 +0000
X-Google-Sender-Auth: MHATGuneG6QyKZj9wAfbsz65JCM
Message-ID: <CAOMwXhPMnvc29VB0ViDc494CunKfmkKV+fvdBGNXoaAW+D+C9A@mail.gmail.com>
Subject: Re: [lm-sensors] Tachometer speed returned rather than absolute fan speed?
From: Laszlo Papp <lpapp@kde.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The reason is (most likely) that your fan input does not have a pull-up resistor. Per datasheet, the fan inputs need a 10kOhm pull-up resistor. I confirmed this with my test board - with the pull-up resistor, inputs read 0, Without pull-up, the reported value is 1, which translates to 30 RPM. You might also need the 10 uF capacitor on the FB pin.

We have both of them in place as per requirement for the chip as far
as I understand the datasheet. The circuit would not work properly
without it.
> sudo i2cdump -y -f 1 0x48
> No size specified (using byte-data access)
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
> 00: 00 00 0a 0a ff ff 00 00 00 00 00 00 01 01 00 00    ..??........??..
> 10: 01 01 01 01 1f 1f 02 02 91 91 91 91 91 91 91 91    ????????????????
> 20: 00 00 0a 0a ff ff 00 00 00 00 00 00 01 01 00 00    ..??........??..

/usr/sbin/i2cdump -y -f 1 0x48
No size specified (using byte-data access)
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
10: 09 09 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
20: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
30: 09 09 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
40: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
50: 08 08 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
60: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
70: 08 08 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
80: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
90: 08 08 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
a0: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
b0: 08 08 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
c0: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
d0: 08 08 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
e0: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
f0: 08 08 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????

> groeck@desktop:~$ sensors max6651-i2c-1-48
> max6651-i2c-1-48
> Adapter: i2c-diolan-u2c at bus 003 device 002
> fan1:          30 RPM  (div = 4)
> fan2:           0 RPM
> fan3:          30 RPM
> fan4:          30 RPM

sensors max6651-i2c-1-48
max6651-i2c-1-48
Adapter: DaVinci I2C adapter
fan1:          30 RPM  (div = 4)
fan2:          30 RPM
fan3:         420 RPM
fan4:          30 RPM

> Only fan2 (TACH1 chip input) has the resistor installed.

We have it both on fan1 and fan4.

If I use our scope for checking the tachometer, I see level zero on
the scope, but 1 when checking the open collector level, since that is
the purpose of the pull-up resistor.

I am currently clueless. Fwiw, I am now using linux kernel 3.2.1 for
the moment. I cannot see any bugfixes in the log with regards to that,
though. I am still not sure what is going on, so I cannot claim that
it is a bug, nor can I exclude it. Any help would be appreciated.
