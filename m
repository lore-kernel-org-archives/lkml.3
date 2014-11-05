Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaKEMzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:55:33 -0500
Received: from regular1.263xmail.com ([211.150.99.131]:50653 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaKEMz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:55:29 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <9c5f8861405c2e84b598a8a16e0b614b>
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
Subject: [PATCH V2 0/2] make imx hdmi publicly used by dw hdmi compatible platform
Date: Wed,  5 Nov 2014 20:54:59 +0800
Message-Id: <1415192101-6404-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
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
make this driver indepent of drm-imx . And we will add rockchip
platform specific code dw_hdmi-rockchip.c later, this is depend
on drm-rockchip.

Changes in V2:
- use git format-patch -M to generate these patch
- remove change-id
- remove from

Andy Yan (2):
  imx-drm: imx-hdmi: split imx soc specific code from imx-hdmi
  move imx-hdmi to bridge/dw-hdmi

 drivers/gpu/drm/bridge/Kconfig                     |   5 +
 drivers/gpu/drm/bridge/Makefile                    |   1 +
 .../imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c}        | 964 +++++++++------------
 .../imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h}        |   0
 drivers/staging/imx-drm/Kconfig                    |   1 +
 drivers/staging/imx-drm/Makefile                   |   2 +-
 drivers/staging/imx-drm/dw_hdmi-imx.c              | 214 +++++
 include/drm/bridge/dw_hdmi.h                       | 114 +++
 8 files changed, 760 insertions(+), 541 deletions(-)
 rename drivers/{staging/imx-drm/imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c} (57%)
 rename drivers/{staging/imx-drm/imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h} (100%)
 create mode 100644 drivers/staging/imx-drm/dw_hdmi-imx.c
 create mode 100644 include/drm/bridge/dw_hdmi.h

-- 
1.9.1


