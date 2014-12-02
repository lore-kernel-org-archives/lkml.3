Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbaLBUcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:32:22 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40805 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671AbaLBUcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:32:19 -0500
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
Date: Tue, 02 Dec 2014 14:30:07 -0600
In-Reply-To: <874mtdyexp.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Tue, 02 Dec 2014 14:28:18 -0600")
Message-ID: <87r3whx0a8.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18GyTBO4r0a+MZy993dY5nFjVTlkF7cnBE=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.2 T_XMDrugObfuBody_14 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 248 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 2.8 (1.1%), b_tie_ro: 1.86 (0.8%), parse: 0.68 (0.3%),
	extract_message_metadata: 11 (4.3%), get_uri_detail_list: 1.08 (0.4%),
	tests_pri_-1000: 6 (2.3%), tests_pri_-950: 1.18 (0.5%), tests_pri_-900: 1.05
	(0.4%), tests_pri_-400: 22 (8.7%), check_bayes: 21 (8.3%), b_tokenize: 8
	(3.1%), b_tok_get_all: 7 (2.8%), b_comp_prob: 1.53 (0.6%), b_tok_touch_all:
	2.5 (1.0%), b_finish: 0.68 (0.3%), tests_pri_0: 198 (79.8%), tests_pri_500:
	3.7 (1.5%), rewrite_mail: 0.00 (0.0%)
Subject: [CFT][PATCH 3/3] userns: Unbreak the unprivileged remount tests
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A security fix in caused the way the unprivileged remount tests were
using user namespaces to break.  Tweak the way user namespaces are
being used so the test works again.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

This is what it takes to fix a broken application, in it's full glory.
This fix works even if new functionality does not exist.

 tools/testing/selftests/mount/unprivileged-remount-test.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mount/unprivileged-remount-test.c b/tools/testing/selftests/mount/unprivileged-remount-test.c
index 9669d375625a..d47227494137 100644
--- a/tools/testing/selftests/mount/unprivileged-remount-test.c
+++ b/tools/testing/selftests/mount/unprivileged-remount-test.c
@@ -144,13 +144,12 @@ static void create_and_enter_userns(void)
 			strerror(errno));
 	}
 
+	if (access("/proc/self/setgroups", F_OK) == 0) {
+		write_file("/proc/self/setgroups", "0");
+	}
 	write_file("/proc/self/uid_map", "0 %d 1", uid);
 	write_file("/proc/self/gid_map", "0 %d 1", gid);
 
-	if (setgroups(0, NULL) != 0) {
-		die("setgroups failed: %s\n",
-			strerror(errno));
-	}
 	if (setgid(0) != 0) {
 		die ("setgid(0) failed %s\n",
 			strerror(errno));
-- 
1.9.1

