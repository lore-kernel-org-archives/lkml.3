Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3GAIkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:40:01 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:57974 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3GAIj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:39:59 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [RFC PATCH 00/13] audio support for at91sam9x5ek board
Date: Mon,  1 Jul 2013 10:39:25 +0200
Message-Id: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is some work I've done to make the sound work on sam9x5ek.
It's based on Nicolas Ferre's and Uwe Kleine-König's work.
(Atmel patch on 2.6.39 if I recall)

I'd like to have some advice, mainly on the 1st patch
 "misc: atmel_ssc: add device tree DMA support".
I do not clearly see what is the right way to add DMA DT support for
this device, since it doesn't request a channel directly.


patches applies on next-20130701

[I let the original signed-off from Nicolas and Uwe in place, I don't
know if I should replace them by something like "originaly-signed-off-by"
since the code has been changed.]

Best regards,
Richard.


Nicolas Ferre (3):
  sound: sam9x5_wm8731: machine driver for at91sam9x5 wm8731 boards
  sound: atmel_ssc_dai: PM: actually stopping clock on suspend/resume
  sound: wm8731: rework power management

Richard Genoud (10):
  misc: atmel_ssc: add device tree DMA support
  misc: atmel_ssc: keep the count of pdev->id
  ARM: at91: DTS: sam9x5: add clock for SSC DT entry
  ARM: at91: DTS: sam9x5: add SSC DMA parameters
  ARM: AT91: DTS: sam9x5ek: add WM8731 codec
  ARM: AT91: DTS: sam9x5ek: add sound configuration
  ARM: AT91: DTS: sam9x5ek: enable SSC
  sound: atmel-pcm: don't return ok if pcm-dma is not implemented
  sound: atmel-pcm-dma: check pointer before dereference
  sound: codec: wm8371: correct capture line/mic

 arch/arm/boot/dts/at91sam9x5.dtsi       |    3 +
 arch/arm/boot/dts/at91sam9x5ek.dtsi     |   27 ++++
 arch/arm/mach-at91/at91sam9x5.c         |    1 +
 drivers/misc/atmel-ssc.c                |   63 +++++++++
 include/linux/atmel-ssc.h               |    2 +
 include/linux/platform_data/dma-atmel.h |    2 +
 sound/soc/atmel/Kconfig                 |   12 ++
 sound/soc/atmel/Makefile                |    2 +
 sound/soc/atmel/atmel-pcm-dma.c         |    3 +
 sound/soc/atmel/atmel-pcm.h             |    2 +-
 sound/soc/atmel/atmel_ssc_dai.c         |   20 ++-
 sound/soc/atmel/sam9x5_wm8731.c         |  232 +++++++++++++++++++++++++++++++
 sound/soc/codecs/wm8731.c               |   10 +-
 13 files changed, 368 insertions(+), 11 deletions(-)
 create mode 100644 sound/soc/atmel/sam9x5_wm8731.c

-- 
1.7.10.4

