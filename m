Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaIEPgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:36:40 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58723 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaIEPgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:36:37 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        peppe.cavallaro@st.com
Subject: [PATCH v6 0/3]  Add ST dwc3 glue layer driver
Date: Fri,  5 Sep 2014 16:36:29 +0100
Message-Id: <1409931392-22340-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the ST glue logic which wraps the DWC3 controller
on STiH407 SoC family chipsets.

Changes since v5
 - Use of_platform_depopulate

Changes since v4
 - Fix bug with setting bits in usb control register
 - Remove superflous '\n'
 - Change default Kconfig to make default same as other platforms
 - Update dt doc example so that both usb2 and usb3 phys are using generic drivers/phy instead of drivers/usb/phy
 - Reconfigure ST glue logic regs in resume callback

Changes since v3
 - Various formating nits

Changes since v2
 - Use dr_mode for host/device static configuration
 - Manage shared reset signal to usbss to avoid hang if probing before usb3 phy
 - Remove DT checks and make driver depend on OF
 - Change some #define to use BIT macro
 - Make some comments clearer
 - Use kerneldoc for struct documentation
 - Remove udelay
 - Let DT create platform_devices, and remove legacy alloc
 - Change some logging levels to dev_dbg
 - Various whitespace and formatting cleanup
 - Use SIMPLE_DEV_PM_OPS()
 - Add const to of_device struct
 - Reorder header files alphabetically
 - Use devm_ioremap_resource instead of devm_request_and_ioremap
 - Remove of_match_ptr()

Changes since v1
 - Fix Kconfig mistake

Peter Griffin (3):
  usb: dwc3: add ST dwc3 glue layer to manage dwc3 HC
  usb: dwc3: dwc3-st: Add st-dwc3 devicetree bindings documentation
  MAINTAINERS: Add dwc3-st.c file to ARCH/STI architecture

 Documentation/devicetree/bindings/usb/dwc3-st.txt |  68 ++++
 MAINTAINERS                                       |   1 +
 drivers/usb/dwc3/Kconfig                          |   9 +
 drivers/usb/dwc3/Makefile                         |   1 +
 drivers/usb/dwc3/dwc3-st.c                        | 377 ++++++++++++++++++++++
 5 files changed, 456 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/dwc3-st.txt
 create mode 100644 drivers/usb/dwc3/dwc3-st.c

-- 
1.9.1

