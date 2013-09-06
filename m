Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3IFOAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:00:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48540 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3IFOAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:00:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/p2m: Export set_phys_to_machine.
Date: Fri,  6 Sep 2013 10:00:42 -0400
Message-Id: <1378476042-4821-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have already exported 'get_phys_to_machine' and there are
third-party drivers that depend on this other symbol. As such
lets make this balanced and also export this symbol.

Reported-by: Yuval Shaia <yuval.shaia@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 0d4ec35..cdb96bc 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -847,6 +847,7 @@ bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(set_phys_to_machine);
 
 #define M2P_OVERRIDE_HASH_SHIFT	10
 #define M2P_OVERRIDE_HASH	(1 << M2P_OVERRIDE_HASH_SHIFT)
-- 
1.8.3.1

