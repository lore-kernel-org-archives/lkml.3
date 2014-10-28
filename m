Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaJ1ReM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:34:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41561 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaJ1ReK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:34:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andrey Wagin <avagin@gmail.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <87lhp12a2i.fsf@x220.int.ebiederm.org>
	<CALCETrXGojRGtT1B2Aib7m54j8T+LsnCOin_GL93-BWf-eSPkA@mail.gmail.com>
	<87oatxzwex.fsf@x220.int.ebiederm.org>
	<CALCETrUOeCrjAy---FM-8ovU1FD372ShgBeS5_1LUkgRWMQ4gQ@mail.gmail.com>
	<544F9D7D.40301@gmail.com> <87r3xscd88.fsf@x220.int.ebiederm.org>
Date: Tue, 28 Oct 2014 10:33:15 -0700
In-Reply-To: <87r3xscd88.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Tue, 28 Oct 2014 10:31:51 -0700")
Message-ID: <87lho0cd5w.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18NQupxmCDEMj0NRH4gk3Rr50nqCtISkaA=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 462 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 3.7 (0.8%), b_tie_ro: 2.6 (0.6%), parse: 1.18 (0.3%),
	extract_message_metadata: 25 (5.4%), get_uri_detail_list: 1.89 (0.4%),
	tests_pri_-1000: 10 (2.2%), tests_pri_-950: 1.96 (0.4%), tests_pri_-900: 1.59
	(0.3%), tests_pri_-400: 33 (7.1%), check_bayes: 31 (6.7%), b_tokenize: 10
	(2.1%), b_tok_get_all: 8 (1.6%), b_comp_prob: 3.5 (0.8%), b_tok_touch_all: 5
	(1.1%), b_finish: 2.4 (0.5%), tests_pri_0: 374 (81.0%), tests_pri_500: 7
	(1.5%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH] umount.2: Document the effect of shared subtrees on umount
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 man2/umount.2 | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/man2/umount.2 b/man2/umount.2
index aea39d8306fe..a0120b2fc811 100644
--- a/man2/umount.2
+++ b/man2/umount.2
@@ -97,6 +97,24 @@ Don't dereference
 if it is a symbolic link.
 This flag allows security problems to be avoided in set-user-ID-\fIroot\fP
 programs that allow unprivileged users to unmount filesystems.
+
+.P
+Shared mount points cause any mount activity on that mount point
+including umounts to be forwarded to every shared mount point in it's
+peer group and every slave mount of that peer group.  This means that
+umount of any peer in a set of shared mounts will cause all of it's
+peers to be unmounted and all of their slaves to be unmounted as well.
+
+This propogagtion of unmount activity can be particularly surprising
+on systems where every mount point is shared by default.  On such
+systems recursively bind mounting the root directory of the filesystem
+onto a subdirectory and then later unmounting that subdirectory with
+.BR MNT_DETACH
+will cause every mount in the mount namespace to be lazily unmounted.
+
+To ensure umount does not propagate the mount point may be
+remounted with MS_REC | MS_PRIVATE prior to umount being called.
+
 .SH RETURN VALUE
 On success, zero is returned.
 On error, \-1 is returned, and
-- 
1.9.1

