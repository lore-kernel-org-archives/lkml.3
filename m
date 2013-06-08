Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3FHRbv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 13:31:51 -0400
Received: from threespeedlogic.com ([75.98.167.93]:34812 "EHLO
	threespeedlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3FHRbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 13:31:49 -0400
X-Greylist: delayed 2246 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Jun 2013 13:31:49 EDT
From: Graeme Smecher <gsmecher@threespeedlogic.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Smecher <gsmecher@threespeedlogic.com>,
        Michal Simek <monstr@monstr.eu>
Subject: [PATCH] microblaze: Don't mark arch_kgdb_ops as const.
Date: Sat,  8 Jun 2013 09:52:08 -0700
Message-Id: <1370710328-15011-1-git-send-email-gsmecher@threespeedlogic.com>
X-Mailer: git-send-email 1.7.7.3
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s63.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - threespeedlogic.com
X-Get-Message-Sender-Via: a2s63.a2hosting.com: authenticated_id: gsmecher+threespeedlogic.com/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other architectures don't do it, and it conflicts with the extern'd definition
in include/linux/kgdb.h.

Signed-off-by: Graeme Smecher <gsmecher@threespeedlogic.com>
CC: Michal Simek <monstr@monstr.eu>
CC: linux-kernel@vger.kernel.org
---
 arch/microblaze/kernel/kgdb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/kgdb.c b/arch/microblaze/kernel/kgdb.c
index 8adc9244..09a5e82 100644
--- a/arch/microblaze/kernel/kgdb.c
+++ b/arch/microblaze/kernel/kgdb.c
@@ -141,7 +141,7 @@ void kgdb_arch_exit(void)
 /*
  * Global data
  */
-const struct kgdb_arch arch_kgdb_ops = {
+struct kgdb_arch arch_kgdb_ops = {
 #ifdef __MICROBLAZEEL__
 	.gdb_bpt_instr = {0x18, 0x00, 0x0c, 0xba}, /* brki r16, 0x18 */
 #else
-- 
1.7.7.3

