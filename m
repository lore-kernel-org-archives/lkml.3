Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966885Ab3DQV7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 17:59:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965829Ab3DQV7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 17:59:53 -0400
Date: Wed, 17 Apr 2013 14:59:51 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] binfmt_elf: PIE: make PF_RANDOMIZE check comment more
 accurate
Message-ID: <alpine.LNX.2.00.1304171458460.31201@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment I originally added in a3defbe5c337db ("binfmt_elf: fix PIE 
execution with randomization disabled") is not really 100% accurate -- 
sysctl is not the only way how PF_RANDOMIZE could be forcibly unset in 
runtime.

Another option of course is direct modification of personality flags (i.e. 
running through setarch wrapper).

Make the comment more explicit and accurate.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 fs/binfmt_elf.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 3939829..7e533c0 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -803,7 +803,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			 * follow the loader, and is not movable.  */
 #ifdef CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE
 			/* Memory randomization might have been switched off
-			 * in runtime via sysctl.
+			 * in runtime via sysctl or explicit setting of
+			 * personality flags.
 			 * If that is the case, retain the original non-zero
 			 * load_bias value in order to establish proper
 			 * non-randomized mappings.
-- 
Jiri Kosina
SUSE Labs
