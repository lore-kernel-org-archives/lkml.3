Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaBTJyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:54:45 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:34766 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaBTJyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:54:38 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH RESEND v2 1/3] usb: chipidea: msm: Add device tree binding information
Date: Thu, 20 Feb 2014 11:53:08 +0200
Message-Id: <1392889988-24312-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <530512F1.3060304@cogentembedded.com>
References: <530512F1.3060304@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Document device tree binding information as required by
the Qualcomm USB controller.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../devicetree/bindings/usb/msm-hsusb.txt          |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
index 5ea26c6..d4e7e41 100644
--- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
+++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
@@ -15,3 +15,20 @@ Example EHCI controller device node:
 		usb-phy = <&usb_otg>;
 	};
 
+CI13xxx (Chipidea) USB controllers
+
+Required properties:
+- compatible:   should contain "qcom,ci-hdrc"
+- reg:          offset and length of the register set in the memory map
+- interrupts:   interrupt-specifier for the controller interrupt.
+- usb-phy:      phandle for the PHY device
+- dr_mode:      Sould be "peripheral"
+
+	gadget@f9a55000 {
+		compatible = "qcom,ci-hdrc";
+		reg = <0xf9a55000 0x400>;
+		dr_mode = "peripheral";
+		interrupts = <0 134 0>;
+		usb-phy = <&usb_otg>;
+	};
+
-- 
1.7.9.5

