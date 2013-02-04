Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3BDGZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 01:25:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36347 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3BDGZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 01:25:04 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 3/4] kdump, s390: make saved_max_pfn exclusive
To: ralf@linux-mips.org, michael@ellerman.id.au, benh@kernel.crashing.org,
        paulus@samba.org, holzheu@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, vgoyal@in.ibm.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 04 Feb 2013 15:25:01 +0900
Message-ID: <20130204062501.13161.57145.stgit@localhost6.localdomain6>
In-Reply-To: <20130204062349.13161.29478.stgit@localhost6.localdomain6>
References: <20130204062349.13161.29478.stgit@localhost6.localdomain6>
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
 

