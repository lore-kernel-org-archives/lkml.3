Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaDORM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:12:56 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44876 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbaDORLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:11:17 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        David.Laight@aculab.com, Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 2/6] powerpc/perf/hv_gpci: probe failures use pr_debug(), and padding reduced
Date: Tue, 15 Apr 2014 10:10:51 -0700
Message-Id: <1397581855-4585-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397581855-4585-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1397581855-4585-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041517-0320-0000-0000-00000301932E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixup for "powerpc/perf: Add support for the hv gpci (get performance
counter info) interface".

Makes the "not enabled" message less awful (and hidden unless
debugging).

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/perf/hv-gpci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index 278ba7b..8fee1dc 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -273,13 +273,13 @@ static int hv_gpci_init(void)
 	struct hv_perf_caps caps;
 
 	if (!firmware_has_feature(FW_FEATURE_LPAR)) {
-		pr_info("not a virtualized system, not enabling\n");
+		pr_debug("not a virtualized system, not enabling\n");
 		return -ENODEV;
 	}
 
 	hret = hv_perf_caps_get(&caps);
 	if (hret) {
-		pr_info("could not obtain capabilities, error 0x%80lx, not enabling\n",
+		pr_debug("could not obtain capabilities, not enabling, rc=%ld\n",
 				hret);
 		return -ENODEV;
 	}
-- 
1.9.2

