Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaKZOAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:00:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40654 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaKZOAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:00:32 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [RFC 2/2] kvm: eventfd: detect integer overflow using check_*_overflow
Date: Wed, 26 Nov 2014 09:00:19 -0500
Message-Id: <1417010419-3827-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect integer overflows using safe operations rather than relying on
undefined behaviour.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 virt/kvm/eventfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 148b239..2eb044f 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -790,7 +790,7 @@ kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 	}
 
 	/* check for range overflow */
-	if (args->addr + args->len < args->addr)
+	if (check_add_overflow(args->len, args->addr))
 		return -EINVAL;
 
 	/* check for extra flags that we don't understand */
-- 
1.7.10.4

