Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3HWHrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:47:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54121 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3HWHrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:47:33 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-00-52171393723f
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Christoffer Dall'" <cdall@cs.columbia.edu>,
        "'Gleb Natapov'" <gleb@redhat.com>
References: 
In-reply-to: 
Subject: [PATCH 3.10-stable] ARM: KVM: Fix 64-bit coprocessor handling
Date: Fri, 23 Aug 2013 16:47:30 +0900
Message-id: <000001ce9fd5$0596ea70$10c4bf50$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkzGCMAAA5gYwAMf3LxAFffBYYAAAYQ2gCxCVioA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zQ93JwuJBBp2PZSzmTZG1WHWgg9Vi
	STO3xeVdc9gsFmx8xOjA6vH11kEmj/f7rrJ59G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8az
	1xvYC/r1KpZf/87cwHhCpYuRk0NCwETi3OznzBC2mMSFe+vZuhi5OIQEljFKLD46hQ2m6Fb7
	AiaIxHRGiZubXrFCOH8ZJVYsfsYIUsUmoCtxbP0WVhBbRMBb4tSUX2BjmQWyJKav+ARUwwHU
	wC2xujkIJMwpwCOx7k8nM0hYWMBNYttBc5Awi4CqxOsjn1lAbF4BO4neO48YIWxBiR+T77FA
	TNSSWL/zOBOELS+xec1bsDESAuoSj/7qglwmIrCAUeLZtaOMEDUiEvtevGMESUgIXGOXmNb7
	nRlimYDEt8mHWCCaZSU2HYAGhKTEwRU3WCYwSsxCsnoWktWzkKyehWTFAkaWVYyiqQXJBcVJ
	6UUmesWJucWleel6yfm5mxghsTlhB+O9A9aHGJOB1k9klhJNzgfGdl5JvKGxmZGFqYmpsZG5
	pRlpwkrivOot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGOU0TkpL8097pPxF1+tA00dv
	2Ulc0+Qtij1a0hz9D80RPlSa2Z+yljeZfZ11yr/ig7OM7q+1WSl3807RHPXjNYUdJdJFumJ+
	80tTOUNvL77UxR2865diZ+euXxd+B25zEdxmfVb1DrNR+tIJmkpd7V4Kzc9M+a1y/6+N1Hty
	tGGq7443S5rblViKMxINtZiLihMBSRwrw+MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jQd3JwuJBBn/uilvMmyJrsepAB6vF
	kmZui8u75rBZLNj4iNGB1ePrrYNMHu/3XWXz6NuyitHj8ya5AJaoBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07TBNC
	Q9x0LWAaI3R9Q4LgeowM0EDCOsaMZ683sBf061Usv/6duYHxhEoXIyeHhICJxK32BUwQtpjE
	hXvr2boYuTiEBKYzStzc9IoVwvnLKLFi8TNGkCo2AV2JY+u3sILYIgLeEqem/GIGsZkFsiSm
	r/gEVMMB1MAtsbo5CCTMKcAjse5PJzNIWFjATWLbQXOQMIuAqsTrI59ZQGxeATuJ3juPGCFs
	QYkfk++xQEzUkli/8zgThC0vsXnNW7AxEgLqEo/+6oJcJiKwgFHi2bWjjBA1IhL7XrxjnMAo
	NAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj/5n0DsZVDRaH
	GAU4GJV4eCc4iwUJsSaWFVfmHmKU4GBWEuE98BcoxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKi
	yfnApJRXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYz9i0pe
	+q7UP3Q8YUmzoM+P5KjbGi0HIqfJld0+s4f3xMrXLnz9ny6kBTRVFay/+TLsVkDonjrV3xN/
	VccrPk17s3YTi875HS2zV/sEqD1fn73+wz7F2xd8pwjOnKt26qWe6kbdtCvn6/dkFDPt3vOV
	Oe369hNxEoqcFTm/jl8M8xDYmVt88KCeEktxRqKhFnNRcSIAEH2pT0ADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.10-stable tree, should we apply
it?

------------------

From: "Christoffer Dall <christoffer.dall@linaro.org>"

commit 240e99cbd00aa541b572480e3ea7ecb0d480bc79 upstream

The PAR was exported as CRn == 7 and CRm == 0, but in fact the primary
coprocessor register number was determined by CRm for 64-bit coprocessor
registers as the user space API was modeled after the coprocessor
access instructions (see the ARM ARM rev. C - B3-1445).

However, just changing the CRn to CRm breaks the sorting check when
booting the kernel, because the internal kernel logic always treats CRn
as the primary register number, and it makes the table sorting
impossible to understand for humans.

Alternatively we could change the logic to always have CRn == CRm, but
that becomes unclear in the number of ways we do look up of a coprocessor
register.  We could also have a separate 64-bit table but that feels
somewhat over-engineered.  Instead, keep CRn the primary representation
of the primary coproc. register number in-kernel and always export the
primary number as CRm as per the existing user space ABI.

Note: The TTBR registers just magically worked because they happened to
follow the CRn(0) regs and were considered CRn(0) in the in-kernel
representation.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/kvm/coproc.c     |   26 +++++++++++++++++++-------
 arch/arm/kvm/coproc.h     |    3 +++
 arch/arm/kvm/coproc_a15.c |    6 +++++-
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 4a51990..db9cf69 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -146,7 +146,11 @@ static bool pm_fake(struct kvm_vcpu *vcpu,
 #define access_pmintenclr pm_fake
 
 /* Architected CP15 registers.
- * Important: Must be sorted ascending by CRn, CRM, Op1, Op2
+ * CRn denotes the primary register number, but is copied to the CRm in the
+ * user space API for 64-bit register access in line with the terminology
used
+ * in the ARM ARM.
+ * Important: Must be sorted ascending by CRn, CRM, Op1, Op2 and with
64-bit
+ *            registers preceding 32-bit ones.
  */
 static const struct coproc_reg cp15_regs[] = {
 	/* CSSELR: swapped by interrupt.S. */
@@ -154,8 +158,8 @@ static const struct coproc_reg cp15_regs[] = {
 			NULL, reset_unknown, c0_CSSELR },
 
 	/* TTBR0/TTBR1: swapped by interrupt.S. */
-	{ CRm( 2), Op1( 0), is64, NULL, reset_unknown64, c2_TTBR0 },
-	{ CRm( 2), Op1( 1), is64, NULL, reset_unknown64, c2_TTBR1 },
+	{ CRm64( 2), Op1( 0), is64, NULL, reset_unknown64, c2_TTBR0 },
+	{ CRm64( 2), Op1( 1), is64, NULL, reset_unknown64, c2_TTBR1 },
 
 	/* TTBCR: swapped by interrupt.S. */
 	{ CRn( 2), CRm( 0), Op1( 0), Op2( 2), is32,
@@ -182,7 +186,7 @@ static const struct coproc_reg cp15_regs[] = {
 			NULL, reset_unknown, c6_IFAR },
 
 	/* PAR swapped by interrupt.S */
-	{ CRn( 7), Op1( 0), is64, NULL, reset_unknown64, c7_PAR },
+	{ CRm64( 7), Op1( 0), is64, NULL, reset_unknown64, c7_PAR },
 
 	/*
 	 * DC{C,I,CI}SW operations:
@@ -399,12 +403,13 @@ static bool index_to_params(u64 id, struct
coproc_params *params)
 			      | KVM_REG_ARM_OPC1_MASK))
 			return false;
 		params->is_64bit = true;
-		params->CRm = ((id & KVM_REG_ARM_CRM_MASK)
+		/* CRm to CRn: see cp15_to_index for details */
+		params->CRn = ((id & KVM_REG_ARM_CRM_MASK)
 			       >> KVM_REG_ARM_CRM_SHIFT);
 		params->Op1 = ((id & KVM_REG_ARM_OPC1_MASK)
 			       >> KVM_REG_ARM_OPC1_SHIFT);
 		params->Op2 = 0;
-		params->CRn = 0;
+		params->CRm = 0;
 		return true;
 	default:
 		return false;
@@ -898,7 +903,14 @@ static u64 cp15_to_index(const struct coproc_reg *reg)
 	if (reg->is_64) {
 		val |= KVM_REG_SIZE_U64;
 		val |= (reg->Op1 << KVM_REG_ARM_OPC1_SHIFT);
-		val |= (reg->CRm << KVM_REG_ARM_CRM_SHIFT);
+		/*
+		 * CRn always denotes the primary coproc. reg. nr. for the
+		 * in-kernel representation, but the user space API uses the
+		 * CRm for the encoding, because it is modelled after the
+		 * MRRC/MCRR instructions: see the ARM ARM rev. c page
+		 * B3-1445
+		 */
+		val |= (reg->CRn << KVM_REG_ARM_CRM_SHIFT);
 	} else {
 		val |= KVM_REG_SIZE_U32;
 		val |= (reg->Op1 << KVM_REG_ARM_OPC1_SHIFT);
diff --git a/arch/arm/kvm/coproc.h b/arch/arm/kvm/coproc.h
index b7301d3..0461d5c 100644
--- a/arch/arm/kvm/coproc.h
+++ b/arch/arm/kvm/coproc.h
@@ -135,6 +135,8 @@ static inline int cmp_reg(const struct coproc_reg *i1,
 		return -1;
 	if (i1->CRn != i2->CRn)
 		return i1->CRn - i2->CRn;
+	if (i1->is_64 != i2->is_64)
+		return i2->is_64 - i1->is_64;
 	if (i1->CRm != i2->CRm)
 		return i1->CRm - i2->CRm;
 	if (i1->Op1 != i2->Op1)
@@ -145,6 +147,7 @@ static inline int cmp_reg(const struct coproc_reg *i1,
 
 #define CRn(_x)		.CRn = _x
 #define CRm(_x) 	.CRm = _x
+#define CRm64(_x)       .CRn = _x, .CRm = 0
 #define Op1(_x) 	.Op1 = _x
 #define Op2(_x) 	.Op2 = _x
 #define is64		.is_64 = true
diff --git a/arch/arm/kvm/coproc_a15.c b/arch/arm/kvm/coproc_a15.c
index 685063a..cf93472 100644
--- a/arch/arm/kvm/coproc_a15.c
+++ b/arch/arm/kvm/coproc_a15.c
@@ -114,7 +114,11 @@ static bool access_l2ectlr(struct kvm_vcpu *vcpu,
 
 /*
  * A15-specific CP15 registers.
- * Important: Must be sorted ascending by CRn, CRM, Op1, Op2
+ * CRn denotes the primary register number, but is copied to the CRm in the
+ * user space API for 64-bit register access in line with the terminology
used
+ * in the ARM ARM.
+ * Important: Must be sorted ascending by CRn, CRM, Op1, Op2 and with
64-bit
+ *            registers preceding 32-bit ones.
  */
 static const struct coproc_reg a15_regs[] = {
 	/* MPIDR: we use VMPIDR for guest access. */
-- 
1.7.9.5

