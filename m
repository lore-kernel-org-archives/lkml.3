Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaJORGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:06:25 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:59327 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaJORGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:06:20 -0400
Subject: [PATCH v1 05/10] MIPS: MT: Move "weak" from vpe_run() declaration
 to definition
To: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 11:06:17 -0600
Message-ID: <20141015170617.4063.2807.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the "weak" attribute is on a declaration in a header file, every
definition where the header is included becomes weak, and the linker
chooses one definition based on link order (see 10629d711ed7 ("PCI: Remove
__weak annotation from pcibios_get_phb_of_node decl")).

Move the "weak" attribute from the declaration to the default definition so
we always prefer a non-weak definition over the weak one, independent of
link order.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-mips@linux-mips.org
---
 arch/mips/include/asm/vpe.h |    2 +-
 arch/mips/kernel/vpe-mt.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/vpe.h b/arch/mips/include/asm/vpe.h
index 7849f3978fea..80e70dbd1f64 100644
--- a/arch/mips/include/asm/vpe.h
+++ b/arch/mips/include/asm/vpe.h
@@ -122,7 +122,7 @@ void release_vpe(struct vpe *v);
 void *alloc_progmem(unsigned long len);
 void release_progmem(void *ptr);
 
-int __weak vpe_run(struct vpe *v);
+int vpe_run(struct vpe *v);
 void cleanup_tc(struct tc *tc);
 
 int __init vpe_module_init(void);
diff --git a/arch/mips/kernel/vpe-mt.c b/arch/mips/kernel/vpe-mt.c
index 2e003b11a098..0e5899a2cd96 100644
--- a/arch/mips/kernel/vpe-mt.c
+++ b/arch/mips/kernel/vpe-mt.c
@@ -23,7 +23,7 @@ static int major;
 static int hw_tcs, hw_vpes;
 
 /* We are prepared so configure and start the VPE... */
-int vpe_run(struct vpe *v)
+int __weak vpe_run(struct vpe *v)
 {
 	unsigned long flags, val, dmt_flag;
 	struct vpe_notifications *notifier;

