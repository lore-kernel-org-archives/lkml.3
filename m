Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab3AQCzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:55:50 -0500
Received: from smtp.outflux.net ([198.145.64.163]:51975 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757581Ab3AQCzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:55:45 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Alexander Graf <agraf@suse.de>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 30/86] arch/powerpc/kvm: remove depends on CONFIG_EXPERIMENTAL
Date: Wed, 16 Jan 2013 18:53:22 -0800
Message-Id: <1358391258-1771-31-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358391258-1771-1-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/powerpc/kvm/Kconfig |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 4730c95..63c67ec 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -41,7 +41,7 @@ config KVM_BOOK3S_PR
 
 config KVM_BOOK3S_32
 	tristate "KVM support for PowerPC book3s_32 processors"
-	depends on EXPERIMENTAL && PPC_BOOK3S_32 && !SMP && !PTE_64BIT
+	depends on PPC_BOOK3S_32 && !SMP && !PTE_64BIT
 	select KVM
 	select KVM_BOOK3S_32_HANDLER
 	select KVM_BOOK3S_PR
@@ -56,7 +56,7 @@ config KVM_BOOK3S_32
 
 config KVM_BOOK3S_64
 	tristate "KVM support for PowerPC book3s_64 processors"
-	depends on EXPERIMENTAL && PPC_BOOK3S_64
+	depends on PPC_BOOK3S_64
 	select KVM_BOOK3S_64_HANDLER
 	select KVM
 	---help---
@@ -97,7 +97,7 @@ config KVM_BOOKE_HV
 
 config KVM_440
 	bool "KVM support for PowerPC 440 processors"
-	depends on EXPERIMENTAL && 44x
+	depends on 44x
 	select KVM
 	select KVM_MMIO
 	---help---
@@ -122,7 +122,7 @@ config KVM_EXIT_TIMING
 
 config KVM_E500V2
 	bool "KVM support for PowerPC E500v2 processors"
-	depends on EXPERIMENTAL && E500 && !PPC_E500MC
+	depends on E500 && !PPC_E500MC
 	select KVM
 	select KVM_MMIO
 	select MMU_NOTIFIER
@@ -137,7 +137,7 @@ config KVM_E500V2
 
 config KVM_E500MC
 	bool "KVM support for PowerPC E500MC/E5500 processors"
-	depends on EXPERIMENTAL && PPC_E500MC
+	depends on PPC_E500MC
 	select KVM
 	select KVM_MMIO
 	select KVM_BOOKE_HV
-- 
1.7.9.5

