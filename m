Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967969Ab3HIPkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:40:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36840 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965056Ab3HIPkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:40:35 -0400
From: Kumar Gala <galak@codeaurora.org>
To: balbi@ti.com, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: dwc3: core: clarify usb-phy array binding
Date: Fri,  9 Aug 2013 10:40:32 -0500
Message-Id: <1376062832-23288-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The binding spec wasn't clear that the order of the phandles in the
usb-phy array has meaning.  Clarify this point in the binding that
it should be <USB2-HS-PHY, USB3-SS-PHY>.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 Documentation/devicetree/bindings/usb/dwc3.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
index 7a95c65..8a9770b 100644
--- a/Documentation/devicetree/bindings/usb/dwc3.txt
+++ b/Documentation/devicetree/bindings/usb/dwc3.txt
@@ -6,7 +6,9 @@ Required properties:
  - compatible: must be "synopsys,dwc3"
  - reg : Address and length of the register set for the device
  - interrupts: Interrupts used by the dwc3 controller.
- - usb-phy : array of phandle for the PHY device
+ - usb-phy : array of phandle for the PHY device.  The first element
+   in the array is expected to be a handle to the USB2/HS PHY and
+   the second element is expected to be a handle to the USB3/SS PHY
 
 Optional properties:
  - tx-fifo-resize: determines if the FIFO *has* to be reallocated.
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

