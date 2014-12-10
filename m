Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbaLJQmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:42:22 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46609 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427AbaLJQmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:42:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>
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
Date: Wed, 10 Dec 2014 10:39:57 -0600
In-Reply-To: <87iohklfvj.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Tue, 09 Dec 2014 14:36:48 -0600")
Message-ID: <87mw6vh31e.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/qI6gjvau49ngORbqUFsR4eDeiWAEv2g0=
X-SA-Exim-Connect-IP: 67.3.210.55
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.3 TooManyTo_001 Multiple "To" Header Recipients 2x (uncommon)
	*  0.5 TooManyTo_002 Multiple "To" Header Recipients 3x (uncommon)
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4897]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>, "Serge E. Hallyn"
	<serge@hallyn.com>,  Richard Weinberger <richard@nod.at>
X-Spam-Relay-Country: 
X-Spam-Timing: total 688 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 2.9 (0.4%), b_tie_ro: 2.1 (0.3%), parse: 0.80 (0.1%),
	extract_message_metadata: 1.77 (0.3%), get_uri_detail_list: 0.39 (0.1%),
	tests_pri_-1000: 3.7 (0.5%), tests_pri_-950: 1.13 (0.2%), tests_pri_-900:
	0.92 (0.1%), tests_pri_-400: 20 (2.9%), check_bayes: 19 (2.8%), b_tokenize:
	4.5 (0.6%), b_tok_get_all: 5 (0.8%), b_comp_prob: 1.42 (0.2%),
	b_tok_touch_all: 4.2 (0.6%), b_finish: 2.2 (0.3%), tests_pri_0: 645 (93.7%),
	tests_pri_500: 3.6 (0.5%), rewrite_mail: 0.00 (0.0%)
Subject: [CFT] Can I get some Tested-By's on this series?
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Will people please test these patches with their container project?

These changes break container userspace (hopefully in a minimal way) if
I could have that confirmed by testing I would really appreciate it.  I
really don't want to send out a bug fix that accidentally breaks
userspace again.

The only issue sort of under discussion is if there is a better name for
/proc/<pid>/setgroups, and the name of the file will not affect the
functionality of the patchset.

With the code reviewed and written in simple obviously correct, easily
reviewable ways I am hoping/planning to send this to Linus ASAP.

Eric
