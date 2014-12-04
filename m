Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbaLDQAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:00:43 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37530 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbaLDP5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:57:25 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: rkrcmar@redhat.com, Wanpeng Li <wanpeng.li@linux.intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 1/9] x86: export get_xsave_addr
Date: Thu,  4 Dec 2014 16:57:06 +0100
Message-Id: <1417708634-24333-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_xsave_addr is the API to access XSAVE states, and KVM would
like to use it.  Export it.

Cc: stable@vger.kernel.org
Cc: x86@kernel.org
Cc: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
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


