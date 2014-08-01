Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaHAAhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 20:37:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45548 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaHAAhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 20:37:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: linux-api@vger.kernel.org,
        "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
Date: Thu, 31 Jul 2014 17:33:27 -0700
In-Reply-To: <87oaw5caq1.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 31 Jul 2014 17:30:46 -0700")
Message-ID: <87ha1xcalk.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/7r+ktrqEwvfEYTRkq16VuQWSD0EBYdV0=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0089]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 1/4] proc: Have net show up under /proc/<tgid>/task/<tid>
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Network namespaces are per task so it make sense for them to show up
in the task directory.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2d696b0c93bf..ed34e405c6b9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2895,6 +2895,9 @@ static const struct pid_entry tid_base_stuff[] = {
 	DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
 	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	DIR("ns",	 S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
+#ifdef CONFIG_NET
+	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
+#endif
 	REG("environ",   S_IRUSR, proc_environ_operations),
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
-- 
1.9.1

