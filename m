Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3I1Xhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 19:37:52 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:60987 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab3I1XhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 19:37:05 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH 1/1] fs/binfmt_elf.c: fill_note_info: Reduce scope of a variable
Date: Sat, 28 Sep 2013 20:32:22 -0300
Message-Id: <1380411144-9236-10-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
References: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *t variable in the fill_note_info function is only used if
siginfo->si_signo isn't 0. Moving "t" pointer to that inner scope.

Tested.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/binfmt_elf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 100edcc..d0ac15b 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1848,12 +1848,11 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 			  struct elf_note_info *info,
 			  siginfo_t *siginfo, struct pt_regs *regs)
 {
-	struct list_head *t;
-
 	if (!elf_note_info_init(info))
 		return 0;
 
 	if (siginfo->si_signo) {
+		struct list_head *t;
 		struct core_thread *ct;
 		struct elf_thread_status *ets;
 
-- 
1.8.4

