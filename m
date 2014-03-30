Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbaC3Xmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:42:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754419AbaC3Xmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:52 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mihai Caraman" <mihai.caraman@freescale.com>,
        "Alexander Graf" <agraf@suse.de>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.401852014@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 055/200] KVM: PPC: e500: Fix bad address type in
 deliver_tlb_misss()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mihai Caraman <mihai.caraman@freescale.com>

commit 70713fe315ed14cd1bb07d1a7f33e973d136ae3d upstream.

Use gva_t instead of unsigned int for eaddr in deliver_tlb_miss().

Signed-off-by: Mihai Caraman <mihai.caraman@freescale.com>
Signed-off-by: Alexander Graf <agraf@suse.de>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kvm/e500_tlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -481,7 +481,7 @@ static inline void kvmppc_e500_priv_rele
 }
 
 static inline void kvmppc_e500_deliver_tlb_miss(struct kvm_vcpu *vcpu,
-		unsigned int eaddr, int as)
+		gva_t eaddr, int as)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
 	unsigned int victim, pidsel, tsized;

