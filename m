Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3BDGmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 01:42:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56528 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3BDGmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 01:42:22 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [RESEND PATCH 2/4] kdump, ppc: make saved_max_pfn exclusive
To: ralf@linux-mips.org, michael@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, holzheu@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, vgoyal@redhat.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 04 Feb 2013 15:42:19 +0900
Message-ID: <20130204064219.13324.25714.stgit@localhost6.localdomain6>
In-Reply-To: <20130204064112.13324.89478.stgit@localhost6.localdomain6>
References: <20130204064112.13324.89478.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 arch/powerpc/kernel/crash_dump.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/crash_dump.c b/arch/powerpc/kernel/crash_dump.c
index b3ba516..fa64170 100644
--- a/arch/powerpc/kernel/crash_dump.c
+++ b/arch/powerpc/kernel/crash_dump.c
@@ -72,7 +72,7 @@ void __init setup_kdump_trampoline(void)
 static int __init parse_savemaxmem(char *p)
 {
 	if (p)
-		saved_max_pfn = (memparse(p, &p) >> PAGE_SHIFT) - 1;
+		saved_max_pfn = (memparse(p, &p) >> PAGE_SHIFT);
 
 	return 1;
 }

