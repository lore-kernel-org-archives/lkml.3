Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab3GCQIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:08:21 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55788 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab3GCQIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:08:20 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Guenter Roeck'" <linux@roeck-us.net>
Cc: <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>
References: <002901ce77e9$dfac4f20$9f04ed60$@lucidpixels.com> <20130703144201.GA10323@roeck-us.net>
In-Reply-To: <20130703144201.GA10323@roeck-us.net>
Subject: RE: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro X9SRL-F motherboard
Date: Wed, 3 Jul 2013 12:08:17 -0400
Message-ID: <007101ce7807$88cfb160$9a6f1420$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIBG1i38eH5ocpI2BHQpKIJ/u+ELQK02s2OmNgwFJA=
Content-language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Guenter Roeck [mailto:linux@roeck-us.net] 
Sent: Wednesday, July 03, 2013 10:42 AM
To: Justin Piszcz
Cc: linux-kernel@vger.kernel.org; lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 3.10: NCT6776F sensor question with Supermicro
X9SRL-F motherboard

[ .. ]

This is surprising and might be where the alarm comes from. What output do
you
get if you load the coretemp driver ? 

coretemp-isa-0000
Adapter: ISA adapter
Physical id 0:  +38.0 C  (high = +81.0 C, crit = +91.0 C)
Core 0:         +36.0 C  (high = +81.0 C, crit = +91.0 C)
Core 1:         +35.0 C  (high = +81.0 C, crit = +91.0 C)
Core 2:         +35.0 C  (high = +81.0 C, crit = +91.0 C)
Core 3:         +34.0 C  (high = +81.0 C, crit = +91.0 C)
Core 4:         +37.0 C  (high = +81.0 C, crit = +91.0 C)
Core 5:         +38.0 C  (high = +81.0 C, crit = +91.0 C)

> PCH_CHIP_TEMP:   +0.0 C  
> PCH_CPU_TEMP:    +0.0 C  
> PCH_MCH_TEMP:    +0.0 C  
> intrusion0:    ALARM
> intrusion1:    ALARM

Are those not connected ?

The intrusion headers are not connected, also, I have not dug into it but
when you try to ignore the PECI or those PCH* lm_sensors seems to ignore the
rule.

sensors3.conf:
    ignore PCH_CHIP_TEMP
    ignore PCH_CPU_TEMP
    ignore PCH_MCH_TEMP

$ sensors  |tail -n 4
PCH_CHIP_TEMP:   +0.0 C
PCH_CPU_TEMP:    +0.0 C
PCH_MCH_TEMP:    +0.0 C

Ignoring intrusion works though:
    ignore intrusion0
    ignore intrusion1


nct6776-isa-0a30
Adapter: ISA adapter
Vcore:          +0.84 V  (min =  +0.54 V, max =  +1.49 V)
in1:            +1.84 V  (min =  +1.62 V, max =  +1.99 V)
AVCC:           +3.28 V  (min =  +2.98 V, max =  +3.63 V)
+3.3V:          +3.28 V  (min =  +2.98 V, max =  +3.63 V)
in4:            +1.50 V  (min =  +1.35 V, max =  +1.65 V)
in5:            +1.26 V  (min =  +1.13 V, max =  +1.38 V)
in6:            +1.06 V  (min =  +0.92 V, max =  +1.34 V)
3VSB:           +3.57 V  (min =  +2.98 V, max =  +3.63 V)
Vbat:           +3.47 V  (min =  +2.70 V, max =  +3.63 V)
fan1:          1007 RPM  (min =  700 RPM)
fan2:          1317 RPM  (min =  700 RPM)
fan3:          1102 RPM  (min =  700 RPM)
fan4:          1059 RPM  (min =  700 RPM)
fan5:           998 RPM  (min =  700 RPM)
SYSTIN:         +40.0 C  (high = +75.0 C, hyst = +70.0 C)  sensor =
thermistor
CPUTIN:         +31.5 C  (high = +95.0 C, hyst = +92.0 C)  ALARM  sensor =
thermistor
AUXTIN:         +23.0 C  (high = +80.0 C, hyst = +75.0 C)  sensor =
thermistor
PECI Agent 0:    +0.0 C  (high = +95.0 C, hyst = +92.0 C)
                         (crit = +100.0 C)
PCH_CHIP_TEMP:   +0.0 C
PCH_CPU_TEMP:    +0.0 C
PCH_MCH_TEMP:    +0.0 C

Thanks,
Guenter

