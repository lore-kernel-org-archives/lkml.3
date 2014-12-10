Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbaLJXWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:22:17 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41939 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073AbaLJXWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:22:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Weinberger <richard@nod.at>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-man <linux-man@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, stable <stable@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kenton Varda <kenton@sandstorm.io>,
        LSM <linux-security-module@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
	<87h9x5re41.fsf_-_@x220.int.ebiederm.org>
	<87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
	<CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
	<87ppbtn4mv.fsf@x220.int.ebiederm.org>
	<CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
	<87a92xn2io.fsf@x220.int.ebiederm.org>
	<87r3w8liw4.fsf@x220.int.ebiederm.org>
	<87iohklfvj.fsf_-_@x220.int.ebiederm.org>
	<87mw6vh31e.fsf_-_@x220.int.ebiederm.org>
	<20141210224822.GG20012@ubuntumail> <5488CE4D.1000606@nod.at>
Date: Wed, 10 Dec 2014 17:19:55 -0600
In-Reply-To: <5488CE4D.1000606@nod.at> (Richard Weinberger's message of "Wed,
	10 Dec 2014 23:50:53 +0100")
Message-ID: <87r3w7f5yc.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18EpkNzOfDMawacCsJ+iH6WK80kTa/91Ik=
X-SA-Exim-Connect-IP: 67.3.210.55
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Richard Weinberger <richard@nod.at>
X-Spam-Relay-Country: 
X-Spam-Timing: total 265 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 2.3 (0.9%), b_tie_ro: 1.62 (0.6%), parse: 0.58 (0.2%),
	extract_message_metadata: 12 (4.4%), get_uri_detail_list: 0.87 (0.3%),
	tests_pri_-1000: 7 (2.6%), tests_pri_-950: 0.98 (0.4%), tests_pri_-900: 0.86
	(0.3%), tests_pri_-400: 20 (7.7%), check_bayes: 19 (7.3%), b_tokenize: 5.0
	(1.9%), b_tok_get_all: 7 (2.6%), b_comp_prob: 1.71 (0.6%), b_tok_touch_all:
	2.4 (0.9%), b_finish: 0.63 (0.2%), tests_pri_0: 214 (80.8%), tests_pri_500: 5
	(2.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [CFT] Can I get some Tested-By's on this series?
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:

> Am 10.12.2014 um 23:48 schrieb Serge Hallyn:
>> Quoting Eric W. Biederman (ebiederm@xmission.com):
>>>
>>> Will people please test these patches with their container project?
>>>
>>> These changes break container userspace (hopefully in a minimal way) if
>>> I could have that confirmed by testing I would really appreciate it.  I
>>> really don't want to send out a bug fix that accidentally breaks
>>> userspace again.
>>>
>>> The only issue sort of under discussion is if there is a better name for
>>> /proc/<pid>/setgroups, and the name of the file will not affect the
>>> functionality of the patchset.
>>>
>>> With the code reviewed and written in simple obviously correct, easily
>>> reviewable ways I am hoping/planning to send this to Linus ASAP.
>>>
>>> Eric
>> 
>> Is there a git tree we can clone?
>
> I was about to ask that too.
> Hopefully I can tomorrow find some time for testing.

git pull git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing

That holds my entire queue of fixes against 3.18-rc6

Eric
