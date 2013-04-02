Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093Ab3DBSUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:20:37 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:56526 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760298Ab3DBSUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:20:34 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: tomi.valkeinen@ti.com
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv3 0/6] fb: vt8500: patches for 3.10
Date: Wed,  3 Apr 2013 07:20:32 +1300
Message-Id: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V3 Changes:
Tidied up patch 1 as requested by Jean-Christophe - Makes the patch much
simpler.

V2 Changes:
Split the SoC and board portions of the binding into their respective files.
Removed the forced non-interlaced code from wm8505fb.c and vt8500lcdfb.c

Julia Lawall (1):
  drivers/video/wm8505fb.c: use devm_ functions

Tony Prisk (5):
  video: vt8500: Make wmt_ge_rops optional
  video: vt8500: Remove unused platform_data/video-vt8500lcdfb.h
  video: vt8500: Correct descriptions in video/Kconfig
  video: vt8500: Adjust contrast in wm8505 framebuffer driver.
  video: fb: vt8500: Convert framebuffer drivers to standardized
    binding

 .../devicetree/bindings/video/via,vt8500-fb.txt    |   48 ++-----
 .../devicetree/bindings/video/wm,wm8505-fb.txt     |   32 +++--
 arch/arm/boot/dts/vt8500-bv07.dts                  |   34 ++---
 arch/arm/boot/dts/vt8500.dtsi                      |    4 +-
 arch/arm/boot/dts/wm8505-ref.dts                   |   34 ++---
 arch/arm/boot/dts/wm8505.dtsi                      |    4 +-
 arch/arm/boot/dts/wm8650-mid.dts                   |   36 +++--
 arch/arm/boot/dts/wm8650.dtsi                      |    4 +-
 arch/arm/boot/dts/wm8850-w70v2.dts                 |   40 +++---
 arch/arm/boot/dts/wm8850.dtsi                      |    4 +-
 drivers/video/Kconfig                              |   37 +++--
 drivers/video/vt8500lcdfb.c                        |   55 +++-----
 drivers/video/wm8505fb.c                           |  144 ++++++--------------
 drivers/video/wmt_ge_rops.h                        |   23 ++++
 include/linux/platform_data/video-vt8500lcdfb.h    |   31 -----
 15 files changed, 211 insertions(+), 319 deletions(-)
 delete mode 100644 include/linux/platform_data/video-vt8500lcdfb.h

-- 
1.7.9.5

