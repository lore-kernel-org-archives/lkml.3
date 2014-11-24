Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaKXKEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:04:42 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46320 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaKXKEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:04:40 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH] KVM: x86: export get_xsave_addr
Date: Mon, 24 Nov 2014 11:04:31 +0100
Message-Id: <1416823471-30846-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_xsave_addr is the API to access XSAVE states, and KVM would
like to use it.  Export it.

Cc: x86@kernel.org
Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Peter, can you please ACK this for inclusion in the KVM tree?
	Thanks.
---
 arch/x86/kernel/xsave.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 4c540c4719d8..0de1fae2bdf0 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -738,3 +738,4 @@ void *get_xsave_addr(struct xsave_struct *xsave, int xstate)
 
 	return (void *)xsave + xstate_comp_offsets[feature];
 }
+EXPORT_SYMBOL_GPL(get_xsave_addr);
-- 
1.8.3.1

