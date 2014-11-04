Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaKDNgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:36:07 -0500
Received: from regular2.263xmail.com ([211.157.152.4]:46505 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbaKDNgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:36:01 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <84658358a9ce1248373bc6a262cc3eec>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Andy yan <andy.yan@rock-chips.com>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH 0/2] make imx hdmi publicly used by dw hdmi compatible platform
Date: Tue,  4 Nov 2014 21:33:10 +0800
Message-Id: <1415107992-34289-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy yan <andy.yan@rock-chips.com>

We found freescale imx6 and rockchip rk3288 and Ingenic JZ4780 (Xburst/MIPS)
use the interface compatible Designware HDMI IP, but they also have some
lightly difference, such as phy pll configuration, register width(imx hdmi
register is one byte, but rk3288 is 4 bytes width and can only access by word),
4K support(imx6 doesn't support 4k, but rk3288 does).

To reuse the imx-hdmi driver, we do this patch set:
patch (1): split out imx-soc code from imx-hdmi to dw_hdmi-imx.c
patch (2): move imx-hdmi to bridge/, and rename to dw-hdmi to
make this driver indepent of drm-imx . And we will add rockchip 
platform specific code dw_hdmi-rockchip.c later, this is depend
on drm-rockchip.

Andy Yan (1):
  imx-drm: imx-hdmi: split imx soc specific code from imx-hdmi

Andy yan (1):
  move imx-hdmi to bridge/dw-hdmi

 drivers/gpu/drm/bridge/Kconfig        |    5 +
 drivers/gpu/drm/bridge/Makefile       |    1 +
 drivers/gpu/drm/bridge/dw_hdmi.c      | 1651 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/bridge/dw_hdmi.h      | 1032 +++++++++++++++++++
 drivers/staging/imx-drm/Kconfig       |    1 +
 drivers/staging/imx-drm/Makefile      |    2 +-
 drivers/staging/imx-drm/dw_hdmi-imx.c |  214 ++++
 drivers/staging/imx-drm/imx-hdmi.c    | 1767 ---------------------------------
 drivers/staging/imx-drm/imx-hdmi.h    | 1032 -------------------
 include/drm/bridge/dw_hdmi.h          |  114 +++
 10 files changed, 3019 insertions(+), 2800 deletions(-)
 create mode 100644 drivers/gpu/drm/bridge/dw_hdmi.c
 create mode 100644 drivers/gpu/drm/bridge/dw_hdmi.h
 create mode 100644 drivers/staging/imx-drm/dw_hdmi-imx.c
 delete mode 100644 drivers/staging/imx-drm/imx-hdmi.c
 delete mode 100644 drivers/staging/imx-drm/imx-hdmi.h
 create mode 100644 include/drm/bridge/dw_hdmi.h

-- 
1.8.3.2


