Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3AaLOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:14:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36473 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab3AaLN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:13:57 -0500
Date: Thu, 31 Jan 2013 03:11:30 -0800
From: tip-bot for Borislav Petkov <bp@suse.de>
Message-ID: <tip-1e9209edc71b851d81f0316ca03a0e6335c0ef9a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave@linux.vnet.ibm.com, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dave@linux.vnet.ibm.com, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1359245901-8512-1-git-send-email-bp@alien8.de>
References: <1359245901-8512-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/numa: Use __pa_nodebug() instead
Git-Commit-ID: 1e9209edc71b851d81f0316ca03a0e6335c0ef9a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 03:11:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e9209edc71b851d81f0316ca03a0e6335c0ef9a
Gitweb:     http://git.kernel.org/tip/1e9209edc71b851d81f0316ca03a0e6335c0ef9a
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sun, 27 Jan 2013 01:18:21 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 31 Jan 2013 11:40:55 +0100

x86/numa: Use __pa_nodebug() instead

... and fix the following warning:

  arch/x86/mm/numa.c: In function ‘setup_node_data’:
  arch/x86/mm/numa.c:222:3: warning: passing argument 1 of ‘__phys_addr_nodebug’ makes integer from pointer without a cast

Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1359245901-8512-1-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 76604eb..b2313c6 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -219,7 +219,7 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	 */
 	nd = alloc_remap(nid, nd_size);
 	if (nd) {
-		nd_pa = __phys_addr_nodebug(nd);
+		nd_pa = __pa_nodebug(nd);
 		remapped = true;
 	} else {
 		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
