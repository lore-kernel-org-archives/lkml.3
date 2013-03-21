Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaJPJCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:02:30 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:39117 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbaJPJC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:02:29 -0400
Message-Id: <b8329cd85f075d0886bd837a012b3d922f3174ed.1413223900.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1413223900.git.ydroneaud@opteya.com>
References: <cover.1413223900.git.ydroneaud@opteya.com>
From: Yann Droneaud <ydroneaud@opteya.com>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-ia64@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 20:10:54 +0100
Subject: [PATCHv9 1/5] ia64: trivial: replace get_unused_fd() by
 get_unused_fd_flags(0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces calls to get_unused_fd() with equivalent call to
get_unused_fd_flags(0) to preserve current behavor for existing code.

In a further patch, get_unused_fd() will be removed so that new code
start using get_unused_fd_flags(), with the hope O_CLOEXEC could be
used, either by default or choosen by userspace.

Link: http://lkml.kernel.org/r/cover.1413223900.git.ydroneaud@opteya.com
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: trivial@kernel.org
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 arch/ia64/kernel/perfmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 5845ffea67c3..dc063fe6646a 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2662,7 +2662,7 @@ pfm_context_create(pfm_context_t *ctx, void *arg, int count, struct pt_regs *reg
 
 	ret = -ENOMEM;
 
-	fd = get_unused_fd();
+	fd = get_unused_fd_flags(0);
 	if (fd < 0)
 		return fd;
 
-- 
1.9.3

