Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab3AOSwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:52:30 -0500
Received: from mail.kernel.org ([198.145.19.201]:34084 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414Ab3AOSw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:52:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Scott Wood <scottwood@freescale.com>, Alexander Graf <agraf@suse.de>
Subject: [ 012/221] KVM: PPC: e500: fix allocation size error on g2h_tlb1_map
Date: Tue, 15 Jan 2013 10:48:59 -0800
Message-Id: <20130115184958.938137425@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Wood <scottwood@freescale.com>

commit e400e72f250d2567e89c9bafb47ab91e8d9a15a2 upstream.

We were only allocating half the bytes we need, which was made more
obvious by a recent fix to the memset in  clear_tlb1_bitmap().

Signed-off-by: Scott Wood <scottwood@freescale.com>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/e500_tlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -1332,7 +1332,7 @@ int kvmppc_e500_tlb_init(struct kvmppc_v
 	if (!vcpu_e500->gtlb_priv[1])
 		goto err;
 
-	vcpu_e500->g2h_tlb1_map = kzalloc(sizeof(unsigned int) *
+	vcpu_e500->g2h_tlb1_map = kzalloc(sizeof(u64) *
 					  vcpu_e500->gtlb_params[1].entries,
 					  GFP_KERNEL);
 	if (!vcpu_e500->g2h_tlb1_map)


