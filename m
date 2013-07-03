Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab3GCMgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:36:05 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:35929 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab3GCMgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:36:01 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <lm-sensors@lm-sensors.org>
Subject: 3.10: NCT6776F sensor question with Supermicro X9SRL-F motherboard
Date: Wed, 3 Jul 2013 08:35:59 -0400
Message-ID: <002901ce77e9$dfac4f20$9f04ed60$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac536YXBnlAKAB+9QhSjCgQ+kECjNQ==
Content-language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Currently running 3.10 with:
CONFIG_SENSORS_NCT6775=y

Motherboard: Supermicro X9SRL-F

A couple questions:
1) Was curious if the PCH CHIP/CPU/MCH temperatures should be populated for
this board? 
2) Additionally, why is the CPUTIN in alarm?

I also found:
http://www.lm-sensors.org/wiki/Configurations/SuperMicro/X9SRA

Does Super Micro also have such a config file for the X9SRL-F?
This board uses a NCT6776F.

Relevant output from lm_sensors 3.6.0+dfsg1-1:

nct6776-isa-0a30
Adapter: ISA adapter
Vcore:          +0.81 V  (min =  +0.54 V, max =  +1.49 V)
in1:            +1.85 V  (min =  +1.62 V, max =  +1.99 V)
AVCC:           +3.30 V  (min =  +2.98 V, max =  +3.63 V)
+3.3V:          +3.30 V  (min =  +2.98 V, max =  +3.63 V)
in4:            +1.51 V  (min =  +1.35 V, max =  +1.65 V)
in5:            +1.27 V  (min =  +1.13 V, max =  +1.38 V)
in6:            +1.06 V  (min =  +0.92 V, max =  +1.34 V)
3VSB:           +3.57 V  (min =  +2.98 V, max =  +3.63 V)
Vbat:           +3.49 V  (min =  +2.70 V, max =  +3.63 V)
fan1:           986 RPM  (min =  700 RPM)
fan2:          1322 RPM  (min =  700 RPM)
fan3:          1103 RPM  (min =  700 RPM)
fan4:          1080 RPM  (min =  700 RPM)
fan5:          1001 RPM  (min =  700 RPM)
SYSTIN:         +42.0 C  (high = +75.0 C, hyst = +70.0 C)  sensor =
thermistor
CPUTIN:         +33.0 C  (high = +95.0 C, hyst = +92.0 C)  ALARM  sensor =
thermistor
AUXTIN:         +23.0 C  (high = +80.0 C, hyst = +75.0 C)  sensor =
thermistor
PECI Agent 0:    +0.0 C  (high = +95.0 C, hyst = +92.0 C)
                         (crit = +100.0 C)
PCH_CHIP_TEMP:   +0.0 C  
PCH_CPU_TEMP:    +0.0 C  
PCH_MCH_TEMP:    +0.0 C  
intrusion0:    ALARM
intrusion1:    ALARM

sensors3.conf snippet:

chip "w83627ehf-*" "w83627dhg-*" "w83667hg-*" "nct6775-*" "nct6776-*"

    label in0 "Vcore"
    label in2 "AVCC"
    label in3 "+3.3V"
    label in7 "3VSB"
    label in8 "Vbat"

    set in2_min  3.3 * 0.90
    set in2_max  3.3 * 1.10
    set in3_min  3.3 * 0.90
    set in3_max  3.3 * 1.10
    set in7_min  3.3 * 0.90
    set in7_max  3.3 * 1.10
    set in8_min  3.0 * 0.90
    set in8_max  3.3 * 1.10

Justin.

