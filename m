Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaK2Qhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:37:36 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49929 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaK2Qhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:37:35 -0500
MIME-Version: 1.0
In-Reply-To: <201411291709.35406@pali>
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>
	<201411291709.35406@pali>
Date: Sat, 29 Nov 2014 16:37:33 +0000
Message-ID: <CABz95_A32CNhU=ZxLp=WAsSQqX_DnFoKOYtiva2TMrae6UUnwQ@mail.gmail.com>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
From: Steven Honeyman <stevenhoneyman@gmail.com>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 November 2014 at 16:09, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Saturday 29 November 2014 17:04:07 Pali Rohár wrote:
>> This patch adds labels for temperature sensors if SMM function
>> with EAX register 0x11a3 reports it. These informations was
>> taken from DOS binary NBSVC.MDM.
>>
>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> ---
>>  drivers/char/i8k.c |  110
>> +++++++++++++++++++++++++++++++++++++++++----------- 1 file
>> changed, 88 insertions(+), 22 deletions(-)
>
> I tested patch on Latitude E6440 and i8k CPU & GPU temps match
> intel coretemp & amd radeion temps.
>
> But I would like if somebody with other Dell laptop can test if
> temperature labels are correct...

Tested and working on E6540:
(I manually masked the serial/service tag)

-----Before-----

*[steven@e6540 linux]$ cat /proc/i8k
1.0 A12 6xxxxxx 44 -22 1 -22 3223 -1 -22
*[steven@e6540 linux]$ sensors
i8k-virtual-0
Adapter: Virtual device
fan2:        3223 RPM
temp1:        +46.0°C
temp2:        +44.0°C
temp3:        +38.0°C

coretemp-isa-0000
Adapter: ISA adapter
Physical id 0:  +49.0°C  (high = +84.0°C, crit = +100.0°C)
Core 0:         +45.0°C  (high = +84.0°C, crit = +100.0°C)
Core 1:         +49.0°C  (high = +84.0°C, crit = +100.0°C)

-----After-----

*[steven@e6540 ~]$ cat /proc/i8k
1.0 A12 6xxxxxx 47 -22 1 -22 3176 -1 -22
*[steven@e6540 ~]$ sensors
i8k-virtual-0
Adapter: Virtual device
fan2:        3176 RPM
CPU:          +47.0°C
Ambient:      +45.0°C
SODIMM:       +38.0°C

coretemp-isa-0000
Adapter: ISA adapter
Physical id 0:  +47.0°C  (high = +84.0°C, crit = +100.0°C)
Core 0:         +45.0°C  (high = +84.0°C, crit = +100.0°C)
Core 1:         +46.0°C  (high = +84.0°C, crit = +100.0°C)
