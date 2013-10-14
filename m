Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab3JNVC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:02:56 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:44719 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3JNVCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:02:54 -0400
From: Marek Belisko <marek@goldelico.com>
To: tony@atomide.com, linux@arm.linux.org.uk, tomi.valkeinen@ti.com,
        plagnioj@jcrosoft.com
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        neilb@suse.de, hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 0/3] omapdss: venc: Add support for bypass and acbias.
Date: Mon, 14 Oct 2013 23:02:32 +0200
Message-Id: <1381784555-18344-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches is adding bypass and acbias functionality to omapdss venc driver.
In first patch we export updatin bypass and acbias in devconf1 register. Next patch
add handling for updating in venc driver and last patch add driver for opa362 which
is used on gta04 board and set bypass + acbias.

Marek Belisko (3):
  arm: omap2: Export devconf1 bypass and acbias.
  video: venc: Add new callback and handling for bypass and acbias
    setup.
  omapdss: Add OPA362 analog video amplifier driver.

 arch/arm/mach-omap2/Makefile                       |   2 +
 arch/arm/mach-omap2/control.h                      |   2 +
 arch/arm/mach-omap2/omap3-tvout.c                  |  36 +++
 drivers/video/omap2/displays-new/Kconfig           |   6 +
 drivers/video/omap2/displays-new/Makefile          |   1 +
 .../video/omap2/displays-new/amplifier-opa362.c    | 294 +++++++++++++++++++++
 drivers/video/omap2/dss/venc.c                     |  21 ++
 include/linux/omap-tvout.h                         |  14 +
 include/video/omap-panel-data.h                    |  17 ++
 include/video/omapdss.h                            |   2 +
 10 files changed, 395 insertions(+)
 create mode 100644 arch/arm/mach-omap2/omap3-tvout.c
 create mode 100644 drivers/video/omap2/displays-new/amplifier-opa362.c
 create mode 100644 include/linux/omap-tvout.h

-- 
1.8.1.2

