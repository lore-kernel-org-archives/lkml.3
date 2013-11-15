Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab3KOO5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:57:14 -0500
Received: from shell.v3.sk ([195.168.3.45]:42037 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab3KOO5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:57:08 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] jbd: Lower severity of aborted journal from EMERG to CRIT
Date: Fri, 15 Nov 2013 15:56:52 +0100
Message-Id: <1384527412-23349-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation/kernel-parameters.txt, KERN_EMERG is reserved for
events that render system unusable.

This is hardly the case in case of flash memory stick hardware removal without
umounting. Syslog is often configured to forward messages with EMERG severity
to all logged-in terminals, often causing unnecessary noise.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 fs/jbd/journal.c  |    2 +-
 fs/jbd2/journal.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 2d04f9a..9dbc1b6 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -605,7 +605,7 @@ out_unlock:
 	spin_unlock(&journal->j_state_lock);
 
 	if (unlikely(is_journal_aborted(journal))) {
-		printk(KERN_EMERG "journal commit I/O error\n");
+		printk(KERN_CRIT "journal commit I/O error\n");
 		err = -EIO;
 	}
 	return err;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5203264..2d1f53c 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -719,7 +719,7 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
 	read_unlock(&journal->j_state_lock);
 
 	if (unlikely(is_journal_aborted(journal))) {
-		printk(KERN_EMERG "journal commit I/O error\n");
+		printk(KERN_CRIT "journal commit I/O error\n");
 		err = -EIO;
 	}
 	return err;
-- 
1.7.1

