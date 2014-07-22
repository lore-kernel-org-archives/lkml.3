Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbaGVS56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:57:58 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55058 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaGVS54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:57:56 -0400
From: Jassi Brar <jaswinder.singh@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ks.giri@samsung.com, arnd@arndb.de, ijc@hellion.org.uk,
        mark.rutland@arm.com, robh@kernel.org, pawel.moll@arm.com,
        courtney.cavin@sonymobile.com, mporter@linaro.org,
        slapdau@yahoo.com.au, lftan.linux@gmail.com, loic.pallardy@st.com,
        s-anna@ti.com, ashwin.chaugule@linaro.org, bjorn@kryo.se,
        patches@linaro.org, t.takinishi@jp.fujitsu.com, broonie@linaro.org,
        khilman@linaro.org, mollie.wu@linaro.org, andy.green@linaro.org,
        lee.jones@linaro.org, Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv9 4/4] dt: mailbox: add generic bindings
Date: Wed, 23 Jul 2014 00:27:36 +0530
Message-Id: <1406055456-29384-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1406055250-29159-1-git-send-email-jaswinder.singh@linaro.org>
References: <1406055250-29159-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define generic bindings for the framework clients to
request mailbox channels.

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 .../devicetree/bindings/mailbox/mailbox.txt        | 36 ++++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mailbox/mailbox.txt

diff --git a/Documentation/devicetree/bindings/mailbox/mailbox.txt b/Documentation/devicetree/bindings/mailbox/mailbox.txt
new file mode 100644
index 0000000..bb79678
--- /dev/null
+++ b/Documentation/devicetree/bindings/mailbox/mailbox.txt
@@ -0,0 +1,36 @@
+* Generic Mailbox Controller and client driver bindings
+
+Generic binding to provide a way for Mailbox controller drivers to
+assign appropriate mailbox channel to client drivers.
+
+* Mailbox Controller
+
+Required property:
+- #mbox-cells: Must be at least 1. Number of cells in a mailbox
+		specifier.
+
+Example:
+	mailbox: mailbox {
+		...
+		#mbox-cells = <1>;
+	};
+
+
+* Mailbox Client
+
+Required property:
+- mboxes: List of phandle and mailbox channel specifiers.
+
+Optional property:
+- mbox-names: List of identifier strings for each mailbox channel
+		required by the client. The use of this property
+		is discouraged in favor of using index in list of
+		'mboxes' while requesting a mailbox.
+
+Example:
+	pwr_cntrl: power {
+		...
+		mbox-names = "pwr-ctrl", "rpc";
+		mboxes = <&mailbox 0
+			&mailbox 1>;
+	};
-- 
1.8.1.2

