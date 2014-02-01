Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbaBARcJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 12:32:09 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:58651 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933102AbaBARcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 12:32:07 -0500
X-Mailbox-Line: From df65a2de7d4afc2471846c02b73e8bbdc4f9a743 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1391274627.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 1 Feb 2014 18:10:27 +0100
Subject: [PATCH v3 0/5] add a TDA998x CODEC
To: alsa-devel@alsa-project.org
Cc: broonie@kernel.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TDA998x HDMI transmitter accepts audio input from either I2S or
S/PDIF.
Theses inputs have different intrinsic constraints and these constraints
may be modified by the audio parameters of the connected video device.

The choice of I2S or S/PDIF may be the done by the user or by automatic
processing (DPCM?) at each audio starting time. This asks for a dynamic
audio input switch in the HDMI driver.

This patch series implements the TDA998x specific CODEC.

A simple function call mechanism is used for exchanges between the
CODEC and the HDMI driver.

Note: the changes in the TDA998x I2C driver are based on my previous
patch series:
http://lists.freedesktop.org/archives/dri-devel/2014-January/052837.html

- v3
	- move the DT description of the CODEC as a subnode of the
	  TDA998x I2C (Mark Brown remark - is this the right way?)
		- change CODEC loading mechanism
		- simplify tda998x i2c reference search
		- CODEC DT documentation in drm/i2c/tda998x.txt

- v2
	- add ACLK setting and code optimization in patch 1
	- from Mark Brown's remarks in patch 2:
		- don't compile the codec when CONFIG_ALL_CODECS
		- simplify the code about start/stop audio
		- fix coding style errors
		- add audio-port-names associated to audio-ports
	- add audio-port-names in patch 4
	- add patch 5 'adjust the audio CTS_N pre-divider from audio format'
		for the Beaglebone-Black board (Jyri Sarha)

Jean-Francois Moine (5):
  drm/i2c: tda998x: add a function for dynamic audio input switch
  ASoC: tda998x: add a codec driver for the TDA998x
  ASoC: tda998x: add DT documentation of the tda998x CODEC
  ASoC: tda998x: adjust the audio hw parameters from EDID
  ASoC: tda998x: adjust the audio CTS_N pre-divider from audio format

 .../devicetree/bindings/drm/i2c/tda998x.txt        |  17 ++
 drivers/gpu/drm/i2c/tda998x_drv.c                  |  86 +++++-
 include/drm/i2c/tda998x.h                          |  11 +-
 sound/soc/codecs/Kconfig                           |   6 +
 sound/soc/codecs/Makefile                          |   2 +
 sound/soc/codecs/tda998x.c                         | 303 +++++++++++++++++++++
 6 files changed, 419 insertions(+), 6 deletions(-)
 create mode 100644 sound/soc/codecs/tda998x.c

-- 
1.9.rc1

