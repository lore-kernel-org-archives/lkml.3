Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaKHF1L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 00:27:11 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:37362 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaKHF1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 00:27:09 -0500
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <dc91c35e269e0e57a6b45533a22f4fca>
X-DNS-TYPE: 1
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
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com
Subject: [PATCH V5 0/7]dw-hdmi: convert imx hdmi to bridge/dw-hdmi
Date: Sat,  8 Nov 2014 13:26:50 +0800
Message-Id: <1415424410-7364-1-git-send-email-andy.yan@rock-chips.com>
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
make this driver indepent of drm-imx .
And we will add rockchip platform specific code dw_hdmi-rockchip.c later,
this is depend on drm-rockchip.

Changes in V5:
- refactor reg-io-width process
- add dt-bindings
Changes in V4:
- return defer if can't get ddc i2c adapter
- fix checkpatch warns

Changes in V3:
- refactor multi byte register access, and split it
  to one indepent patch
- convert it to a drm_bridge driver

Changes in V2:
- use git format-patch -M to generate these patch
- remove change-id
- remove from 


Andy Yan (6):
  imx-drm: imx-hdmi: split imx soc specific code from imx-hdmi
  dw-hdmi: move imx-hdmi to bridge/dw-hdmi
  dw-hdmi: make checkpatch happy
  dw-hdmi: return defer if can't get ddc i2c adapter
  dw-hdmi: add support for multi byte register width access
  dt-bindings: add document for dw-hdmi

Yakir Yang (1):
  dw-hdmi: convert dw-hdmi to drm_bridge mode

 .../devicetree/bindings/drm/bridge/dw-hdmi.txt     |  38 ++
 drivers/gpu/drm/bridge/Kconfig                     |   5 +
 drivers/gpu/drm/bridge/Makefile                    |   1 +
 .../imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c}        | 714 +++++++++------------
 .../imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h}        |   5 +-
 drivers/staging/imx-drm/Kconfig                    |   1 +
 drivers/staging/imx-drm/Makefile                   |   2 +-
 drivers/staging/imx-drm/dw_hdmi-imx.c              | 263 ++++++++
 include/drm/bridge/dw_hdmi.h                       |  52 ++
 9 files changed, 661 insertions(+), 420 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt
 rename drivers/{staging/imx-drm/imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c} (71%)
 rename drivers/{staging/imx-drm/imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h} (99%)
 create mode 100644 drivers/staging/imx-drm/dw_hdmi-imx.c
 create mode 100644 include/drm/bridge/dw_hdmi.h

-- 
1.9.1

