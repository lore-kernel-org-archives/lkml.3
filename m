Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3BFCwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:52:24 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:43203 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3BFCwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:52:23 -0500
Message-ID: <1360119136.8356.4.camel@lorien2>
Subject: [PATCH linux-next] x86/mm: Fix compile warning in remove_pagetable()
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
        hpa@zytor.com, mingo@redhat.com, yinghai@kernel.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, shuahkhan@gmail.com
Date: Tue, 05 Feb 2013 19:52:16 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compile warning in remove_pagetable():
arch/x86/mm/init_64.c: In function ‘remove_pagetable’:
arch/x86/mm/init_64.c:996:9: warning: ‘next’ may be used uninitialized in this function [-Wuninitialized]


Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 67bad4b..ed78400 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -987,7 +987,7 @@ remove_pud_table(pud_t *pud_start, unsigned long addr, unsigned long end,
 static void __meminit
 remove_pagetable(unsigned long start, unsigned long end, bool direct)
 {
-	unsigned long next;
+	unsigned long next = pgd_addr_end(start, end);
 	pgd_t *pgd;
 	pud_t *pud;
 	bool pgd_changed = false;
-- 
1.7.9.5



