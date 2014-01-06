Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaAFMst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:48:49 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:39169 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaAFMss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:48:48 -0500
Date: Mon, 6 Jan 2014 15:45:59 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Alexander Holler <holler@ahsoftware.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next] x86 memtest: use NUMA_NO_NODE in do_one_pass()
Message-ID: <20140106124559.GC2247@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 68abcdf54742a ("mm/memblock: use WARN_ONCE when MAX_NUMNODES
passed as input parameter") has deprecated usage of MAX_NUMNODES
in __next_free_mem_range(). Pass NUMA_NO_NODE to for_each_free_mem_range().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 arch/x86/mm/memtest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 8dabbed..1e9da79 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -74,7 +74,7 @@ static void __init do_one_pass(u64 pattern, u64 start, u64 end)
 	u64 i;
 	phys_addr_t this_start, this_end;
 
-	for_each_free_mem_range(i, MAX_NUMNODES, &this_start, &this_end, NULL) {
+	for_each_free_mem_range(i, NUMA_NO_NODE, &this_start, &this_end, NULL) {
 		this_start = clamp_t(phys_addr_t, this_start, start, end);
 		this_end = clamp_t(phys_addr_t, this_end, start, end);
 		if (this_start < this_end) {

