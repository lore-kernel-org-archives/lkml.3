Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaDMNMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 09:12:51 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:35952 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754338AbaDMNMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 09:12:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0GALGMSlNXQ5wQ/2dsb2JhbABZgwaCS4EYwFyBGBd0glMTHCMYgQIkE4gAAcodF45uhD8BA45figEBimSHX4MzOw
Date: Sun, 13 Apr 2014 15:12:47 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: viro <viro@zeniv.linux.org.uk>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/binfmt_elf.c: fix bool assignements
Message-Id: <20140413151247.6b7fe6c8e82d197dee00d5af@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing coccinelle warnings.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/binfmt_elf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index aa3cb62..dabc73a 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1686,7 +1686,7 @@ static size_t get_note_info_size(struct elf_note_info *info)
 static int write_note_info(struct elf_note_info *info,
 			   struct coredump_params *cprm)
 {
-	bool first = 1;
+	bool first = true;
 	struct elf_thread_core_info *t = info->thread;
 
 	do {
@@ -1710,7 +1710,7 @@ static int write_note_info(struct elf_note_info *info,
 			    !writenote(&t->notes[i], cprm))
 				return 0;
 
-		first = 0;
+		first = false;
 		t = t->next;
 	} while (t);
 
-- 
1.8.3.2
