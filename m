Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848Ab3HBKKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:10:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab3HBKJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:09:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, PaX Team <pageexec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [ 44/99] x86: make sure IDT is page aligned
Date: Fri,  2 Aug 2013 18:07:57 +0800
Message-Id: <20130802100232.233216002@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

based on 4df05f361937ee86e5a8c9ead8aeb6a19ea9b7d7 upstream.

Since the IDT is referenced from a fixmap, make sure it is page aligned.
This avoids the risk of the IDT ever being moved in the bss and having
the mapping be offset, resulting in calling incorrect handlers. In the
current upstream kernel this is not a manifested bug, but heavily patched
kernels (such as those using the PaX patch series) did encounter this bug.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: PaX Team <pageexec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/head_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -513,7 +513,7 @@ ENTRY(phys_base)
 #include "../../x86/xen/xen-head.S"
 	
 	.section .bss, "aw", @nobits
-	.align L1_CACHE_BYTES
+	.align PAGE_SIZE
 ENTRY(idt_table)
 	.skip IDT_ENTRIES * 16
 


