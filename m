Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaA0JgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:36:13 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:46722 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaA0JgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:36:12 -0500
X-Mailbox-Line: From d99e90932aad1a644fa32ff22fd2cb56b830341b Mon Sep 17 00:00:00 2001
Message-Id: <cover.1390813480.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Mon, 27 Jan 2014 10:04:40 +0100
Subject: [PATCH 0/4] add a TDA998x CODEC
To: alsa-devel@alsa-project.org
Cc: broonie@kernel.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TDA998x HDMI transmitter accepts audio input from either I2S or S/PDIF.

Theses inputs have different intrinsic constraints and these constraints
may be modified by the audio parameters of the connected video device.

The choice of I2S or S/PDIF may be the done by the user or by automatic
processing (DPCM?) at each audio starting time. This asks for a dynamic
audio input switch in the HDMI driver.

This patch series implements the TDA998x specific CODEC.
A simple function call mechanism is used for exchanges between the
CODEC and the HDMI driver.

Jean-Francois Moine (4):
  drm/i2c: tda998x: add a function for dynamic audio input switch
  ASoC: tda998x: add a codec driver for TDA998x
  ASoC: tda998x: add DT documentation
  ASoC: tda998x: adjust the audio hw parameters from EDID

 .../devicetree/bindings/sound/tda998x.txt          |  14 +
 drivers/gpu/drm/i2c/tda998x_drv.c                  |  58 +++-
 include/drm/i2c/tda998x.h                          |   8 +-
 sound/soc/codecs/Kconfig                           |   7 +
 sound/soc/codecs/Makefile                          |   2 +
 sound/soc/codecs/tda998x.c                         | 304 +++++++++++++++++++++
 6 files changed, 390 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/tda998x.txt
 create mode 100644 sound/soc/codecs/tda998x.c

-- 
1.8.5.3

