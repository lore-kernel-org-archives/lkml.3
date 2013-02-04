Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3BDGma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 01:42:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60250 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3BDGm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 01:42:27 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [RESEND PATCH 3/4] kdump, s390: make saved_max_pfn exclusive
To: ralf@linux-mips.org, michael@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, holzheu@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, vgoyal@redhat.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 04 Feb 2013 15:42:25 +0900
Message-ID: <20130204064225.13324.61463.stgit@localhost6.localdomain6>
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

 arch/s390/kernel/setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index a5360de..3357566 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -729,9 +729,9 @@ static void reserve_oldmem(void)
 	reserve_kdump_bootmem(OLDMEM_SIZE, memory_end - OLDMEM_SIZE,
 			      CHUNK_OLDMEM);
 	if (OLDMEM_BASE + OLDMEM_SIZE == real_memory_size)
-		saved_max_pfn = PFN_DOWN(OLDMEM_BASE) - 1;
+		saved_max_pfn = PFN_DOWN(OLDMEM_BASE);
 	else
-		saved_max_pfn = PFN_DOWN(real_memory_size) - 1;
+		saved_max_pfn = PFN_DOWN(real_memory_size);
 #endif
 }
 

