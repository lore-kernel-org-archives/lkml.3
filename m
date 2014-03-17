Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbaCQJzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:55:10 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:43932 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbaCQJzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:55:09 -0400
X-Mailbox-Line: From 11bf968ac586e4a06d56c97d150ecf2c4afd8f27 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1395049204.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Mon, 17 Mar 2014 10:40:04 +0100
Subject: [PATCH RFC 0/5] Move tda998x to a couple encoder/connector
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'slave encoder' structure of the tda998x driver asks for glue
between the DRM driver and the encoder/connector structures.

Changing the tda998x driver to a simple encoder/connector simplifies
the code of the tilcdc driver. This change is permitted by
Russell's infrastructure for componentised subsystems.

The proposed patch set does not include changes to the Armada DRM driver
which has no DT support yet and which will not work anymore if this
patch set is applied.

Jean-Francois Moine (5):
  drm/i2c: tda998x: Move tda998x to a couple encoder/connector
  drm/tilcdc: Change the interface with the tda998x driver
  drm/i2c: tda998x: Add required properties
  drm/tilcd: dts: Add the video sink
  ARM: AM33XX: dts: Change the tda998x description

 .../devicetree/bindings/drm/i2c/tda998x.txt        |  12 +
 .../devicetree/bindings/drm/tilcdc/slave.txt       |  18 -
 .../devicetree/bindings/drm/tilcdc/tilcdc.txt      |   6 +
 arch/arm/boot/dts/am335x-base0033.dts              |  28 +-
 arch/arm/boot/dts/am335x-boneblack.dts             |  21 +-
 drivers/gpu/drm/i2c/tda998x_drv.c                  | 335 +++++++++--------
 drivers/gpu/drm/tilcdc/Makefile                    |   1 -
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |  81 +++-
 drivers/gpu/drm/tilcdc/tilcdc_slave.c              | 406 ---------------------
 drivers/gpu/drm/tilcdc/tilcdc_slave.h              |  26 --
 10 files changed, 297 insertions(+), 637 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/drm/tilcdc/slave.txt
 delete mode 100644 drivers/gpu/drm/tilcdc/tilcdc_slave.c
 delete mode 100644 drivers/gpu/drm/tilcdc/tilcdc_slave.h

-- 
1.9.0

