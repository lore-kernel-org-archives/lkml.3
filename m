Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaK2RHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:07:24 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38823 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaK2RHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:07:22 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Date: Sat, 29 Nov 2014 18:07:19 +0100
Message-ID: <1419444.Nxv4HBGmNA@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0-rc5+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <201411291709.35406@pali>
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <201411291709.35406@pali>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 November 2014 17:09:35 Pali Rohár wrote:
> On Saturday 29 November 2014 17:04:07 Pali Rohár wrote:
> > This patch adds labels for temperature sensors if SMM function
> > with EAX register 0x11a3 reports it. These informations was
> > taken from DOS binary NBSVC.MDM.
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > ---
> > 
> >  drivers/char/i8k.c |  110
> > 
> > +++++++++++++++++++++++++++++++++++++++++----------- 1 file
> > changed, 88 insertions(+), 22 deletions(-)
> 
> I tested patch on Latitude E6440 and i8k CPU & GPU temps match
> intel coretemp & amd radeion temps.
> 
> But I would like if somebody with other Dell laptop can test if
> temperature labels are correct...

I tested it on my XPS13 9333, here what sensors outputs:

acpitz-virtual-0
Adapter: Virtual device
temp1:        +27.8°C  (crit = +105.0°C)
temp2:        +29.8°C  (crit = +105.0°C)

coretemp-isa-0000
Adapter: ISA adapter
Physical id 0:  +62.0°C  (high = +100.0°C, crit = +100.0°C)
Core 0:         +62.0°C  (high = +100.0°C, crit = +100.0°C)
Core 1:         +61.0°C  (high = +100.0°C, crit = +100.0°C)

i8k-virtual-0
Adapter: Virtual device
fan2:           0 RPM
CPU:          +62.0°C  
Ambient:      +49.0°C  
SODIMM:       +46.0°C  
temp4:            N/A

CPU seems to be correct, but I can't say anything on Ambient and SODIMM.
temp4 is constantly equal to SODIMM without this patch, so I'd say N/A
is correct.


Gabriele
