Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbaHHD6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 23:58:20 -0400
Received: from mail-pd0-f194.google.com ([209.85.192.194]:59252 "EHLO
	mail-pd0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaHHD6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 23:58:18 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>, heiko@sntech.de
Cc: dianders@chromium.org, olof@lixom.net, sonnyrao@chromium.org,
        addy.ke@rock-chips.com, cf@rock-chips.com, xjq@rock-chips.com,
        wulf@rock-chips.com, lyz@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, Kever Yang <kever.yang@rock-chips.com>,
        devicetree@vger.kernel.org, Matt Porter <mporter@linaro.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        linux-usb@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 0/4] Patches to add support for Rockchip dwc2 controller
Date: Fri,  8 Aug 2014 11:55:55 +0800
Message-Id: <1407470159-14722-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches to add support for dwc2 controller found in
Rockchip processors rk3066, rk3188 and rk3288,
and enable dts for rk3288 evb.

Changes in v5:
- max_transfer_size change to 65535 to met the requirement of
  header file
- change the sort order of dwc2 in rk3288.dtsi
- don't enable otg port for evb

Changes in v4:
- max_transfer_size change to 65536, this should be enough
  for most transfer, the hardware auto-detect will set this
  to 0x7ffff which may make dma_alloc_coherent fail when
  non-dword aligned buf from driver like usbnet happen.
- remove EHCI and HSIC dts patch for Doug had post it seprately.

Changes in v3:
- EHCI and HSIC move new for version 3.
- Rebase

Changes in v2:
- Split out dr_mode and rk3288 bindings.
- add compatible "snps,dwc2" bingding info
- set most parameters as driver auto-detect
- evb patch added in version 2

Kever Yang (4):
  Documentation: dt-bindings: add dt binding info for Rockchip dwc2
  usb: dwc2: add compatible data for rockchip soc
  ARM: dts: add rk3288 dwc2 controller support
  ARM: dts: Enable USB host1(dwc) on rk3288-evb

 Documentation/devicetree/bindings/usb/dwc2.txt |  3 +++
 arch/arm/boot/dts/rk3288-evb.dtsi              |  4 ++++
 arch/arm/boot/dts/rk3288.dtsi                  | 20 ++++++++++++++++++
 drivers/usb/dwc2/platform.c                    | 29 ++++++++++++++++++++++++++
 4 files changed, 56 insertions(+)

-- 
1.9.1

