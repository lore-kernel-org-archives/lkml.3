Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbaHFRDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:03:21 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43175 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770AbaHFRDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:03:19 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH v3 0/6] Add EHCI and OHCI drivers for STi SoC's
Date: Wed,  6 Aug 2014 18:03:03 +0100
Message-Id: <1407344589-24863-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the OHCI and EHCI on-chip controllers
found in STi consumer electronics SoC's from STMicroelectronics.

The series has been re-worked from v2 to split out the ehci and ohci parts
into their own drivers / devices like most other ARM platforms based on
feedback from Arnd Bergmann (see here http://www.spinics.net/lists/linux-usb/msg111124.html. 

The ehci-platform & ohci-platform have been used as a basis for this in case we
wish to merge the drivers again in the future.

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

Peter Griffin (6):
  usb: host: usb-st-common: Add common code required by ohci-st and
    ehci-st
  usb: host: ehci-st: Add EHCI support for ST STB devices
  usb: host: ohci-st: Add OHCI driver support for ST STB devices
  usb: host: ehci-st: Add ehci-st devicetree bindings documentation
  usb: host: ohci-st: Add ohci-st devicetree bindings documentation
  MAINTAINERS: Add ehci-st.c and ohci-st.c to ARCH/STI architecture

 Documentation/devicetree/bindings/usb/ehci-st.txt |  41 +++
 Documentation/devicetree/bindings/usb/ohci-st.txt |  40 +++
 MAINTAINERS                                       |   3 +-
 drivers/usb/host/Kconfig                          |  13 +
 drivers/usb/host/Makefile                         |   2 +
 drivers/usb/host/ehci-st.c                        | 334 ++++++++++++++++++++++
 drivers/usb/host/ohci-st.c                        | 302 +++++++++++++++++++
 drivers/usb/host/usb-st-common.c                  |  99 +++++++
 drivers/usb/host/usb-st-common.h                  |  34 +++
 9 files changed, 867 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/usb/ehci-st.txt
 create mode 100644 Documentation/devicetree/bindings/usb/ohci-st.txt
 create mode 100644 drivers/usb/host/ehci-st.c
 create mode 100644 drivers/usb/host/ohci-st.c
 create mode 100644 drivers/usb/host/usb-st-common.c
 create mode 100644 drivers/usb/host/usb-st-common.h

-- 
1.9.1

