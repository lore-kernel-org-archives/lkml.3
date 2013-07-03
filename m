Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab3GCQrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:47:51 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:57911 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983Ab3GCQru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:47:50 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Guenter Roeck'" <linux@roeck-us.net>
Cc: <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>
References: <002901ce77e9$dfac4f20$9f04ed60$@lucidpixels.com> <20130703144201.GA10323@roeck-us.net> <007101ce7807$88cfb160$9a6f1420$@lucidpixels.com> <20130703163311.GB12506@roeck-us.net>
In-Reply-To: <20130703163311.GB12506@roeck-us.net>
Subject: RE: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro X9SRL-F motherboard
Date: Wed, 3 Jul 2013 12:47:47 -0400
Message-ID: <008001ce780d$0d1a79f0$274f6dd0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIBG1i38eH5ocpI2BHQpKIJ/u+ELQK02s2OAOyqsYwB45ZSoJjBt85w
Content-language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Guenter Roeck [mailto:linux@roeck-us.net] 
Sent: Wednesday, July 03, 2013 12:33 PM
To: Justin Piszcz
Cc: linux-kernel@vger.kernel.org; lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
X9SRL-F motherboard

[ .. ]
> 
Can you install superiotool and run "sudo superiotool -V -e" ?
I would like to see raw data from the superio chip.

# superiotool -V -e
superiotool r6637
..
Probing for Nuvoton Super I/O (sid=0xfc) at 0x164e...
Found Nuvoton WPCM450 (id=0x1a11, rev=0x00) at 0x164e
Probing for Nuvoton Super I/O at 0x2e...
Found Nuvoton NCT6776F (C) (id=0xc333) at 0x2e

[ .. ]

You have to specify the raw attribute names, not the symbolic ones.
You see the raw attribute names with "sensors -u".

# sensors -u
PCH_CHIP_TEMP:
  temp8_input: 0.000
PCH_CPU_TEMP:
  temp9_input: 0.000
PCH_MCH_TEMP:
  temp10_input: 0.000

Tried:
    ignore PCH_CHIP_TEMP
    ignore temp8_input

For some reason still can't get rid of it appearing:
PCH_CHIP_TEMP:   +0.0 C  
(..as well as the others)


> $ sensors  |tail -n 4
> PCH_CHIP_TEMP:   +0.0 C
> PCH_CPU_TEMP:    +0.0 C
> PCH_MCH_TEMP:    +0.0 C
> 
> Ignoring intrusion works though:
>     ignore intrusion0
>     ignore intrusion1
> 
Does the board have intrusion detection headers ? If so, you could close
(bridge) the header(s) which should get rid of the alarm.

ftp://ftp.supermicro.com/CDR-X9-UP_1.21_for_Intel_X9_UP_platform/MANUALS/X9S
RL-F/X9SRL-F.pdf
@ page 49 (2-23) [motherboard: JL1 2-pin header]

-



