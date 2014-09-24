Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaIXIWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:22:12 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:53643 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291AbaIXIWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:22:09 -0400
Message-ID: <1411546927.19525.12.camel@x220>
Subject: [PATCH] [next-20140923] KVM: Remove KVM_VFIO
From: Paul Bolle <pebolle@tiscali.nl>
To: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Alex Williamson <Alex.Williamson@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 24 Sep 2014 10:22:07 +0200
In-Reply-To: <5421D82E.6090103@redhat.com>
References: <1411499391.24045.13.camel@x220> <5421D82E.6090103@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2014 08:22:07.0248 (UTC) FILETIME=[A1117900:01CFD7D0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no checks for CONFIG_KVM_VFIO and nothing depends on KVM_VFIO.
Setting KVM_VFIO has no effect. Remove that Kconfig symbol.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
I choose not to mention commit 80ce1639727e ("KVM: VFIO: register
kvm_device_ops dynamically") as references to linux-next commits might
go stale and only confuse future readers.

Done on top of next-21040923. Tested with "git grep" only.

 arch/x86/kvm/Kconfig | 1 -
 virt/kvm/Kconfig     | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f9d16ff56c6b..178d872734b1 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -39,7 +39,6 @@ config KVM
 	select PERF_EVENTS
 	select HAVE_KVM_MSI
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
-	select KVM_VFIO
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index fc0c5e603eb4..1f5ebc4693c3 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -34,6 +34,3 @@ config HAVE_KVM_MSI
 
 config HAVE_KVM_CPU_RELAX_INTERCEPT
        bool
-
-config KVM_VFIO
-       bool
-- 
1.9.3

