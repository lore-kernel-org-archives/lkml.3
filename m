Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbaLDLCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:02:30 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26420 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaLDLC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:02:28 -0500
Date: Thu, 4 Dec 2014 14:01:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-sh@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [patch] sh: off by one BUG_ON() in setup_bootmem_node()
Message-ID: <20141204110110.GD22643@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVxCUYkaC5wzHi-o6knD6ugFudTdh3PJz5JCwv-std3GA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This off by one bug is harmless but it upsets the static checkers and
the code is obvious so it doesn't hurt to fix it.  The Smatch warning
is:

	arch/sh/mm/numa.c:47 setup_bootmem_node()
	error: buffer overflow 'node_data' 1024 <= 1024

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/arch/sh/mm/numa.c b/arch/sh/mm/numa.c
index 3d85225..bce52ba 100644
--- a/arch/sh/mm/numa.c
+++ b/arch/sh/mm/numa.c
@@ -31,7 +31,7 @@ void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end)
 	unsigned long bootmem_paddr;
 
 	/* Don't allow bogus node assignment */
-	BUG_ON(nid > MAX_NUMNODES || nid <= 0);
+	BUG_ON(nid >= MAX_NUMNODES || nid <= 0);
 
 	start_pfn = start >> PAGE_SHIFT;
 	end_pfn = end >> PAGE_SHIFT;
