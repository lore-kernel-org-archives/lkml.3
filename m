Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaI3Aeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:34:50 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10865 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754816AbaI3Aes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:34:48 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Suman Anna <s-anna@ti.com>
Subject: [RFC 1/7] soc: qcom: Add device tree binding for SMEM
Date: Mon, 29 Sep 2014 17:34:45 -0700
Message-ID: <1412037291-16880-2-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree binding documentation for the Qualcom Shared Memory
manager.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---

Exposed by this node is a set of items of different sizes. For many things a
standard of_xlate method of referencing the individual nodes would be
preferable, so a #something-cells would make sense. We do however also needs
access to these items without explicitly stating the references in devicetree
(e.g. SMD references 257 of these). I haven't found any good example of how to
implement this, so suggestions are welcome.

Note that the hwspinlock reference is not yet supported in the mainline, but
this will likely need a few iterations so I wanted to get this out.

 .../devicetree/bindings/soc/qcom/qcom,smem.txt     |   34 ++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,smem.txt

diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,smem.txt b/Documentation/devicetree/bindings/soc/qcom/qcom,smem.txt
new file mode 100644
index 0000000..ddd58c7
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,smem.txt
@@ -0,0 +1,34 @@
+Qualcomm Shared Memory binding
+
+This binding describes the Qualcomm Shared Memory, used to share data between
+various subsystems and OSes in Qualcomm platforms.
+
+- compatible:
+	Usage: required
+	Value type: <stringlist>
+	Definition: must be:
+		    "qcom,smem"
+
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: base address and size pair for each area representing the
+		    shared memory. The first pair will must represent the "main"
+		    area, where the shared memory header and table-of-content
+		    can be found.
+
+- hwspinlocks:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: reference to a hwspinlock used to protect allocations from
+		    the shared memory
+
+= EXAMPLE
+
+        smem: smem@fa00000 {
+                compatible = "qcom,smem";
+                reg = <0x0fa00000 0x200000>,
+                      <0xfc428000 0x4000>;
+
+                hwspinlocks = <&tcsr_mutex 3>;
+        };
-- 
1.7.9.5

