Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaHaNdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 09:33:17 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:8627 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaHaNdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 09:33:14 -0400
X-Mailbox-Line: From 23c70e08b14862bff75ca62e52f8ff69e8f9bc70 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1409490122.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sun, 31 Aug 2014 15:02:02 +0200
Subject: [PATCH v4 0/2] ASoC: tda998x: add a codec to the HDMI transmitter
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Jackson <Andrew.Jackson@arm.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NXP TDA998x HDMI transmitter may transmit audio to the HDMI link
from 2 different sources, I2S and S/PDIF.

This patch set adds a generic HDMI CODEC module which is used by
the TDA998x driver to update the audio constraints from the display
characteristics (EDID) and by the audio subsystem to connect the chosen
audio source to the HDMI link.

v4:
	- remove all the TDA998x specific stuff from the CODEC
	- move the EDID scan from the CODEC to the TDA998x
	- move the CODEC to sound/soc (Mark Brown)
	- update the audio_sample_rate from the EDID (Andrew Jackson)
v3: fix bad rate (Andrew Jackson)
v2: check double stream start (Mark Brown)

Jean-Francois Moine (2):
  ASoC:codecs: Add a generic HDMI audio CODEC
  drm/i2c:tda998x: Use the HDMI2  audio CODEC

 Documentation/devicetree/bindings/sound/hdmi2.txt |  32 ++++
 drivers/gpu/drm/i2c/Kconfig                       |   1 +
 drivers/gpu/drm/i2c/tda998x_drv.c                 | 142 ++++++++++++++-
 include/sound/hdmi2.h                             |  24 +++
 sound/soc/codecs/Kconfig                          |   3 +
 sound/soc/codecs/Makefile                         |   2 +
 sound/soc/codecs/hdmi2.c                          | 204 ++++++++++++++++++++++
 7 files changed, 400 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/hdmi2.txt
 create mode 100644 include/sound/hdmi2.h
 create mode 100644 sound/soc/codecs/hdmi2.c

-- 
2.1.0

