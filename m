Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbbATTnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:43:14 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:20636 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbbATTnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:43:09 -0500
X-Mailbox-Line: From ddd1b299eca187ab2fa9b119da2ec8297ead1a66 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1421782532.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 20 Jan 2015 20:35:32 +0100
Subject: [PATCH v10 0/9] ASoC: tda998x: add a codec to the HDMI transmitter
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on broonie/ASoC

v10:
	- add the generic dt-card
	- define the audio ports from a DT graph of ports (Russell King)
	- reuse HDMI constants (Andrew Jackson - Jyri Sarha)
	- alloc rate_constraints in codec (Jyri Sarha)
	- fix bad number of channels (Jyri Sarha)
	- correct codec generation from config (Russell King - Jyri Sarha)
	- no module init/exit (Russell King)
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

Jean-Francois Moine (9):
  ASoC: kirkwood: dynamically build the DAI array
  ASoC: kirkwood: check the DAI type from the DAI name
  ASoC: kirkwood: accept the DAI definitions from a graph of ports
  drm/i2c: tda998x: Add support of a DT graph of ports
  drm/i2c: tda998x: Change drvdata for audio extension
  ASoC: tda998x: add a codec to the HDMI transmitter
  drm/i2c: tda998x: set cts_n according to the sample width
  ASoC: core: export snd_soc_get_dai_name
  ASoC: add generic dt-card support

 .../devicetree/bindings/drm/i2c/tda998x.txt        |  51 ++++
 .../devicetree/bindings/sound/mvebu-audio.txt      |  30 +++
 drivers/gpu/drm/i2c/tda998x_drv.c                  | 237 +++++++++++++++++-
 include/sound/soc.h                                |   2 +
 include/sound/tda998x.h                            |  32 +++
 sound/soc/codecs/Kconfig                           |   5 +
 sound/soc/codecs/Makefile                          |   2 +
 sound/soc/codecs/tda998x.c                         | 175 +++++++++++++
 sound/soc/generic/Kconfig                          |   2 +
 sound/soc/generic/Makefile                         |   2 +
 sound/soc/generic/dt-card.c                        | 275 +++++++++++++++++++++
 sound/soc/kirkwood/kirkwood-i2s.c                  | 141 ++++++-----
 sound/soc/kirkwood/kirkwood.h                      |   4 +-
 sound/soc/soc-core.c                               |   5 +-
 14 files changed, 877 insertions(+), 86 deletions(-)
 create mode 100644 include/sound/tda998x.h
 create mode 100644 sound/soc/codecs/tda998x.c
 create mode 100644 sound/soc/generic/dt-card.c

-- 
2.1.4

