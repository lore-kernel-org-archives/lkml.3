Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaLHWI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:08:28 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:50203 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaLHWIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:08:23 -0500
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
Date: Mon, 08 Dec 2014 16:06:06 -0600
In-Reply-To: <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 2 Dec 2014 15:17:32 -0800")
Message-ID: <87h9x5re41.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX195ax/aafq3v1wFbH2n2VaqzHq2vHJ4/vE=
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
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 762 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.1 (0.4%), b_tie_ro: 2.2 (0.3%), parse: 1.15 (0.2%),
	extract_message_metadata: 17 (2.3%), get_uri_detail_list: 2.1 (0.3%),
	tests_pri_-1000: 7 (0.9%), tests_pri_-950: 1.32 (0.2%), tests_pri_-900: 1.13
	(0.1%), tests_pri_-400: 29 (3.8%), check_bayes: 27 (3.6%), b_tokenize: 12
	(1.5%), b_tok_get_all: 8 (1.1%), b_comp_prob: 3.2 (0.4%), b_tok_touch_all:
	2.1 (0.3%), b_finish: 0.78 (0.1%), tests_pri_0: 693 (91.0%), tests_pri_500:
	4.5 (0.6%), rewrite_mail: 0.00 (0.0%)
Subject: [CFT][PATCH 1/7] userns: Document what the invariant required for safe unprivileged mappings.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The rule is simple.  Don't allow anything that wouldn't be allowed
without unprivileged mappings.

It was previously overlooked that establishing gid mappings would
allow dropping groups and potentially gaining permission to files and
directories that had lesser permissions for a specific group than for
all other users.

This is the rule needed to fix CVE-2014-8989 and prevent any other
security issues with new_idmap_permitted.

The reason for this rule is that the unix permission model is old and
there are programs out there somewhere that take advantage of every
little corner of it.  So allowing a uid or gid mapping to be
established without privielge that would allow anything that would not
be allowed without that mapping will result in expectations from some
code somewhere being violated.  Violated expectations about the
behavior of the OS is a long way to say a security issue.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/user_namespace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index aa312b0dc3ec..b99c862a2e3f 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -812,7 +812,9 @@ static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
-	/* Allow mapping to your own filesystem ids */
+	/* Don't allow mappings that would allow anything that wouldn't
+	 * be allowed without the establishment of unprivileged mappings.
+	 */
 	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1)) {
 		u32 id = new_map->extent[0].lower_first;
 		if (cap_setid == CAP_SETUID) {
-- 
1.9.1

