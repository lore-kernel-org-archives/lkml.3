Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114Ab3B0BGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:06:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab3BZX5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 060/150] sparc64: Fix gfp_flags setting in tsb_grow().
Date: Tue, 26 Feb 2013 15:55:17 -0800
Message-Id: <20130226235530.427349995@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit a55ee1ff751f88252207160087d8197bb7538d4c ]

We should "|= more_flags" rather than "= more_flags".

Reported-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/mm/tsb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -314,7 +314,7 @@ void tsb_grow(struct mm_struct *mm, unsi
 retry_tsb_alloc:
 	gfp_flags = GFP_KERNEL;
 	if (new_size > (PAGE_SIZE * 2))
-		gfp_flags = __GFP_NOWARN | __GFP_NORETRY;
+		gfp_flags |= __GFP_NOWARN | __GFP_NORETRY;
 
 	new_tsb = kmem_cache_alloc_node(tsb_caches[new_cache_index],
 					gfp_flags, numa_node_id());


