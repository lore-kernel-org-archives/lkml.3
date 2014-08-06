Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbaHFMz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:55:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbaHFMzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:55:53 -0400
From: Mel Gorman <mgorman@suse.de>
To: H Peter Anvin <hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <mgalbraith@suse.de>, Linux-X86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3/3] x86, fpu: Do not update fpu_counter in the eagerfpu case
Date: Wed,  6 Aug 2014 13:55:48 +0100
Message-Id: <1407329748-3928-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1407329748-3928-1-git-send-email-mgorman@suse.de>
References: <1407329748-3928-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the non-lazy FPU restore case there is no need for fpu_counter. This
patch avoids updating the counter unnecessarily.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/include/asm/fpu-internal.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 8d92807..85fdd6b 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -427,12 +427,10 @@ static inline void switch_eagerfpu_prepare(struct task_struct *old, struct task_
 		old->thread.fpu.last_cpu = cpu;
 		old->thread.fpu.has_fpu = 0;	/* But leave fpu_owner_task! */
 	} else {
-		old->thread.fpu_counter = 0;
 		old->thread.fpu.last_cpu = ~0;
 	}
 
 	if (fpu->preload) {
-		new->thread.fpu_counter++;
 		__thread_set_has_fpu(new);
 		prefetch(new->thread.fpu.state);
 	}
-- 
1.8.4.5

