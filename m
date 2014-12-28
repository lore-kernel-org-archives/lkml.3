Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaL1QPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 11:15:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55151 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaL1QPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 11:15:38 -0500
Date: Sun, 28 Dec 2014 17:15:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] Ensure different messages in STRICT_DEVMEM and PAT cases
Message-ID: <20141228161524.GA10442@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 823a62aebddaec01fd776a8dd4f8f4a5b419e3f9
Author: Pavel <pavel@ucw.cz>
Date:   Sun Dec 28 17:04:02 2014 +0100

STRICT_DEVMEM and PAT produce same failure accessing /dev/mem, which
is quite confusing to the user. Make printk messages different to
lessen confusion.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 6574388..2b6f5d8 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -488,7 +488,7 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 }
 
 #ifdef CONFIG_STRICT_DEVMEM
-/* This check is done in drivers/char/mem.c in case of STRICT_DEVMEM*/
+/* This check is done in drivers/char/mem.c in case of STRICT_DEVMEM */
 static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
 	return 1;
@@ -506,7 +506,7 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 
 	while (cursor < to) {
 		if (!devmem_is_allowed(pfn)) {
pp-			printk(KERN_INFO "Program %s tried to access /dev/mem between [mem %#010Lx-%#010Lx]\n",
+			printk(KERN_INFO "Program %s tried to access /dev/mem between [mem %#010Lx-%#010Lx], PAT prevents it\n",
 				current->comm, from, to - 1);
 			return 0;
 		}

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
