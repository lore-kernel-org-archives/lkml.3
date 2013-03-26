Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3CZRrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:47:25 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34008 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3CZRrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:47:22 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3/3] powerpc/mm/numa: use setup_nr_node_ids() instead of opencoding.
Date: Tue, 26 Mar 2013 10:46:02 -0700
Message-Id: <1364319962-30967-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1364319962-30967-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1364319962-30967-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032617-7282-0000-0000-00001587C6BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/mm/numa.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index bba87ca..7574ae3 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -62,14 +62,11 @@ static int distance_lookup_table[MAX_NUMNODES][MAX_DISTANCE_REF_POINTS];
  */
 static void __init setup_node_to_cpumask_map(void)
 {
-	unsigned int node, num = 0;
+	unsigned int node;
 
 	/* setup nr_node_ids if not done yet */
-	if (nr_node_ids == MAX_NUMNODES) {
-		for_each_node_mask(node, node_possible_map)
-			num = node;
-		nr_node_ids = num + 1;
-	}
+	if (nr_node_ids == MAX_NUMNODES)
+		setup_nr_node_ids()
 
 	/* allocate the map */
 	for (node = 0; node < nr_node_ids; node++)
-- 
1.8.2

