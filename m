Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaLHWJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:09:24 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33759 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbaLHWJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:09:19 -0500
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
Date: Mon, 08 Dec 2014 16:07:02 -0600
In-Reply-To: <87h9x5re41.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 08 Dec 2014 16:06:06 -0600")
Message-ID: <87bnndre2h.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+c8FXLg/zi8gArnGJpaab2j2J3WITHmw8=
X-SA-Exim-Connect-IP: 67.3.210.55
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 702 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 2.5 (0.4%), b_tie_ro: 1.70 (0.2%), parse: 0.98 (0.1%),
	extract_message_metadata: 16 (2.3%), get_uri_detail_list: 2.0 (0.3%),
	tests_pri_-1000: 8 (1.1%), tests_pri_-950: 1.54 (0.2%), tests_pri_-900: 1.30
	(0.2%), tests_pri_-400: 29 (4.1%), check_bayes: 27 (3.9%), b_tokenize: 11
	(1.6%), b_tok_get_all: 8 (1.1%), b_comp_prob: 2.6 (0.4%), b_tok_touch_all:
	3.3 (0.5%), b_finish: 0.77 (0.1%), tests_pri_0: 636 (90.6%), tests_pri_500:
	4.0 (0.6%), rewrite_mail: 0.00 (0.0%)
Subject: [CFT][PATCH 2/7] userns: Don't allow setgroups until a gid mapping has been setablished
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


setgroups is unique in not needing a valid mapping before it can be called,
in the case of setgroups(0, NULL) which drops all supplemental groups.

The design of the user namespace assumes that CAP_SETGID can not actually
be used until a gid mapping is established.  Therefore add a helper function
to see if the user namespace gid mapping has been established and call
that function in the setgroups permission check.

This is part of the fix for CVE-2014-8989, being able to drop groups
without privilege using user namespaces.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/user_namespace.h | 9 +++++++++
 kernel/groups.c                | 7 ++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index e95372654f09..41cc26e5a350 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -37,6 +37,15 @@ struct user_namespace {
 
 extern struct user_namespace init_user_ns;
 
+static inline bool userns_gid_mappings_established(const struct user_namespace *ns)
+{
+	bool established;
+	smp_mb__before_atomic();
+	established = ACCESS_ONCE(ns->gid_map.nr_extents) != 0;
+	smp_mb__after_atomic();
+	return established;
+}
+
 #ifdef CONFIG_USER_NS
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
diff --git a/kernel/groups.c b/kernel/groups.c
index 02d8a251c476..e0335e44f76a 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 
 /* init to 2 - one for init_task, one to ensure it is never freed */
@@ -217,7 +218,11 @@ bool may_setgroups(void)
 {
 	struct user_namespace *user_ns = current_user_ns();
 
-	return ns_capable(user_ns, CAP_SETGID);
+	/* It is not safe to use setgroups until a gid mapping in
+	 * the user namespace has been established.
+	 */
+	return userns_gid_mappings_established(user_ns) &&
+		ns_capable(user_ns, CAP_SETGID);
 }
 
 /*
-- 
1.9.1

