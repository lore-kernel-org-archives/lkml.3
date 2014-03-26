Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaCZIH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 04:07:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:2941 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaCZIHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 04:07:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,734,1389772800"; 
   d="scan'208";a="499744508"
From: "Wang, Biao" <biao.wang@intel.com>
To: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Zhang, Di" <di.zhang@intel.com>
Subject: [PATCH] x86: apic: disarm apic timer in deadline mode when shut
 down clockevent
Thread-Topic: [PATCH] x86: apic: disarm apic timer in deadline mode when
 shut down clockevent
Thread-Index: Ac9IyWcJV6Gl4K10S36bhx/8NjnmOA==
Date: Wed, 26 Mar 2014 08:06:07 +0000
Message-ID: <09CB0B4607EB8F4DB7E0BE3B06BFBD0501004D78@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
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

For tsc deadline mode, when we shut down clockevent we should disarm
local-APIC timer like count-down mode.

Signed-off-by: wang, biao <biao.wang@intel.com>
Signed-off-by: Zhang Di <di.zhang@intel.com>
---
 arch/x86/kernel/apic/apic.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7f26c9a..85889ba 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -512,6 +512,10 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 		apic_write(APIC_LVTT, v);
 		apic_write(APIC_TMICT, 0);
+
+		/*disarm timer in deadline mode*/
+		if (boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER))
+			wrmsrl(MSR_IA32_TSC_DEADLINE, 0);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
 		/* Nothing to do here */
-- 
1.7.6
