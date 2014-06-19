Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaFSKcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 06:32:24 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:32920 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaFSKcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:32:22 -0400
Message-ID: <53A2BC1A.4050702@gmail.com>
Date: Thu, 19 Jun 2014 18:31:54 +0800
From: =?gb18030?Q?=22newtongao=28=B8=DF=D0=A1=C3=F7=29=22?= 
	<gxm.linux.kernel@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
CC: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: fix hyperv tsc page clear wrong address
References: <53A2BB7B.8070507@gmail.com>
In-Reply-To: <53A2BB7B.8070507@gmail.com>
X-Forwarded-Message-Id: <53A2BB7B.8070507@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030104070906060807000906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030104070906060807000906
Content-Type: text/plain; charset=gb18030
Content-Transfer-Encoding: 7bit

>From 6010e24da995d4161cb879e98fda989e3cdb41c4 Mon Sep 17 00:00:00 2001
From: Xiaoming Gao <newtongao@tencent.com>
Date: Thu, 19 Jun 2014 17:46:05 +0800
Subject: [PATCH] kvm: fix hyperv tsc page clear wrong address

tsc page addr need clear the low HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT bits
before kvm_write_guest write the zero tsc_ref structure to guest, or it will lead
guest to get wrong clocksource.

windows guest will get strong impact, QueryPerformanceCounter will always return 0
,all things in windows rely on clock source will in serious chaos.

Signed-off-by: Xiaoming Gao <newtongao@tencnet.com>
---
 arch/x86/kvm/x86.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f32a025..ed716cf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1898,6 +1898,7 @@ static int set_msr_hyperv_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		if (!(data & HV_X64_MSR_TSC_REFERENCE_ENABLE))
 			break;
 		gfn = data >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
+		data &= ~((1 << HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT) - 1);
 		if (kvm_write_guest(kvm, data,
 			&tsc_ref, sizeof(tsc_ref)))
 			return 1;
-- 
1.7.1




--------------030104070906060807000906
Content-Type: text/plain; charset=gb18030;
 name="0001-kvm-fix-hyperv-tsc-page-clear-wrong-address.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-kvm-fix-hyperv-tsc-page-clear-wrong-address.patch"

>From 6010e24da995d4161cb879e98fda989e3cdb41c4 Mon Sep 17 00:00:00 2001
From: Xiaoming Gao <newtongao@tencent.com>
Date: Thu, 19 Jun 2014 17:46:05 +0800
Subject: [PATCH] kvm: fix hyperv tsc page clear wrong address

tsc page addr need clear the low HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT bits
before kvm_write_guest write the zero tsc_ref structure to guest, or it will lead
guest to get wrong clocksource.

windows guest will get strong impact, QueryPerformanceCounter will always return 0
,all things in windows rely on clock source, will in serious chaos.

Signed-off-by: Xiaoming Gao <newtongao@tencnet.com>
---
 arch/x86/kvm/x86.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f32a025..ed716cf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1898,6 +1898,7 @@ static int set_msr_hyperv_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		if (!(data & HV_X64_MSR_TSC_REFERENCE_ENABLE))
 			break;
 		gfn = data >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
+		data &= ~((1 << HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT) - 1);
 		if (kvm_write_guest(kvm, data,
 			&tsc_ref, sizeof(tsc_ref)))
 			return 1;
-- 
1.7.1


--------------030104070906060807000906--
