Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaHGPVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:21:51 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62620 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaHGPVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:21:49 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v4 0/5] Add EHCI and OHCI drivers for STi SoC's
Date: Thu,  7 Aug 2014 16:21:39 +0100
Message-Id: <1407424904-19251-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series has been re-worked from v2 onwards to split out the ehci and ohci parts
into their own drivers / devices like most other ARM platforms based on
feedback from Arnd Bergmann (see here http://www.spinics.net/lists/linux-usb/msg111124.html. 

The ehci-platform & ohci-platform have been used as a basis for this in case we
wish to merge the drivers again in the future.

Changes since v3:
 - Make reset / power, clocks etc non optional dt options to simplify code
 - Get rid of non DT boot code left over from *hci-platform drivers
 - Remove DMA mask code
 - Remove pre_setup func ptr and configure ahb2st bus convertor in ehci_platform_reset
 - Unabstract and remove usb-st-common.c
 - Have one kconfig which enables both ehci-st & ohci-st drivers

Changes since v2:
 - Based on Arnd Berghman feedback, split out into 2 devices / drivers
 - Base drivers oh ehci-platform.c & ohci-platform.c with required extensions
   to allow possible re-merge in the furture.

Changes since v1:
 - Correct s/OCHI/OHCI/ spelling
 - Improve kconfig help message
 - Various formating / spelling nits identified by Lee Jones
 - Make driver depend on OF & remove node checks in code
 - Use devm_ioremap_resource
 - Remove unnecessary header files

Peter Griffin (5):
  usb: host: ehci-st: Add EHCI support for ST STB devices
  usb: host: ohci-st: Add OHCI driver support for ST STB devices
  usb: host: ehci-st: Add ehci-st devicetree bindings documentation
  usb: host: ohci-st: Add ohci-st devicetree bindings documentation
  MAINTAINERS: Add ehci-st.c and ohci-st.c to ARCH/STI architecture

 Documentation/devicetree/bindings/usb/ehci-st.txt |  39 +++
 Documentation/devicetree/bindings/usb/ohci-st.txt |  37 +++
 MAINTAINERS                                       |   2 +
 drivers/usb/host/Kconfig                          |   8 +
 drivers/usb/host/Makefile                         |   1 +
 drivers/usb/host/ehci-st.c                        | 363 ++++++++++++++++++++++
 drivers/usb/host/ohci-st.c                        | 337 ++++++++++++++++++++
 drivers/usb/host/usb-st-common.h                  |  31 ++
 8 files changed, 818 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ehci-st.txt
 create mode 100644 Documentation/devicetree/bindings/usb/ohci-st.txt
 create mode 100644 drivers/usb/host/ehci-st.c
 create mode 100644 drivers/usb/host/ohci-st.c
 create mode 100644 drivers/usb/host/usb-st-common.h

-- 
1.9.1

