Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab3J1TQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 15:16:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45244 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab3J1TOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 15:14:10 -0400
Message-Id: <ed3edf9766cc2a633b1a9f21e4080c648b51199a.1382985169.git.joshc@codeaurora.org>
In-Reply-To: <cover.1382985169.git.joshc@codeaurora.org>
References: <cover.1382985169.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Mon, 28 Oct 2013 13:12:35 -0500
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH v3 03/10] spmi: add generic SPMI controller binding
 documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 Documentation/devicetree/bindings/spmi/spmi.txt | 41 +++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spmi/spmi.txt

diff --git a/Documentation/devicetree/bindings/spmi/spmi.txt b/Documentation/devicetree/bindings/spmi/spmi.txt
new file mode 100644
index 0000000..32a180d
--- /dev/null
+++ b/Documentation/devicetree/bindings/spmi/spmi.txt
@@ -0,0 +1,41 @@
+System Power Management Interface (SPMI) Controller
+
+This document defines a generic set of bindings for use by SPMI controllers.  A
+controller is modelled in device tree as a node with zero or more child nodes,
+each representing a unique slave on the bus.
+
+Required properties:
+- #address-cells : must be set to 2
+- #size-cells : must be set to 0
+
+Child nodes:
+
+An SPMI controller node can contain zero or more child nodes representing slave
+devices on the bus.  Child 'reg' properties are specified as an address, type
+pair.  The address must be in the range 0-15 (4 bits).  The type must be one of
+SPMI_USID or SPMI_GSID (1) for Unique Slave ID or Group Slave ID respectively.
+These are the identifiers "statically assigned by the system integrator", as
+per the SPMI spec.
+
+Each child node must have one and only one 'reg' entry of type SPMI_USID.
+
+#include <dt-bindings/spmi/spmi.h>
+
+	controller@.. {
+		compatible = "...";
+		reg = <...>;
+
+		#address-cells = <2>;
+		#size-cells <0>;
+
+		child@0 {
+			compatible = "...";
+			reg = <0 SPMI_USID>;
+		};
+
+		child@7 {
+			compatible = "...";
+			reg = <7 SPMI_USID
+			       3 SPMI_GSID>;
+		};
+	};
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


