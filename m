Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaHAAjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 20:39:16 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57104 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaHAAjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 20:39:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: linux-api@vger.kernel.org,
        "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
Date: Thu, 31 Jul 2014 17:35:27 -0700
In-Reply-To: <87oaw5caq1.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 31 Jul 2014 17:30:46 -0700")
Message-ID: <87wqatavxs.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+uu389svZ+GOrJS2H9ld5ZtMhtfawGEDU=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1770]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 4/4] proc: Point /proc/mounts at /proc/thread-self/mounts instead of /proc/self/mounts
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In oddball cases where the thread has a different mount namespace than
the thread group leader or more likely in cases where the thread
remains and the thread group leader has exited this ensures that
/proc/mounts continues to work.

This should not cause any problems but if it does this patch can just
be reverted.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/root.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 48f1c03bc7ed..92c12c243ce3 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -173,7 +173,7 @@ void __init proc_root_init(void)
 
 	proc_self_init();
 	proc_thread_self_init();
-	proc_symlink("mounts", NULL, "self/mounts");
+	proc_symlink("mounts", NULL, "thread-self/mounts");
 
 	proc_net_init();
 
-- 
1.9.1

