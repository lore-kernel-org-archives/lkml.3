Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaLHWQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:16:41 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36314 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaLHWQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:16:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>,
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
	<87h9xez20g.fsf@x220.int.ebiederm.org>
	<CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
	<87mw75ygwp.fsf@x220.int.ebiederm.org>
	<CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
	<87fvcxyf28.fsf_-_@x220.int.ebiederm.org>
	<874mtdyexp.fsf_-_@x220.int.ebiederm.org>
	<CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
	<87a935u3nj.fsf@x220.int.ebiederm.org>
	<CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
	<87388xodlj.fsf@x220.int.ebiederm.org>
	<CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
	<87h9x5re41.fsf_-_@x220.int.ebiederm.org>
Date: Mon, 08 Dec 2014 16:14:21 -0600
In-Reply-To: <87h9x5re41.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 08 Dec 2014 16:06:06 -0600")
Message-ID: <87egs9pz5u.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18qAtV869/l8Z6PXUvW9ODg1Lbkkjvvsiw=
X-SA-Exim-Connect-IP: 67.3.210.55
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 251 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 6 (2.3%), b_tie_ro: 4.3 (1.7%), parse: 1.47 (0.6%),
	extract_message_metadata: 15 (5.8%), get_uri_detail_list: 1.17 (0.5%),
	tests_pri_-1000: 8 (3.1%), tests_pri_-950: 1.73 (0.7%), tests_pri_-900: 1.22
	(0.5%), tests_pri_-400: 25 (9.9%), check_bayes: 24 (9.4%), b_tokenize: 7
	(2.6%), b_tok_get_all: 9 (3.8%), b_comp_prob: 1.72 (0.7%), b_tok_touch_all:
	3.4 (1.4%), b_finish: 0.69 (0.3%), tests_pri_0: 182 (72.5%), tests_pri_500: 6
	(2.3%), rewrite_mail: 0.00 (0.0%)
Subject: [CFT][PATCH 7/7] userns: Allow setting gid_maps without privilege when setgroups is disabled
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that setgroups can be disabled and not reenabled, setting gid_map
without privielge can now be enabled when setgroups is disabled.

This restores most of the functionality that was lost when unprivilege
setting of gid_map was removed.  Applications that use this
functionality will need to check to see if they use setgroups or
init_groups, and if they don't they can be fixed by simply
disabling of setgroups before they run.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/user_namespace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 3d128f91ced3..459c7f647072 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -828,6 +828,11 @@ static bool new_idmap_permitted(const struct file *file,
 			kuid_t uid = make_kuid(ns->parent, id);
 			if (uid_eq(uid, cred->euid))
 				return true;
+		} else if (cap_setid == CAP_SETGID) {
+			kgid_t gid = make_kgid(ns->parent, id);
+			if (!userns_setgroups_allowed(ns) &&
+			    gid_eq(gid, cred->egid))
+				return true;
 		}
 	}
 
-- 
1.9.1

