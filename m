Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbaAUVqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:46:44 -0500
Received: from mail.windriver.com ([147.11.1.11]:56236 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaAUVYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:24:31 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <kvm@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH 11/73] powerpc: book3s KVM can be modular so it should use module.h
Date: Tue, 21 Jan 2014 16:22:14 -0500
Message-ID: <1390339396-3479-12-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though KVM is bool, KVM_BOOK3S_32 and KVM_BOOK3S_64 are declared
as Kconfig tristate, so this file really should be including
module.h instead of export.h -- it only works currently because
module_init is currently (mis)placed in init.h -- but we are
intending to clean that up and relocate it to module.h

Cc: Gleb Natapov <gleb@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: kvm@vger.kernel.org
Cc: kvm-ppc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kvm/book3s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 8912608..279459e 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -16,7 +16,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/err.h>
-#include <linux/export.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 
 #include <asm/reg.h>
-- 
1.8.4.1

