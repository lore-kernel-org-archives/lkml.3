Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab3BEH1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:27:09 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:58280 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab3BEH1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:27:06 -0500
Message-ID: <5110B43E.6010601@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2013 15:26:54 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 1/3] KVM: MMU: cleanup mapping-level
References: <5110B41D.3090605@linux.vnet.ibm.com>
In-Reply-To: <5110B41D.3090605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020507-4790-0000-0000-000006C9A89A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use min() to cleanup mapping_level

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ff2fc80..fe877da 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -832,8 +832,7 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 	if (host_level == PT_PAGE_TABLE_LEVEL)
 		return host_level;

-	max_level = kvm_x86_ops->get_lpage_level() < host_level ?
-		kvm_x86_ops->get_lpage_level() : host_level;
+	max_level = min(kvm_x86_ops->get_lpage_level(), host_level);

 	for (level = PT_DIRECTORY_LEVEL; level <= max_level; ++level)
 		if (has_wrprotected_page(vcpu->kvm, large_gfn, level))
-- 
1.7.7.6

