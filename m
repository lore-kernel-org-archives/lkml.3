Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112AbaIFC1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 22:27:46 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:41238 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaIFC1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 22:27:44 -0400
Subject: [PATCH] MIPS: Remove a temporary hack for debugging cache flushes in
	SMTC configuration
To: <linux-mips@linux-mips.org>, <aaro.koskinen@iki.fi>,
        <david.daney@cavium.com>, <linux-kernel@vger.kernel.org>,
        <ralf@linux-mips.org>, <markos.chandras@imgtec.com>,
        <dengcheng.zhu@imgtec.com>, <chenhc@lemote.com>,
        <akpm@linux-foundation.org>
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Date: Fri, 5 Sep 2014 19:27:38 -0700
Message-ID: <20140906022738.6957.53838.stgit@linux-yegoshin>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a temporary hack for debugging SMTC configuration from

	commit 41c594ab65fc89573af296d192aa5235d09717ab
	Author: Ralf Baechle <ralf@linux-mips.org>
	Date:   Wed Apr 5 09:45:45 2006 +0100

which is dropped now. Some performance degradation for multi-VPE systems
is removed.

Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
---
 arch/mips/include/asm/r4kcache.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/r4kcache.h b/arch/mips/include/asm/r4kcache.h
index 4520adc..b2ae1b1 100644
--- a/arch/mips/include/asm/r4kcache.h
+++ b/arch/mips/include/asm/r4kcache.h
@@ -50,7 +50,6 @@ extern void (*r4k_blast_icache)(void);
 /*
  * Optionally force single-threaded execution during I-cache flushes.
  */
-#define PROTECT_CACHE_FLUSHES 1
 
 #ifdef PROTECT_CACHE_FLUSHES
 

