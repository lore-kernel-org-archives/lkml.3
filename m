Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaLOPKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:10:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38367 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaLOO1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Cowgill <James.Cowgill@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 041/168] MIPS: IP27: Fix __node_distances undefined error
Date: Mon, 15 Dec 2014 14:24:55 +0000
Message-Id: <1418653622-21105-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Cowgill <James.Cowgill@imgtec.com>

commit 5829b0ecc584d15ae4eeabe69f2ab554bdec4689 upstream.

export the __node_distances symbol in the ip27 memory code to fix the
build error:

  Building modules, stage 2.
  MODPOST 311 modules
ERROR: "__node_distances" [drivers/block/nvme.ko] undefined!
scripts/Makefile.modpost:90: recipe for target '__modpost' failed

when building the kernel with:
 CONFIG_SGI_IP27=y
 CONFIG_BLK_DEV_NVME=m

Signed-off-by: James Cowgill <James.Cowgill@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/sgi-ip27/ip27-memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
index a95c00f5fb96..a304bcc37e4f 100644
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -107,6 +107,7 @@ static void router_recurse(klrou_t *router_a, klrou_t *router_b, int depth)
 }
 
 unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];
+EXPORT_SYMBOL(__node_distances);
 
 static int __init compute_node_distance(nasid_t nasid_a, nasid_t nasid_b)
 {
-- 
2.1.3

