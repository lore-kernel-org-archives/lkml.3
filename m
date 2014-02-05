Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbaBEUQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:16:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:55583 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbaBEUH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:57 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 194/213] Remove user-triggerable BUG from mpol_to_str
Date: Wed, 5 Feb 2014 15:02:29 -0500
Message-ID: <1391630568-49251-195-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 80de7c3138ee9fd86a98696fd2cf7ad89b995d0a upstream.

Trivially triggerable, found by trinity:

  kernel BUG at mm/mempolicy.c:2546!
  Process trinity-child2 (pid: 23988, threadinfo ffff88010197e000, task ffff88007821a670)
  Call Trace:
    show_numa_map+0xd5/0x450
    show_pid_numa_map+0x13/0x20
    traverse+0xf2/0x230
    seq_read+0x34b/0x3e0
    vfs_read+0xac/0x180
    sys_pread64+0xa2/0xc0
    system_call_fastpath+0x1a/0x1f
  RIP: mpol_to_str+0x156/0x360

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index ae43da3aff5a..1d5c89a7e128 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2330,7 +2330,7 @@ int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol, int no_context)
 		break;
 
 	default:
-		BUG();
+		return -EINVAL;
 	}
 
 	l = strlen(policy_types[mode]);
-- 
1.8.5.2

