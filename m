Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaKKMtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:49:46 -0500
Received: from regular1.263xmail.com ([211.150.99.133]:57624 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaKKMto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:49:44 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <286562607aa5948d6e9c767e8d672ec8>
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
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com
Subject: [PATCH v7 0/7] dw-hdmi: convert imx hdmi to bridge/dw-hdmi
Date: Tue, 11 Nov 2014 20:48:44 +0800
Message-Id: <1415710124-11887-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We found freescale imx5 and rockchip rk3288 and Ingenic JZ4780 (Xburst/MIPS)
use the interface compatible Designware HDMI IP, but they also have some
lightly differences, such as phy pll configuration, register width(imx hdmi
register is one byte, but rk3288 is 4 bytes width and can only access by word),
4K support(imx6 doesn't support 4k, but rk3288 does).

To reuse the imx-hdmi driver, we do this patch set:
(1): fix some CodingStyle warning to make checkpatch happy
(2): split out imx-soc code from imx-hdmi to dw_hdmi-imx.c
(3): move imx-hdmi to bridge/dw-hdmi, and convert it to a drm_bridge driver
And we will add rockchip platform specific code dw_hdmi-rockchip.c later,
which is depend on drm-rockchip.

Changes in v7:
- remove unused variables from structure dw_hdmi
- remove a wrong modification
- add copyrights for dw_hdmi-imx.c

Changes in v6:
- rearrange the patch order
- move some modification to  patch#6
- refactor register access without reg_shift
- move some modification from patch#5

Changes in v5:
- refactor reg-io-width

Changes in v4:
- fix checkpatch CHECK
- defer probe ddc i2c adapter

Changes in v3:
- split multi register access to one indepent patch

Changes in v2:
- use git format -M to generate these patch

Andy Yan (6):
  staging: imx-drm: imx-hdmi: make checkpatch happy
  staging: imx-drm: imx-hdmi: return defer if can't get ddc i2c adapter
  staging: imx-drm: imx-hdmi: split imx soc specific code from imx-hdmi
  staging: imx-drm: imx-hdmi: move imx-hdmi to bridge/dw-hdmi
  drm: bridge/dw-hdmi: add support for multi byte register width access
  dt-bindings: add document for dw-hdmi

Yakir Yang (1):
  drm: bridge/dw-hdmi: convert dw-hdmi to drm_bridge mode

 .../devicetree/bindings/drm/bridge/dw-hdmi.txt     |  38 ++
 drivers/gpu/drm/bridge/Kconfig                     |   5 +
 drivers/gpu/drm/bridge/Makefile                    |   1 +
 .../imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c}        | 723 +++++++++------------
 .../imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h}        |   5 +-
 drivers/staging/imx-drm/Kconfig                    |   1 +
 drivers/staging/imx-drm/Makefile                   |   2 +-
 drivers/staging/imx-drm/dw_hdmi-imx.c              | 266 ++++++++
 include/drm/bridge/dw_hdmi.h                       |  52 ++
 9 files changed, 670 insertions(+), 423 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt
 rename drivers/{staging/imx-drm/imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c} (71%)
 rename drivers/{staging/imx-drm/imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h} (99%)
 create mode 100644 drivers/staging/imx-drm/dw_hdmi-imx.c
 create mode 100644 include/drm/bridge/dw_hdmi.h

-- 
1.9.1


