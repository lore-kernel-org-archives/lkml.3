Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab3GCVAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:00:22 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:64602 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933209Ab3GCVAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:00:18 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Guenter Roeck'" <linux@roeck-us.net>
Cc: <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>
References: <002901ce77e9$dfac4f20$9f04ed60$@lucidpixels.com> <20130703144201.GA10323@roeck-us.net> <007101ce7807$88cfb160$9a6f1420$@lucidpixels.com> <20130703163311.GB12506@roeck-us.net> <008001ce780d$0d1a79f0$274f6dd0$@lucidpixels.com> <20130703171713.GA26555@roeck-us.net> <008e01ce7811$b50c9180$1f25b480$@lucidpixels.com> <20130703205654.GA30588@roeck-us.net> <00ad01ce7830$3b135890$b13a09b0$@lucidpixels.com>
In-Reply-To: <00ad01ce7830$3b135890$b13a09b0$@lucidpixels.com>
Subject: RE: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro X9SRL-F motherboard
Date: Wed, 3 Jul 2013 17:00:16 -0400
Message-ID: <00b501ce7830$527362a0$f75a27e0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIBG1i38eH5ocpI2BHQpKIJ/u+ELQK02s2OAOyqsYwB45ZSoAJZuzqdAnnKLoQBSqfGJgHzZUS+AhkxagqYcKrlIA==
Content-language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-sending as text.

From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com] 
Sent: Wednesday, July 03, 2013 5:00 PM
To: 'Guenter Roeck'
Cc: linux-kernel@vger.kernel.org; lm-sensors@lm-sensors.org
Subject: RE: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
X9SRL-F motherboard



-----Original Message-----
From: Guenter Roeck [mailto:linux@roeck-us.net] 
Sent: Wednesday, July 03, 2013 4:57 PM
To: Justin Piszcz
Cc: linux-kernel@vger.kernel.org; lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
X9SRL-F motherboard

[ .. ]

> 09: 0a 00 00 00 00 0a 0a 0a 0a aa ef 80 ff 40 46 c4 
> 0a: 0e 01 00 00 ff 00 00 ff 00 00 80 66 66 06 01 01 
                                                ^^
This shows that PECI Agent 0 is supposed to be enabled.

> Bank 2:
>     00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 
> 00: 8c 32 00 01 01 33 01 3c ff 33 ff ff 00 ff ff ff 
      ^^
This value suggests that the second temperature sensor (the one creating
the alarm) is supposed to be the PECI source (which reports the CPU
temperature
to the NCT6776), and that it is supposed to be used to control the speed
of the CPU fan.
            ^^
Fan control is in manual mode. Did you set this ?
It is quite unusual.

Setting:                
Current FAN Mode is Optimal.
Set Fan to Standard Speed
Set Fan to Full Speed
Set Fan to Optimal Speed

> Bank 7:
>     00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 
> 00: ff 95 02 10 00 00 00 00 00 64 00 00 00 00 00 00 
> 01: 00 00 00 00 00 00 00 f8 80 f8 80 f8 80 f8 80 00 
                                                   ^^
00 here shows that the PECI source is not active, ie the CPU does not
deliver
PECI data to the NCT6776. This explains the alarm.

Practical impact is probably limited as fan control is configured to be
manual
anyway, but I wonder why PECI doesn't work on your board. PECI configuration
is identical to my Supermicro board.

Guenter


