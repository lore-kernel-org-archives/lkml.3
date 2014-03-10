Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaCJPL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:11:57 -0400
Received: from mail-pb0-f66.google.com ([209.85.160.66]:60486 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaCJPL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:11:56 -0400
Date: Mon, 10 Mar 2014 08:11:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Laszlo Papp <lpapp@kde.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Tachometer speed returned rather than absolute fan
 speed?
Message-ID: <20140310151146.GA26903@roeck-us.net>
References: <CAOMwXhOB=1HA57jwKCx3-hU8A_ypjrm0J3R9huO25xa4B_gw8w@mail.gmail.com>
 <20140307163717.336873f5@endymion.delvare>
 <CAOMwXhPpObWqd1vR3t+ifKd-_ZbnGTm1TNNUakmVAR3CB=pzTg@mail.gmail.com>
 <20140307181718.GA1027@roeck-us.net>
 <531BACD9.9050206@roeck-us.net>
 <CAOMwXhNcoe4oWbijJ7s3o-E6k0FtfJSXZM2g=RC3S2FzvX_VdQ@mail.gmail.com>
 <531C2097.5020004@roeck-us.net>
 <CAOMwXhPMnvc29VB0ViDc494CunKfmkKV+fvdBGNXoaAW+D+C9A@mail.gmail.com>
 <531DBD74.2090205@roeck-us.net>
 <CAOMwXhMRtNaxtA7=cc7ur_Qf3iwZAHi=sk-Ujp=hggGA1O5u+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMwXhMRtNaxtA7=cc7ur_Qf3iwZAHi=sk-Ujp=hggGA1O5u+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 01:50:01PM +0000, Laszlo Papp wrote:
> On Mon, Mar 10, 2014 at 1:26 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > On 03/10/2014 02:59 AM, Laszlo Papp wrote:
> >>>
> >>> The reason is (most likely) that your fan input does not have a pull-up
> >>> resistor. Per datasheet, the fan inputs need a 10kOhm pull-up resistor. I
> >>> confirmed this with my test board - with the pull-up resistor, inputs read
> >>> 0, Without pull-up, the reported value is 1, which translates to 30 RPM. You
> >>> might also need the 10 uF capacitor on the FB pin.
> >>
> >>
> >> We have both of them in place as per requirement for the chip as far
> >> as I understand the datasheet. The circuit would not work properly
> >> without it.
> >>>
> >>> sudo i2cdump -y -f 1 0x48
> >>> No size specified (using byte-data access)
> >>>       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
> >>> 00: 00 00 0a 0a ff ff 00 00 00 00 00 00 01 01 00 00    ..??........??..
> >>> 10: 01 01 01 01 1f 1f 02 02 91 91 91 91 91 91 91 91    ????????????????
> >>> 20: 00 00 0a 0a ff ff 00 00 00 00 00 00 01 01 00 00    ..??........??..
> >>
> >>
> >> /usr/sbin/i2cdump -y -f 1 0x48
> >> No size specified (using byte-data access)
> >>       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
> >> 00: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
> >> 10: 09 09 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
> >> 20: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
> >> 30: 09 09 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
> >> 40: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
> >> 50: 08 08 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
> >> 60: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
> >> 70: 08 08 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
> >> 80: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
> >> 90: 08 08 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
> >> a0: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
> >> b0: 08 08 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
> >> c0: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
> >> d0: 08 08 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
> >> e0: 00 00 3a 3a fc fc b4 b4 00 00 00 00 01 01 01 01    ..::????....????
> >> f0: 08 08 01 01 1c 1c 02 02 91 91 91 91 91 91 91 91    ????????????????
> >>
> >>> groeck@desktop:~$ sensors max6651-i2c-1-48
> >>> max6651-i2c-1-48
> >>> Adapter: i2c-diolan-u2c at bus 003 device 002
> >>> fan1:          30 RPM  (div = 4)
> >>> fan2:           0 RPM
> >>> fan3:          30 RPM
> >>> fan4:          30 RPM
> >>
> >>
> >> sensors max6651-i2c-1-48
> >> max6651-i2c-1-48
> >> Adapter: DaVinci I2C adapter
> >> fan1:          30 RPM  (div = 4)
> >> fan2:          30 RPM
> >> fan3:         420 RPM
> >> fan4:          30 RPM
> >>
> >>> Only fan2 (TACH1 chip input) has the resistor installed.
> >>
> >>
> >> We have it both on fan1 and fan4.
> >>
> >> If I use our scope for checking the tachometer, I see level zero on
> >> the scope, but 1 when checking the open collector level, since that is
> >> the purpose of the pull-up resistor.
> >>
> > With the pull-up installed, you should always see a high voltage on the
> > scope or with a volt meter. The scope would not see or be able to know
> > that the pin is OC if the pull-up resistor is there.
> >
> > If it is truly OC, it would be floating and might show low. If you can,
> > I would suggest to manually add a 10k resistor against VCC to the open
> > connector and see what happens.
> >
> > Another way to find out for sure might be to disconnect power and
> > measure resistance between the tachometer pin and VCC.
> 
> Perhaps I was not clear. So, we do have both the resistors and
> capacitor as required. I double checked the schematics as well as the
> pins coming from the fan and that was zero. The tacho0 input, however,
> was 1.
> 

How can the pin coming from the fan be zero, and the tach0 input be 1
at the same time ? Those should be the same ?

Anyway, I don't think I can help you further. All I can say is that
the chip operates as expected on my test board.

Guenter
