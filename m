Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaBCXKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:10:40 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46495 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaBCXI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:08:58 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v5 2/6] spmi: add generic SPMI controller binding documentation
Date: Mon,  3 Feb 2014 17:05:34 -0600
Message-Id: <1391468739-20987-3-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391468739-20987-1-git-send-email-joshc@codeaurora.org>
References: <1391468739-20987-1-git-send-email-joshc@codeaurora.org>
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
index 0000000..462a42f
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
+SPMI_USID (0) or SPMI_GSID (1) for Unique Slave ID or Group Slave ID respectively.
+These are the identifiers "statically assigned by the system integrator", as
+per the SPMI spec.
+
+Each child node must have one and only one 'reg' entry of type SPMI_USID.
+
+#include <dt-bindings/spmi/spmi.h>
+
+	spmi@.. {
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

