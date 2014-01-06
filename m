Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaAFMnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:43:17 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:57752 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaAFMnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:43:14 -0500
Date: Mon, 6 Jan 2014 15:40:26 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next] check: use NUMA_NO_NODE in
 setup_bios_corruption_check()
Message-ID: <20140106124026.GA2247@swordfish>
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

 arch/x86/kernel/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index e2dbcb7..83a7995 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -91,7 +91,7 @@ void __init setup_bios_corruption_check(void)
 
 	corruption_check_size = round_up(corruption_check_size, PAGE_SIZE);
 
-	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL) {
+	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL) {
 		start = clamp_t(phys_addr_t, round_up(start, PAGE_SIZE),
 				PAGE_SIZE, corruption_check_size);
 		end = clamp_t(phys_addr_t, round_down(end, PAGE_SIZE),

