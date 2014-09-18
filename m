Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbaIRJgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:36:16 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:38692 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbaIRJgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:36:13 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <409713c7d9a5723a5e2ee812960ee3c8>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Mark yao <mark.yao@rock-chips.com>
To: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org,
        dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org,
        olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com,
        kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com,
        zyw@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com,
        kever.yang@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com, mark yao <yzq@rock-chips.com>
Subject: [PATCH v2 0/5] Add drm driver for Rockchip Socs 
Date: Thu, 18 Sep 2014 17:34:44 +0800
Message-Id: <1411032884-9233-1-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mark yao <yzq@rock-chips.com>

This a series of patches is a DRM Driver for Rockchip Socs, add support
for vop devices, eDP. Future patches will add additional encoders/connectors,
such as HDMI.

The basic "crtc" for rockchip is a "VOP" - Video Output Processor.
the vop devices found on Rockchip rk3288 Soc, rk3288 soc have two similar
Vop devices. Vop devices support iommu mapping, we use dma-mapping API with
ARM_DMA_USE_IOMMU.

Changes in v2:
- add DRM master device node to list all display nodes that comprise
  the graphics subsystem.
- use the component framework to defer main drm driver probe
  until all VOP devices have been probed.
- use dma-mapping API with ARM_DMA_USE_IOMMU, create dma mapping by
  master device and each vop device can shared the drm dma mapping.
- use drm_crtc_init_with_planes and drm_universal_plane_init.
- remove unnecessary middle layers.
- add cursor set, move funcs to rockchip drm crtc.
- use panel-simple driver for primary display.
- add vop and edp reset.

Tested on rk3288 pinky board, use eDP encoders/connector, boot and display OK

Mark yao (5):
  drm/rockchip: Add basic drm driver
  dt-bindings: video: Add for rockchip display subsytem
  dt-bindings: video: Add documentation for rockchip vop
  dt-bindings: video: Add documentation for rockchip edp
  drm/rockchip: Add support for Rockchip Soc EDP


-- 
1.7.9.5


