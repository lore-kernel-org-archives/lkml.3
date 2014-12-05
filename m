Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaLEWpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:45:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaLEWps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Cowgill <James.Cowgill@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.17 001/122] MIPS: IP27: Fix __node_distances undefined error
Date: Fri,  5 Dec 2014 14:42:55 -0800
Message-Id: <20141205223305.753095854@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/sgi-ip27/ip27-memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -107,6 +107,7 @@ static void router_recurse(klrou_t *rout
 }
 
 unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];
+EXPORT_SYMBOL(__node_distances);
 
 static int __init compute_node_distance(nasid_t nasid_a, nasid_t nasid_b)
 {


