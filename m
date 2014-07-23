Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbaGWOs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:48:56 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:39126 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616AbaGWOsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:48:53 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        peppe.cavallaro@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org
Subject: [PATCH v3 0/3] Add ST dwc3 glue layer driver
Date: Wed, 23 Jul 2014 15:48:32 +0100
Message-Id: <1406126915-30601-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the ST glue logic which wraps the DWC3 controller
on STiH407 SoC family chipsets.

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

Peter Griffin (3):
  usb: dwc3: add ST dwc3 glue layer to manage dwc3 HC
  usb: dwc3: dwc3-st: Add st-dwc3 devicetree bindings documentation
  MAINTAINERS: Add dwc3-st.c file to ARCH/STI architecture

 Documentation/devicetree/bindings/usb/dwc3-st.txt |  69 +++++
 MAINTAINERS                                       |   1 +
 drivers/usb/dwc3/Kconfig                          |   9 +
 drivers/usb/dwc3/Makefile                         |   1 +
 drivers/usb/dwc3/dwc3-st.c                        | 337 ++++++++++++++++++++++
 5 files changed, 417 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/dwc3-st.txt
 create mode 100644 drivers/usb/dwc3/dwc3-st.c

-- 
1.9.1

