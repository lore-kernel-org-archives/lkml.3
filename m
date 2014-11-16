Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaKPK5P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:57:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34860 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbaKPK5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:57:12 -0500
Date: Sun, 16 Nov 2014 02:57:00 -0800
From: tip-bot for Juergen Gross <tipbot@zytor.com>
Message-ID: <tip-102e19e1955d85f31475416b1ee22980c6462cf8@git.kernel.org>
Cc: hpa@zytor.com, tglx@linutronix.de, jgross@suse.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org
Reply-To: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        jgross@suse.com, mingo@kernel.org
In-Reply-To: <1415019724-4317-11-git-send-email-jgross@suse.com>
References: <1415019724-4317-11-git-send-email-jgross@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86:
  Remove looking for setting of _PAGE_PAT_LARGE in pageattr.c
Git-Commit-ID: 102e19e1955d85f31475416b1ee22980c6462cf8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  102e19e1955d85f31475416b1ee22980c6462cf8
Gitweb:     http://git.kernel.org/tip/102e19e1955d85f31475416b1ee22980c6462cf8
Author:     Juergen Gross <jgross@suse.com>
AuthorDate: Mon, 3 Nov 2014 14:01:56 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 16 Nov 2014 11:04:25 +0100

x86: Remove looking for setting of _PAGE_PAT_LARGE in pageattr.c

When modifying page attributes via change_page_attr_set_clr() don't
test for setting _PAGE_PAT_LARGE, as this is
- never done
- PAT support for large pages is not included in the kernel up to now

Signed-off-by: Juergen Gross <jgross@suse.com>
Cc: stefan.bader@canonical.com
Cc: xen-devel@lists.xensource.com
Cc: konrad.wilk@oracle.com
Cc: ville.syrjala@linux.intel.com
Cc: david.vrabel@citrix.com
Cc: jbeulich@suse.com
Cc: toshi.kani@hp.com
Cc: plagnioj@jcrosoft.com
Cc: tomi.valkeinen@ti.com
Cc: bhelgaas@google.com
Link: http://lkml.kernel.org/r/1415019724-4317-11-git-send-email-jgross@suse.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/pageattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index ae242a7..87c0d36 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1307,7 +1307,7 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 static inline int cache_attr(pgprot_t attr)
 {
 	return pgprot_val(attr) &
-		(_PAGE_PAT | _PAGE_PAT_LARGE | _PAGE_PWT | _PAGE_PCD);
+		(_PAGE_PAT | _PAGE_PWT | _PAGE_PCD);
 }
 
 static int change_page_attr_set_clr(unsigned long *addr, int numpages,
