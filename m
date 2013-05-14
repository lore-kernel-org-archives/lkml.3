Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3ENMFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:05:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17936 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3ENMFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:05:18 -0400
X-AuditID: cbfee691-b7fef6d000002d62-08-5192287c3305
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org,
        jencce.kernelmentor@gmail.com, sfr@canb.auug.org.au,
        gautam.vivek@samsung.com, Felipe Balbi <balbi@ti.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] usb: dwc3: Fix compilation break when building with
 USB_DWC3_DUAL_ROLE=y
Date: Tue, 14 May 2013 17:32:16 +0530
Message-id: <1368532936-3768-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <CAFp+6iG9eGsJT3PcjN3DMwEF1z2vzmQUK+0spx6JV9FsacRRhw@mail.gmail.com>
References: <CAFp+6iG9eGsJT3PcjN3DMwEF1z2vzmQUK+0spx6JV9FsacRRhw@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkWrdGY1KgwcLrxhYH79dbvH++ntmi
	7cpBdovmxevZLLbO389scez6RGaLy7vmsFnMXtLPYrFoWSuzxda9V9kduDzu72X3aLxxg81j
	56y77B6L97xk8tg/dw27R9+WVYwex29sZ/L4vEkugCOKyyYlNSezLLVI3y6BK2PNxA7GgiUS
	FdtfXGVpYHwj0sXIySEhYCLxcetLZghbTOLCvfVsXYxcHEICSxklDv15ywxT9PPUUkaIxCJG
	iaOPO9hBEkICU5gkPi/xBLHZBHQlmt7uYgSxRQQiJVY23GIGaWAWOMEoseLrDLAGYYFoievr
	l4HZLAKqEhs3XgCzeQXcJc7e6WCB2KYg8eb2M7DNnALBEp3zfjNBLAuQ2PR7KdhQCYFT7BKt
	Z/5BDRKQ+Db5EFAzB1BCVmLTAairJSUOrrjBMoFReAEjwypG0dSC5ILipPQiU73ixNzi0rx0
	veT83E2MwAg5/e/ZxB2M9w9YH2JMBho3kVlKNDkfGGF5JfGGxmZGFqYmpsZG5pZmpAkrifOq
	t1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDc3LfpdsObhcdUFm74xRCsc2jTw69sK79M
	FWG6+l5/utayw5wbX1yYbWT0slh+Lve76ALRiYvOtEUWzQxvPPJZnsvxRsJ9rgpW7Z3frU29
	hPbUHQgQPdrA5FssMW313s9TsifcPXVP/86SBwwXYuuPsuySrfux56mH7dVtDga7ZXzVI7lv
	qrgxKLEUZyQaajEXFScCAP0YlpKmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jAd0ajUmBBjfualgcvF9v8f75emaL
	tisH2S2aF69ns9g6fz+zxbHrE5ktLu+aw2Yxe0k/i8WiZa3MFlv3XmV34PK4v5fdo/HGDTaP
	nbPusnss3vOSyWP/3DXsHn1bVjF6HL+xncnj8ya5AI6oBkabjNTElNQihdS85PyUzLx0WyXv
	4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKAblRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0
	Ruj6hgTB9RgZoIGENYwZayZ2MBYskajY/uIqSwPjG5EuRk4OCQETiZ+nljJC2GISF+6tZ+ti
	5OIQEljEKHH0cQc7SEJIYAqTxOclniA2m4CuRNPbXWANIgKREisbbjGDNDALnGCUWPF1BliD
	sEC0xPX1y8BsFgFViY0bL4DZvALuEmfvdLBAbFOQeHP7GTOIzSkQLNE57zcTxLIAiU2/lzJP
	YORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4/p5J72Bc1WBxiFGAg1GJh/fFjwmB
	QqyJZcWVuYcYJTiYlUR4L3NPChTiTUmsrEotyo8vKs1JLT7EmAx01URmKdHkfGBqyCuJNzQ2
	MTc1NrU0sTAxsyRNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRpZ308s4NkvM3jLvm8th
	mxnLLHsmC7ItVYnj2H6uLH5DjHep87pTaak6rM8vaa3dMk1Q3mZ+5mP7do2zb/cZyebcVm61
	jX4Tt31Fzue1sofnLD4Zsrf9TthM4T+Ri9a9Pj/bUmBP5g1J02Oc1bd+x61umPo0omCX37u2
	yByhHcfDbyVz3JCb7afEUpyRaKjFXFScCAAkYJB5AwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit:
388e5c5 usb: dwc3: remove dwc3 dependency on host AND gadget
breaks compilation when
USB=y, USB_GADGET=m, USB_DWC3=y and USB_DWC3_DUAL_ROLE=y.

drivers/built-in.o: In function `dwc3_gadget_giveback':
drivers/usb/dwc3/gadget.c:271: undefined reference to `usb_gadget_unmap_request'
drivers/built-in.o: In function `__dwc3_gadget_kick_transfer':
drivers/usb/dwc3/gadget.c:1005: undefined reference to `usb_gadget_unmap_request'
drivers/built-in.o: In function `__dwc3_gadget_ep_queue':
drivers/usb/dwc3/gadget.c:1073: undefined reference to `usb_gadget_map_request'
drivers/built-in.o: In function `dwc3_gadget_reset_interrupt':
drivers/usb/dwc3/gadget.c:2165: undefined reference to `usb_gadget_set_state'
drivers/built-in.o: In function `dwc3_gadget_init':
drivers/usb/dwc3/gadget.c:2647: undefined reference to `usb_add_gadget_udc'
drivers/built-in.o: In function `dwc3_gadget_exit':
drivers/usb/dwc3/gadget.c:2681: undefined reference to `usb_del_gadget_udc'
drivers/built-in.o: In function `__dwc3_ep0_do_control_data':
drivers/usb/dwc3/ep0.c:929: undefined reference to `usb_gadget_map_request'
drivers/usb/dwc3/ep0.c:906: undefined reference to `usb_gadget_map_request'
drivers/built-in.o: In function `dwc3_ep0_set_config':
drivers/usb/dwc3/ep0.c:575: undefined reference to `usb_gadget_set_state'
drivers/built-in.o: In function `dwc3_ep0_set_address':
drivers/usb/dwc3/ep0.c:520: undefined reference to `usb_gadget_set_state'
drivers/usb/dwc3/ep0.c:522: undefined reference to `usb_gadget_set_state'
drivers/built-in.o: In function `dwc3_ep0_set_config':
drivers/usb/dwc3/ep0.c:556: undefined reference to `usb_gadget_set_state'

Making changes similar to patch:
71a5e61 usb: chipidea: fix and improve dependencies if usb host or gadget support is built as module

Let us limit the DWC3 mode to depend on corresponding usb-subsystem
and USB_DWC3.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/usb/dwc3/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index ea5ee9c..757aa18 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -19,21 +19,21 @@ choice
 
 config USB_DWC3_HOST
 	bool "Host only mode"
-	depends on USB
+	depends on USB=y || USB=USB_DWC3
 	help
 	  Select this when you want to use DWC3 in host mode only,
 	  thereby the gadget feature will be regressed.
 
 config USB_DWC3_GADGET
 	bool "Gadget only mode"
-	depends on USB_GADGET
+	depends on USB_GADGET=y || USB_GADGET=USB_DWC3
 	help
 	  Select this when you want to use DWC3 in gadget mode only,
 	  thereby the host feature will be regressed.
 
 config USB_DWC3_DUAL_ROLE
 	bool "Dual Role mode"
-	depends on (USB && USB_GADGET)
+	depends on ((USB=y || USB=USB_DWC3) && (USB_GADGET=y || USB_GADGET=USB_DWC3))
 	help
 	  This is the default mode of working of DWC3 controller where
 	  both host and gadget features are enabled.
-- 
1.7.6.5

