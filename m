Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaHAAiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 20:38:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45794 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaHAAiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 20:38:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: linux-api@vger.kernel.org,
        "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
Date: Thu, 31 Jul 2014 17:34:32 -0700
In-Reply-To: <87oaw5caq1.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 31 Jul 2014 17:30:46 -0700")
Message-ID: <8761idcajr.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+0q84Ch1YTK6QbsI6I0Fh6V4qCK17Bo2s=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0398]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net instead of /proc/self/net
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In oddball cases where the thread has a different network namespace
than the primary thread group leader or more likely in cases where
the thread remains and the thread group leader has exited this
ensures that /proc/net continues to work.

This should not cause any problems but if it does this patch can just
be reverted.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/proc_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index a63af3e0a612..39481028ec08 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -226,7 +226,7 @@ static struct pernet_operations __net_initdata proc_net_ns_ops = {
 
 int __init proc_net_init(void)
 {
-	proc_symlink("net", NULL, "self/net");
+	proc_symlink("net", NULL, "thread-self/net");
 
 	return register_pernet_subsys(&proc_net_ns_ops);
 }
-- 
1.9.1

