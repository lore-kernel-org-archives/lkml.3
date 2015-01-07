Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbbAGLwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:52:16 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:5619 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbbAGLwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:52:15 -0500
X-Mailbox-Line: From 3b99496107b6653ef27b86d8cdf516a4815910cf Mon Sep 17 00:00:00 2001
Message-Id: <cover.1420628786.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Wed, 7 Jan 2015 12:06:26 +0100
Subject: [PATCH v9 0/4] ASoC: tda998x: add a codec to the HDMI transmitter
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on 3.19.0-rc3.

v9:
	- back to a TDA998x specific CODEC
	- more comments
	- change magic values to constants
v8:
	- change some comments about the patches
v7:
	- remove the change of the K predivider (Jyri Sarha)
	- add S24_3LE and S32_LE as possible audio formats (Jyri Sarha)
	- don't move the struct priv2 definition and use the
	  slave encoder private data as the device private data
	  (Russell King)
	- remove the useless request_module (Russell King/Mark Brown)
	- don't lock the HDMI module (Russell King)
	- use platform_device_unregister to remove the codec
	  (Russell King)
v6:
	- extend the HDMI CODEC instead of using a specific CODEC
v5:
	- use the TDA998x private data instead of a specific area
	  for the CODEC interface
	- the CODEC is TDA998x specific (Mark Brown)
v4:
	- remove all the TDA998x specific stuff from the CODEC
	- move the EDID scan from the CODEC to the TDA998x
	- move the CODEC to sound/soc (Mark Brown)
	- update the audio_sample_rate from the EDID (Andrew Jackson)
v3: fix bad rate (Andrew Jackson)
v2: check double stream start (Mark Brown)

Jean-Francois Moine (4):
  drm/i2c: tda998x: Add DT support for audio
  drm/i2c: tda998x: Change drvdata for audio extension
  ASoC: tda998x: add a codec to the HDMI transmitter
  drm/i2c: tda998x: set cts_n according to the sample width

 .../devicetree/bindings/drm/i2c/tda998x.txt        |  18 ++
 drivers/gpu/drm/i2c/Kconfig                        |   1 +
 drivers/gpu/drm/i2c/tda998x_drv.c                  | 213 +++++++++++++++++++--
 include/sound/tda998x.h                            |  23 +++
 sound/soc/codecs/Kconfig                           |   4 +
 sound/soc/codecs/Makefile                          |   2 +
 sound/soc/codecs/tda998x.c                         | 175 +++++++++++++++++
 7 files changed, 424 insertions(+), 12 deletions(-)
 create mode 100644 include/sound/tda998x.h
 create mode 100644 sound/soc/codecs/tda998x.c

-- 
2.1.4

