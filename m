Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab3FMKx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 06:53:59 -0400
Received: from multi.imgtec.com ([194.200.65.239]:19862 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab3FMKx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 06:53:57 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Michal Marek <mmarek@suse.cz>
CC: <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "James Hogan" <james.hogan@imgtec.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>, <trivial@kernel.org>
Subject: [PATCH RESEND] Makefile.lib: align DTB quiet_cmd
Date: Thu, 13 Jun 2013 11:53:09 +0100
Message-ID: <1371120789-18342-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_13_11_53_37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unaligned dtb.S filename in make output started to irritate me:
  DTC     arch/metag/boot/dts/skeleton.dtb
  DTB    arch/metag/boot/dts/skeleton.dtb.S
  AS      arch/metag/boot/dts/skeleton.dtb.o
  LD      arch/metag/boot/dts/built-in.o

Add an extra space to quiet_cmd_dt_S_dtb so the dtb.S filename aligns
with all the others.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: trivial@kernel.org
---
 scripts/Makefile.lib | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 8337663..281f82a 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -244,7 +244,7 @@ cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -n -f -9 > $@) || \
 # ---------------------------------------------------------------------------
 
 # Generate an assembly file to wrap the output of the device tree compiler
-quiet_cmd_dt_S_dtb= DTB    $@
+quiet_cmd_dt_S_dtb= DTB     $@
 cmd_dt_S_dtb=						\
 (							\
 	echo '\#include <asm-generic/vmlinux.lds.h>'; 	\
-- 
1.8.1.2


