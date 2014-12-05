Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaLEGXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:23:21 -0500
Received: from lucky1.263xmail.com ([211.157.147.130]:50400 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaLEGXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:23:19 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <49b36c5c591a418497ade937b399028f>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, Philipp Zabel <p.zabel@pengutronix.de>, heiko@sntech.de,
        fabio.estevam@freescale.com, rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, vladimir_zapolskiy@mentor.com,
        Andy Yan <andy.yan@rock-chips.com>
Subject: [PATCH v18 0/12] dw-hdmi: convert imx hdmi to bridge/dw_hdmi
Date: Fri,  5 Dec 2014 14:22:44 +0800
Message-Id: <1417760564-16858-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We found Freescale imx6 and Rockchip rk3288 and Ingenic JZ4780 (Xburst/MIPS)
use the interface compatible Designware HDMI IP, but they also have some
lightly differences, such as phy pll configuration, register width(imx hdmi
register is one byte, but rk3288 is 4 bytes width and can only be accessed
by word), 4K support(imx6 doesn't support 4k, but rk3288 does), and HDMI2.0
support.

To reuse the imx-hdmi driver, we make this patch set:
(1): fix some CodingStyle warning to make checkpatch happy
(2): convert imx-hdmi to drm_bridge
(3): split platform specific code
(4): move imx-hdmi to bridge/dw_hdmi
(5): extend dw_hdmi.c to support rk3288 hdmi
(6): add rockchip rk3288 platform specific code dw_hdmi-rockchip.c

Changes in v18:
- remove a multiple blank lines in imx-hdmi.c
- fix a checkpatch warning in imx-hdmi_pltfm.c
- add port bindings
- correct some spelling mistakes in dw_hdmi bindings doc
- correct some spelling mistakes in dw_hdmi-rockchip bindings doc

Changes in v17:
- remove platform device stuff, adviced by Russell King
- remove prompt message of dw_hdmi, adviced by Russel King
- parse resource and irq in platform driver

Changes in v16:
- use the common binding for the clocks
- describe ddc-i2c-bus as optional
- add common clocks bindings
- modify clocks bindings
- descrbie ddc-i2c-bus as optional

Changes in v15:
- add prefix dw_hdmi/DW_HDMI for public used dw_hdmi structs
  adviced by Philipp Zabel
- remove THIS_MODULE in platform driver
- remove unio of the multi-byte register access, adviced by Philipp Zabel
- remove THIS_MODULE in platform driver

Changes in v14:
- add defer probing, adviced by Philipp Zabel
- remove drm_connector_register, because imx-drm core has registered
connector

Changes in v13:
- patch against drm-next
- split platform specific phy configuration
- split phy configuration from patch#4

Changes in v12:
- refactor of_node_put(ddc_node)
- squash patch <convert dw_hdmi to drm_bridge>
- add comment for the depend on patch

Changes in v11:
- squash patch  <split some phy configuration to platform driver>

Changes in v10:
- split generic dw_hdmi.c improvements from patch#11 (add rk3288 support)
- add more display mode support mpll configuration for rk3288

Changes in v9:
- move some phy configuration to platform driver

Changes in v8:
- correct some spelling mistake
- modify ddc-i2c-bus and interrupt description
- Add documentation for rockchip dw hdmi

Changes in v7:
- remove unused variables from structure dw_hdmi
- remove a wrong modification
- add copyrights for dw_hdmi-imx.c

Changes in v6:
- rearrange the patch order
- refactor register access without reg_shift

Changes in v5:
- refactor reg-io-width

Changes in v4:
- fix checkpatch CHECK
- defer probe ddc i2c adapter

Changes in v3:
- split multi-register access to one indepent patch

Andy Yan (12):
  drm: imx: imx-hdmi: make checkpatch happy
  drm: imx: imx-hdmi: return defer if can't get ddc i2c adapter
  drm: imx: imx-hdmi: convert imx-hdmi to drm_bridge mode
  drm: imx: imx-hdmi: split phy configuration to platform driver
  drm: imx: imx-hdmi: move imx-hdmi to bridge/dw_hdmi
  dt-bindings: add document for dw_hdmi
  drm: bridge/dw_hdmi: add support for multi-byte register width access
  drm: bridge/dw_hdmi: add mode_valid support
  drm: bridge/dw_hdmi: clear i2cmphy_stat0 reg in hdmi_phy_wait_i2c_done
  drm: bridge/dw_hdmi: add function dw_hdmi_phy_enable_spare
  dt-bindings: Add documentation for rockchip dw hdmi
  drm: bridge/dw_hdmi: add rockchip rk3288 support

 .../devicetree/bindings/drm/bridge/dw_hdmi.txt     |  50 ++
 .../devicetree/bindings/video/dw_hdmi-rockchip.txt |  46 ++
 drivers/gpu/drm/bridge/Kconfig                     |   5 +
 drivers/gpu/drm/bridge/Makefile                    |   1 +
 .../gpu/drm/{imx/imx-hdmi.c => bridge/dw_hdmi.c}   | 717 ++++++++++-----------
 .../gpu/drm/{imx/imx-hdmi.h => bridge/dw_hdmi.h}   |   4 +-
 drivers/gpu/drm/imx/Kconfig                        |   1 +
 drivers/gpu/drm/imx/Makefile                       |   2 +-
 drivers/gpu/drm/imx/dw_hdmi-imx.c                  | 258 ++++++++
 drivers/gpu/drm/rockchip/Kconfig                   |  10 +
 drivers/gpu/drm/rockchip/Makefile                  |   2 +
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c        | 341 ++++++++++
 include/drm/bridge/dw_hdmi.h                       |  61 ++
 13 files changed, 1111 insertions(+), 387 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
 create mode 100644 Documentation/devicetree/bindings/video/dw_hdmi-rockchip.txt
 rename drivers/gpu/drm/{imx/imx-hdmi.c => bridge/dw_hdmi.c} (72%)
 rename drivers/gpu/drm/{imx/imx-hdmi.h => bridge/dw_hdmi.h} (99%)
 create mode 100644 drivers/gpu/drm/imx/dw_hdmi-imx.c
 create mode 100644 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
 create mode 100644 include/drm/bridge/dw_hdmi.h

-- 
1.9.1


