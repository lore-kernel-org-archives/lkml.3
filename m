Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbaIWCm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:42:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:38660 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870AbaIWClC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:41:02 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Guenter Roeck <linux@roeck-us.net>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 42/45] UniCore32-bugfix: fix mismatch return value of __xchg_bad_pointer
Date: Tue, 23 Sep 2014 10:31:44 +0800
Message-Id: <1411439507-30391-42-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 195d4577d1d7ab1f0398b3190547c116b56f435f upstream.

When disintegrate system.h, I left an error in asm/cmpxchg.h, which
will result in following error:

arch/unicore32/include/asm/cmpxchg.h: In function '__xchg':
arch/unicore32/include/asm/cmpxchg.h:38: error: void value not ignored as it ought to be

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/unicore32/include/asm/cmpxchg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/unicore32/include/asm/cmpxchg.h b/arch/unicore32/include/asm/cmpxchg.h
index df4d5ac..8e797ad 100644
--- a/arch/unicore32/include/asm/cmpxchg.h
+++ b/arch/unicore32/include/asm/cmpxchg.h
@@ -35,7 +35,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
 			: "memory", "cc");
 		break;
 	default:
-		ret = __xchg_bad_pointer();
+		__xchg_bad_pointer();
 	}
 
 	return ret;
-- 
1.7.9.5

