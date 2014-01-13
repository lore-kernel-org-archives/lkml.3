Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaAMLhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:37:20 -0500
Received: from linux-libre.fsfla.org ([208.118.235.54]:54913 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaAMLhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:37:17 -0500
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2014 06:37:17 EST
From: Alexandre Oliva <oliva@gnu.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [3.13-rc regression] Unbreak Loongson2 and r4k-generic flush icache range
Organization: Free thinker, not speaking for the GNU Project
Date: Mon, 13 Jan 2014 09:26:10 -0200
Message-ID: <ord2jwnmwd.fsf@livre.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 14bd8c08, that replaced Loongson2-specific ifdefs with cpu tests,
inverted the CPU test in local_r4k_flush_icache_range.  Loongson2 won't
boot up using the generic icache flush code.  Presumably other CPUs
might face other problems when presented with Loongson2-specific icache
flush code too.  This patch enabled my Yeeloong to boot up successfully
a 3.13-rc kernel for the first time, after a long git bisect session.

Signed-off-by: Alexandre Oliva <lxoliva@fsfla.org>
---
 arch/mips/mm/c-r4k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 62ffd20..1c2029d 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -580,11 +580,11 @@ static inline void local_r4k_flush_icache_range(unsigned long start, unsigned lo
 	else {
 		switch (boot_cpu_type()) {
 		case CPU_LOONGSON2:
-			protected_blast_icache_range(start, end);
+			protected_loongson23_blast_icache_range(start, end);
 			break;
 
 		default:
-			protected_loongson23_blast_icache_range(start, end);
+			protected_blast_icache_range(start, end);
 			break;
 		}
 	}
-- 
1.8.3.1

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
