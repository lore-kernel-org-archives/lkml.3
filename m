Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaI3BEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:04:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33875 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaI3BEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:04:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andrey Wagin <avagin@gmail.com>,
        <linux-fsdevel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 29 Sep 2014 18:04:05 -0700
Message-ID: <87lhp12a2i.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/kOm7E4zebGeVlSzcXWBd7WonoGTWWH+M=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2890]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Michael Kerrisk <mtk.manpages@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 2324 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 3.8 (0.2%), b_tie_ro: 2.8 (0.1%), parse: 0.79 (0.0%),
	extract_message_metadata: 16 (0.7%), get_uri_detail_list: 1.09 (0.0%),
	tests_pri_-1000: 6 (0.3%), tests_pri_-950: 1.41 (0.1%), tests_pri_-900: 1.09
	(0.0%), tests_pri_-400: 17 (0.7%), check_bayes: 16 (0.7%), b_tokenize: 4.4
	(0.2%), b_tok_get_all: 5 (0.2%), b_comp_prob: 1.70 (0.1%), b_tok_touch_all:
	1.92 (0.1%), b_finish: 0.81 (0.0%), tests_pri_0: 2269 (97.6%), tests_pri_500:
	6 (0.2%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH] umount.2: Correct the description of MNT_DETACH
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I recently realized that I had been reasoning improperly about what
umount(MNT_DETACH) did based on an insufficient description in
the umount.2 man page, that matched my intuition but not the
implementation.

When there are no submounts MNT_DETACH is essentially harmless to
applications.  Where there are submounts MNT_DETACH changes what
is visible to applications using the detach directories.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 man2/umount.2 | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/man2/umount.2 b/man2/umount.2
index 5ff88152c738..aea39d8306fe 100644
--- a/man2/umount.2
+++ b/man2/umount.2
@@ -66,9 +66,10 @@ This can cause data loss.
 (Only for NFS mounts.)
 .TP
 .BR MNT_DETACH " (since Linux 2.4.11)"
-Perform a lazy unmount: make the mount point unavailable for
-new accesses, and actually perform the unmount when the mount point
-ceases to be busy.
+Perform a lazy unmount: make the mount point unavailable for new
+accesses, immediately disconnect the filesystem and all filesystems
+mounted below it from each other and from the mount table, and
+actually perform the unmount when the mount point ceases to be busy.
 .TP
 .BR MNT_EXPIRE " (since Linux 2.6.8)"
 Mark the mount point as expired.
-- 
1.9.1

