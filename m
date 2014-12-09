Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075AbaLIUoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:44:20 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33875 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaLIUoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:44:14 -0500
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
	<87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
	<CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
	<87ppbtn4mv.fsf@x220.int.ebiederm.org>
	<CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
	<87a92xn2io.fsf@x220.int.ebiederm.org>
	<87r3w8liw4.fsf@x220.int.ebiederm.org>
	<87iohklfvj.fsf_-_@x220.int.ebiederm.org>
Date: Tue, 09 Dec 2014 14:41:57 -0600
In-Reply-To: <87iohklfvj.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Tue, 09 Dec 2014 14:36:48 -0600")
Message-ID: <87mw6wk12i.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18NAYZFm4ofRN7zxjFNt2AOVMvYTBnx5Po=
X-SA-Exim-Connect-IP: 67.3.210.55
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 222 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 2.8 (1.3%), b_tie_ro: 2.1 (0.9%), parse: 0.69 (0.3%),
	extract_message_metadata: 10 (4.6%), get_uri_detail_list: 1.20 (0.5%),
	tests_pri_-1000: 5 (2.3%), tests_pri_-950: 0.98 (0.4%), tests_pri_-900: 0.83
	(0.4%), tests_pri_-400: 19 (8.7%), check_bayes: 18 (8.3%), b_tokenize: 6
	(2.7%), b_tok_get_all: 7 (3.2%), b_comp_prob: 1.42 (0.6%), b_tok_touch_all:
	2.4 (1.1%), b_finish: 0.60 (0.3%), tests_pri_0: 177 (79.4%), tests_pri_500:
	3.5 (1.6%), rewrite_mail: 0.00 (0.0%)
Subject: [CFT][PATCH 6/8] userns: Rename id_map_mutex to userns_state_mutex
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Generalize id_map_mutex so it can be used for more state of a user namespace.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/user_namespace.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 1e34de2fbd60..44a555ac6104 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -24,6 +24,7 @@
 #include <linux/fs_struct.h>
 
 static struct kmem_cache *user_ns_cachep __read_mostly;
+static DEFINE_MUTEX(userns_state_mutex);
 
 static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
@@ -583,9 +584,6 @@ static bool mappings_overlap(struct uid_gid_map *new_map,
 	return false;
 }
 
-
-static DEFINE_MUTEX(id_map_mutex);
-
 static ssize_t map_write(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos,
 			 int cap_setid,
@@ -602,7 +600,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	ssize_t ret = -EINVAL;
 
 	/*
-	 * The id_map_mutex serializes all writes to any given map.
+	 * The userns_state_mutex serializes all writes to any given map.
 	 *
 	 * Any map is only ever written once.
 	 *
@@ -620,7 +618,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	 * order and smp_rmb() is guaranteed that we don't have crazy
 	 * architectures returning stale data.
 	 */
-	mutex_lock(&id_map_mutex);
+	mutex_lock(&userns_state_mutex);
 
 	ret = -EPERM;
 	/* Only allow one successful write to the map */
@@ -750,7 +748,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	*ppos = count;
 	ret = count;
 out:
-	mutex_unlock(&id_map_mutex);
+	mutex_unlock(&userns_state_mutex);
 	if (page)
 		free_page(page);
 	return ret;
@@ -845,12 +843,12 @@ bool userns_may_setgroups(const struct user_namespace *ns)
 {
 	bool allowed;
 
-	mutex_lock(&id_map_mutex);
+	mutex_lock(&userns_state_mutex);
 	/* It is not safe to use setgroups until a gid mapping in
 	 * the user namespace has been established.
 	 */
 	allowed = ns->gid_map.nr_extents != 0;
-	mutex_unlock(&id_map_mutex);
+	mutex_unlock(&userns_state_mutex);
 
 	return allowed;
 }
-- 
1.9.1

