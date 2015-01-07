Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbbAGRbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:31:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55359 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbbAGRb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:31:29 -0500
From: Suman Anna <s-anna@ti.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Felipe Balbi <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [RFC PATCH 3/3] of/unittest: fix trailing semi-colons on conditional selftest
Date: Wed, 7 Jan 2015 11:30:54 -0600
Message-ID: <1420651854-17768-4-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420651854-17768-1-git-send-email-s-anna@ti.com>
References: <1420651854-17768-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_platform_populate() and of_platform_depopulate() tests
are not really being tested because of some additional trailing
semi-colons after the conditional checks on couple of selftest
macro usage. Remove them to properly run all the platform
tests.

Fixes: 851da976dc1d (of/unittest: Remove test devices after adding them)
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/of/unittest.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 844838e11ef1..c67e50264e82 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -765,11 +765,11 @@ static void __init of_selftest_platform_populate(void)
 	selftest(irq < 0 && irq != -EPROBE_DEFER, "device parsing error failed - %d\n", irq);
 
 	if (selftest(np = of_find_node_by_path("/testcase-data/platform-tests"),
-		     "No testcase data in device tree\n"));
+		     "No testcase data in device tree\n"))
 		return;
 
 	if (selftest(!(rc = device_register(&test_bus)),
-		     "testbus registration failed; rc=%i\n", rc));
+		     "testbus registration failed; rc=%i\n", rc))
 		return;
 
 	for_each_child_of_node(np, child) {
-- 
2.2.1

