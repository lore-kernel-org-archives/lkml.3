Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaKKMNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:13:12 -0500
Received: from mail-pd0-f194.google.com ([209.85.192.194]:44126 "EHLO
	mail-pd0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaKKMNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:13:09 -0500
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, Zubair.Kakakhel@imgtec.com, rmk+kernel@arm.linux.org.uk,
        fabio.estevam@freescale.com, heiko@sntech.de, djkurtz@chromium.org,
        ykk@rock-chips.com
Cc: Andy Yan <andy.yan@rock-chips.com>, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, dri-devel@lists.freedesktop.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Inki Dae <inki.dae@samsung.com>, Lucas Stach <l.stach@pengutronix.de>,
        Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Airlie <airlied@redhat.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>, Sean Paul <seanpaul@chromium.org>
Subject: [PATCH v7 0/7] dw-hdmi: convert imx hdmi to bridge/dw-hdmi
Date: Tue, 11 Nov 2014 20:12:25 +0800
Message-Id: <1415707952-11415-1-git-send-email-andy.yan@rock-chips.com>
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

