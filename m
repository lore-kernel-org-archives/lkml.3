Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3HWL6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:58:54 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49878 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282Ab3HWL6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:58:52 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-doc@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Rob Landley <rob@landley.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, <mtosatti@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH ] Documentation/kvm: Update cpuid documentation for steal time and pv eoi
Date: Fri, 23 Aug 2013 17:34:47 +0530
Message-Id: <1377259487-23989-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <y>
References: <y>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082311-0320-0000-0000-000000C79447
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 While adding documentation for pvspinlock, I found that these two should
 be updated. I have based this on top of pvspinlock kvm host patchset (V12)

 Documentation/virtual/kvm/cpuid.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
index 22ff659..15a5ac20 100644
--- a/Documentation/virtual/kvm/cpuid.txt
+++ b/Documentation/virtual/kvm/cpuid.txt
@@ -43,6 +43,15 @@ KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
 KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
                                    ||       || writing to msr 0x4b564d02
 ------------------------------------------------------------------------------
+KVM_FEATURE_STEAL_TIME             ||     5 || guest accounts fine granularity
+                                   ||       || task steal time. enabled when
+                                   ||       || shedstat or task delay accounting
+                                   ||       || is supported by the host.
+------------------------------------------------------------------------------
+KVM_FEATURE_PV_EOI                 ||     6 || overrides the generic EOI
+                                   ||       || implementation with an optimized
+                                   ||       || version.
+------------------------------------------------------------------------------
 KVM_FEATURE_PV_UNHALT              ||     7 || guest checks this feature bit
                                    ||       || before enabling paravirtualized
                                    ||       || spinlock support.
-- 
1.7.11.7

