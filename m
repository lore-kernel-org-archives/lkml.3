Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab3AWKFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:05:08 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:40769 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab3AWKFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:05:06 -0500
Message-ID: <50FFB5CA.8080106@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 18:04:58 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 02/12] KVM: MMU: cleanup mapping-level
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
In-Reply-To: <50FFB5A1.5090708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012310-1396-0000-0000-00000274581D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use min() to cleanup mapping_level

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0f90269..8dca8af 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -831,8 +831,7 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 	if (host_level == PT_PAGE_TABLE_LEVEL)
 		return host_level;

-	max_level = kvm_x86_ops->get_lpage_level() < host_level ?
-		kvm_x86_ops->get_lpage_level() : host_level;
+	max_level = min(kvm_x86_ops->get_lpage_level(), host_level);

 	for (level = PT_DIRECTORY_LEVEL; level <= max_level; ++level)
 		if (has_wrprotected_page(vcpu->kvm, large_gfn, level))
-- 
1.7.7.6

