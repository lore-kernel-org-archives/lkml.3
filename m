Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbaBUReY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:34:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:10593 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163AbaBUReW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:34:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,520,1389772800"; 
   d="scan'208,223";a="487300389"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: [PATCH] KVM: x86: expose new instruction RDSEED to guest
Thread-Topic: [PATCH] KVM: x86: expose new instruction RDSEED to guest
Thread-Index: Ac8vKwrDtngjoNzxQYOuRR/jMh3KJg==
Date: Fri, 21 Feb 2014 17:33:32 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233501509B15@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 24ffdce9efebf13c6ed4882f714b2b57ef1141eb Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Thu, 20 Feb 2014 17:38:26 +0800
Subject: [PATCH] KVM: x86: expose new instruction RDSEED to guest

RDSEED instruction return a random number, which supplied by a
cryptographically secure, deterministic random bit generator(DRBG).

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 arch/x86/kvm/cpuid.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c697625..abe18b4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -303,7 +303,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	/* cpuid 7.0.ebx */
 	const u32 kvm_supported_word9_x86_features =
 		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
-		F(BMI2) | F(ERMS) | f_invpcid | F(RTM);
+		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | F(RDSEED);
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
-- 
1.7.1
