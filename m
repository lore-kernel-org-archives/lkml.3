Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaJ1UeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:34:16 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34799 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbaJ1UeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:34:10 -0400
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 2/5] of: testcases: Update with new local fixups format
Date: Tue, 28 Oct 2014 22:33:50 +0200
Message-Id: <1414528433-9650-3-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1414528433-9650-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1414528433-9650-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the selftests to using the new (and more readable) local
fixups format.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/of/testcase-data/testcases.dts | 61 +++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/of/testcase-data/testcases.dts b/drivers/of/testcase-data/testcases.dts
index 6994e15..b6bc41b 100644
--- a/drivers/of/testcase-data/testcases.dts
+++ b/drivers/of/testcase-data/testcases.dts
@@ -23,28 +23,41 @@
  * this a kernel-internal data format.
  */
 / { __local_fixups__ {
-	fixup = "/testcase-data/testcase-device2:interrupt-parent:0",
-		"/testcase-data/testcase-device1:interrupt-parent:0",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:60",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:52",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:44",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:36",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:24",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:8",
-		"/testcase-data/interrupts/interrupts-extended0:interrupts-extended:0",
-		"/testcase-data/interrupts/interrupts1:interrupt-parent:0",
-		"/testcase-data/interrupts/interrupts0:interrupt-parent:0",
-		"/testcase-data/interrupts/intmap1:interrupt-map:12",
-		"/testcase-data/interrupts/intmap0:interrupt-map:52",
-		"/testcase-data/interrupts/intmap0:interrupt-map:36",
-		"/testcase-data/interrupts/intmap0:interrupt-map:16",
-		"/testcase-data/interrupts/intmap0:interrupt-map:4",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list-bad-args:12",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list-bad-args:0",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:56",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:52",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:40",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:24",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:8",
-		"/testcase-data/phandle-tests/consumer-a:phandle-list:0";
+	testcase-data {
+		phandle-tests {
+			consumer-a {
+				phandle-list = <0x00000000 0x00000008
+						0x00000018 0x00000028
+						0x00000034 0x00000038>;
+				phandle-list-bad-args = <0x00000000 0x0000000c>;
+			};
+		};
+		interrupts {
+			intmap0 {
+				interrupt-map = <0x00000004 0x00000010
+						 0x00000024 0x00000034>;
+			};
+			intmap1 {
+				interrupt-map = <0x0000000c>;
+			};
+			interrupts0 {
+				interrupt-parent = <0x00000000>;
+			};
+			interrupts1 {
+				interrupt-parent = <0x00000000>;
+			};
+			interrupts-extended0 {
+				interrupts-extended = <0x00000000 0x00000008
+						       0x00000018 0x00000024
+						       0x0000002c 0x00000034
+						       0x0000003c>;
+			};
+		};
+		testcase-device1 {
+			interrupt-parent = <0x00000000>;
+		};
+		testcase-device2 {
+			interrupt-parent = <0x00000000>;
+		};
+	};
 }; };
-- 
1.7.12

