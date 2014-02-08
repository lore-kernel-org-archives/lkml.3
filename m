Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaBHAtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 19:49:39 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3260 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbaBHAtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 19:49:09 -0500
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: <s-anna@ti.com>, <rob.herring@calxeda.com>, <rafael.j.wysocki@intel.com>,
        <mark.langsdorf@calxeda.com>, <tony@atomide.com>,
        <omar.ramirez@copitl.com>
CC: <gregkh@linuxfoundation.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 2/6] mailbox: document bindings
Date: Fri, 7 Feb 2014 16:50:15 -0800
Message-ID: <1391820619-25487-3-git-send-email-courtney.cavin@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
---
 .../devicetree/bindings/mailbox/mailbox.txt        | 44 ++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mailbox/mailbox.txt

diff --git a/Documentation/devicetree/bindings/mailbox/mailbox.txt b/Documentation/devicetree/bindings/mailbox/mailbox.txt
new file mode 100644
index 0000000..846eb49
--- /dev/null
+++ b/Documentation/devicetree/bindings/mailbox/mailbox.txt
@@ -0,0 +1,44 @@
+Binding documentation for mailbox providers and consumers
+--
+
+Mailbox providers may be represented by any node in a device tree.  These
+nodes are designated as mailbox providers.  Consumers can then use a phandle
+to a mailbox provider, along with channel specifier information in order to
+get a mailbox.
+
+MAILBOX PROVIDERS
+
+#mbox-cells:
+	Usage: required
+	Type: u32
+	Desc: Number of cells in a mailbox specifier; Typically 1 for nodes
+	      which only need a channel index.
+
+
+Example:
+	mailbox: mailbox {
+		#mbox-cells = <1>;
+		...
+	};
+
+
+MAILBOX CONSUMERS
+
+mbox:
+	Usage: required
+	Type: < [phandle] [mailbox-specifier] >
+	Desc: List of phandle and mailbox specifier pairs, matching provider's
+	      #mbox-cells property
+
+mbox-names:
+	Usage: optional
+	Type: string array
+	Desc: List of mailbox input name strings sorted in the same order as
+	      the mbox property.  Consumer drivers should use mbox-names
+	      to match mailbox input names with mailbox specifiers.
+
+Example:
+	consumer {
+		mbox-names = "comms";
+		mbox = <&mailbox 0>;
+	};
-- 
1.8.1.5

