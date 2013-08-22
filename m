Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3HVW5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:57:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56729 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab3HVW5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:57:04 -0400
Message-Id: <e42576b69ef3d4e624fbfa2f32f6f79a931b55d6.1377202730.git.joshc@codeaurora.org>
In-Reply-To: <cover.1377202730.git.joshc@codeaurora.org>
References: <cover.1377202730.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Thu, 22 Aug 2013 14:59:06 -0500
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH RFC v2 3/5] spmi: add generic SPMI controller binding documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
I'm introducing this as an RFC, because there are set of assumptions
made in this binding spec, that currently hold true for the supported
controller/addressing scheme for the Snapdragon 800 series, but don't
necessarily hold true for SPMI in general.

  1. No use of Group Slave Identifiers (GSIDs)
     (SPMI allows for a slave to belong to zero or more groups specified
     by GSID, however this feature isn't currently implemented)

  2. No specification of Master Identifier (MID)
     (A "system integrator" allocates to each master a 2-bit MID, this
     currently isn't being specified, as it isn't needed by software for
     the PMIC Arb; not sure if this is of use to other SPMI controllers)

  3. Single SPMI master per controller

Effectively, only a subset of possible SPMI configurations are specified
in this document.

So, if it's considered necessary to provide a generic SPMI binding
specification, is it acceptable to only define a subset at this time,
expanding only when necessary, or shall I expand the definition to at
least address 1 & 2, even though they are of no use in the current
implementation?

 Documentation/devicetree/bindings/spmi/spmi.txt | 36 +++++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spmi/spmi.txt

diff --git a/Documentation/devicetree/bindings/spmi/spmi.txt b/Documentation/devicetree/bindings/spmi/spmi.txt
new file mode 100644
index 0000000..a01b064
--- /dev/null
+++ b/Documentation/devicetree/bindings/spmi/spmi.txt
@@ -0,0 +1,36 @@
+System Power Management Interface (SPMI) Controller
+
+This document defines a generic set of bindings for use by SPMI controllers.  A
+controller is modelled in device tree as a node with zero or more child nodes,
+each representing a unique slave on the bus.
+
+Required properties:
+- #address-cells : must be set to 1
+- #size-cells : must be set to 0
+
+Child nodes:
+
+An SPMI controller node can contain zero or more children.  Each child must
+have a reg property defining its 4-bit Unique Slave Identifier (USID) on the
+SPMI bus.  This is the ID that has been "statically assigned by the system
+integrator", as per the SPMI spec.
+
+Each child node represents a slave device on the bus.
+
+	controller@.. {
+		compatible = "...";
+		reg = <...>;
+
+		#address-cells = <1>;
+		#size-cells <0>;
+
+		child@0 {
+			compatible = "...";
+			reg = <0>;
+		};
+
+		child@7 {
+			compatible = "...";
+			reg = <7>;
+		};
+	};
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


