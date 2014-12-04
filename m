Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaLDOdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:33:49 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40449 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbaLDOds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:33:48 -0500
MIME-Version: 1.0
In-Reply-To: <54806D6C.7060009@roeck-us.net>
References: <1417687048-21455-1-git-send-email-bgolaszewski@baylibre.com>
	<1417687048-21455-2-git-send-email-bgolaszewski@baylibre.com>
	<54806D6C.7060009@roeck-us.net>
Date: Thu, 4 Dec 2014 15:33:47 +0100
Message-ID: <CAMpxmJUVQyU_NC=7wByinboM-n9kvQoDALZ3-ZiDmRatKQp8Rg@mail.gmail.com>
Subject: Re: [PATCH 1/2] hwmon: tmp401: add support for TI TMP435
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-04 15:19 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> The datasheet claims otherwise (0x31, specifically).
> Is this based on real chip information ?
> Can you send me the output from i2cdump for the chip ?
>

This is what I'm reading:

# i2cdump -y 1 0x4c
No size specified (using byte-data access)
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 1a 1b 00 00 05 55 00 55 00 00 05 55 00 55 00 0d    ??..?U.U..?U.U.?
10: 70 00 00 00 00 90 00 00 00 55 1c XX XX XX XX 00    p....?...U?XXXX.
20: 55 0a 70 XX XX 0f XX XX XX XX XX XX XX XX XX XX    U?pXX?XXXXXXXXXX
30: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
40: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
50: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
60: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
70: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
80: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
90: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
a0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
b0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
c0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
d0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
e0: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX    XXXXXXXXXXXXXXXX
f0: XX XX XX XX XX XX XX XX XX XX XX XX 00 35 55 35    XXXXXXXXXXXX.5U5

# i2cget -y 1 0x4c 0xff b
0x35

Bart
