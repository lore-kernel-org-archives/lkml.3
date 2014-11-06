Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaKFMv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:51:58 -0500
Received: from regular1.263xmail.com ([211.150.99.130]:33987 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKFMvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:51:55 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <c6e6a206f80f8990f1d01bd802a61f45>
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
        jay.xu@rock-chips.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: [PATCH V3 0/4] dw-hdmi: make imx hdmi publicly used by dw hdmi compatible platform
Date: Thu,  6 Nov 2014 19:21:53 +0800
Message-Id: <1415272913-56889-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415192101-6404-1-git-send-email-andy.yan@rock-chips.com>
References: <1415192101-6404-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found freescale imx6 and rockchip rk3288 and Ingenic JZ4780 (Xburst/MIPS)
use the interface compatible Designware HDMI IP, but they also have some
lightly difference, such as phy pll configuration, register width(imx hdmi
register is one byte, but rk3288 is 4 bytes width and can only access by word),
4K support(imx6 doesn't support 4k, but rk3288 does).

To reuse the imx-hdmi driver, we do this patch set:
patch (1): split out imx-soc code from imx-hdmi to dw_hdmi-imx.c
patch (2): move imx-hdmi to bridge/, and rename to dw-hdmi to
patch (3): add multi byte register access support
make this driver indepent of drm-imx . And we will add rockchip
platform specific code dw_hdmi-rockchip.c later, this is depend
on drm-rockchip.

Changes in V3:
- refactor multi byte register access, and split it
  to one indepent patch
- convert it to a drm_bridge driver

Changes in V2:
- use git format-patch -M to generate these patch
- remove change-id
- remove from


Andy Yan (3):
  imx-drm: imx-hdmi: split imx soc specific code from imx-hdmi
  dw-hdmi: move imx-hdmi to bridge/dw-hdmi
  dw-hdmi: add support for multi byte register width access

ykk (1):
  dw-hdmi: convert dw-hdmi to drm_bridge mode

 drivers/gpu/drm/bridge/Kconfig                     |   5 +
 drivers/gpu/drm/bridge/Makefile                    |   1 +
 .../imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c}        | 619 +++++++++------------
 .../imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h}        |   5 +-
 drivers/staging/imx-drm/Kconfig                    |   1 +
 drivers/staging/imx-drm/Makefile                   |   2 +-
 drivers/staging/imx-drm/dw_hdmi-imx.c              | 263 +++++++++
 include/drm/bridge/dw_hdmi.h                       |  52 ++
 8 files changed, 575 insertions(+), 373 deletions(-)
 rename drivers/{staging/imx-drm/imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c} (75%)
 rename drivers/{staging/imx-drm/imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h} (99%)
 create mode 100644 drivers/staging/imx-drm/dw_hdmi-imx.c
 create mode 100644 include/drm/bridge/dw_hdmi.h

-- 
1.9.1


