Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab3GCRX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 13:23:27 -0400
Received: from nm14-vm9.access.bullet.mail.gq1.yahoo.com ([216.39.63.252]:22153
	"EHLO nm14-vm9.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932143Ab3GCRX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 13:23:26 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jul 2013 13:23:26 EDT
X-Yahoo-Newman-Id: 77265.65258.bm@smtp115.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LIIHhHcVM1nKHMD9ZuzAX35vyVX9dYYY6hImCTZHfGnCY8X
 sDEbjIKyy.PxpNWAdLVs99Ua3u7a5TumNnwyWzhWGIlmmJwgtc2MV7ihVp00
 Fh7zBDWbWb3UJYbxL1NLSprrWJzPQic9CQE.s9q_RnB4nwL9P9SwepNJ5AfV
 8RXo19aTb5ZGvR99hGgVfxBtneoPkZ1IDvKsl_YlxcU5CuW0lV1z5SaeGOFs
 iEF55b6RzLP.VhKk13_EgCUh9.j2PYcQWMxQGwZp3fkjlV9BOlzYd.1gxxcP
 y220Sma2n75hdBoyb0xR5oFZS1AqOABpMzteZxYuFTJLClH7gcWquA5Nn.MS
 n42c_WiIzkmZsITuOAREBClYKt2e7d7ycA8VHJWMOGI9qDUhrLlFOPQK1hWA
 9WoqQ.vnazoKhn.a9yLpLT7VBv9Fm3QOf0SioKb88rVZ9g3FjnxQ3HJW9y0w
 wpVUhdgE.jCNSNJ8piFH8V7TgxkxpLObzVhrPQBLQXnk3VRUplUc..nq7Fws
 AF1T6Y5CA9vP8Vu6r3OMLCGyv4MkInWVb_D9NUfmIVRmj69MZ3kIAUb.aZGk
 4
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp115.sbc.mail.ne1.yahoo.com with SMTP; 03 Jul 2013 10:17:11 -0700 PDT
Date: Wed, 3 Jul 2013 10:17:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
 X9SRL-F motherboard
Message-ID: <20130703171713.GA26555@roeck-us.net>
References: <002901ce77e9$dfac4f20$9f04ed60$@lucidpixels.com>
 <20130703144201.GA10323@roeck-us.net>
 <007101ce7807$88cfb160$9a6f1420$@lucidpixels.com>
 <20130703163311.GB12506@roeck-us.net>
 <008001ce780d$0d1a79f0$274f6dd0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008001ce780d$0d1a79f0$274f6dd0$@lucidpixels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 12:47:47PM -0400, Justin Piszcz wrote:
> 
> 
> -----Original Message-----
> From: Guenter Roeck [mailto:linux@roeck-us.net] 
> Sent: Wednesday, July 03, 2013 12:33 PM
> To: Justin Piszcz
> Cc: linux-kernel@vger.kernel.org; lm-sensors@lm-sensors.org
> Subject: Re: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
> X9SRL-F motherboard
> 
> [ .. ]
> > 
> Can you install superiotool and run "sudo superiotool -V -e" ?
> I would like to see raw data from the superio chip.
> 
> # superiotool -V -e
> superiotool r6637
> ..
> Probing for Nuvoton Super I/O (sid=0xfc) at 0x164e...
> Found Nuvoton WPCM450 (id=0x1a11, rev=0x00) at 0x164e
> Probing for Nuvoton Super I/O at 0x2e...
> Found Nuvoton NCT6776F (C) (id=0xc333) at 0x2e
> 
Version is too old :(.

Can you try http://roeck-us.net/linux/bin/superiotool ?

> [ .. ]
> 
> You have to specify the raw attribute names, not the symbolic ones.
> You see the raw attribute names with "sensors -u".
> 
> # sensors -u
> PCH_CHIP_TEMP:
>   temp8_input: 0.000
> PCH_CPU_TEMP:
>   temp9_input: 0.000
> PCH_MCH_TEMP:
>   temp10_input: 0.000
> 
> Tried:
>     ignore PCH_CHIP_TEMP
>     ignore temp8_input
> 
> For some reason still can't get rid of it appearing:
> PCH_CHIP_TEMP:   +0.0 C  
> (..as well as the others)
> 
It has to be
	ignore temp8
	ignore temp9
	ignore temp10

Thanks,
Guenter
