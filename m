Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbaK1FWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 00:22:25 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:40876 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaK1FWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 00:22:22 -0500
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
        Richard Weinberger <richard@nod.at>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
	<0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
	<546A3942.5040906@schaufler-ca.com>
	<CALCETrWy-3C1on3+2wE9aqcChBUCUY0i_4AL_Om8CSZ5QB18sQ@mail.gmail.com>
	<CALCETrVn4gVXp7F=5h-bkN5VWuRMG9BoxgeQfKhX4+ZXxGE=wQ@mail.gmail.com>
	<546A43CE.2030706@schaufler-ca.com>
	<87lhmwwpey.fsf_-_@x220.int.ebiederm.org>
	<CALCETrUuWDq2akKfb50AiPHeDDWzPW7ijz1QwnuNiskyZbBEfA@mail.gmail.com>
Date: Thu, 27 Nov 2014 23:21:03 -0600
In-Reply-To: <CALCETrUuWDq2akKfb50AiPHeDDWzPW7ijz1QwnuNiskyZbBEfA@mail.gmail.com>
	(Andy Lutomirski's message of "Thu, 27 Nov 2014 12:52:16 -0800")
Message-ID: <87wq6frjcw.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+fi1Ypozp8Brw7ovlh6KkrLZtDnr/oFmc=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 335 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 3.1 (0.9%), b_tie_ro: 2.2 (0.7%), parse: 0.72 (0.2%),
	extract_message_metadata: 13 (3.8%), get_uri_detail_list: 2.2 (0.7%),
	tests_pri_-1000: 5 (1.6%), tests_pri_-950: 1.18 (0.4%), tests_pri_-900: 0.98
	(0.3%), tests_pri_-400: 23 (6.8%), check_bayes: 22 (6.5%), b_tokenize: 7
	(2.0%), b_tok_get_all: 8 (2.5%), b_comp_prob: 2.3 (0.7%), b_tok_touch_all:
	2.2 (0.7%), b_finish: 0.73 (0.2%), tests_pri_0: 279 (83.2%), tests_pri_500: 6
	(1.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [CFT][PATCH] userns: Avoid problems with negative groups
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

>> This change should break userspace by the minimal amount needed
>> to fix this issue.
>>
>> This should fix CVE-2014-8989.
>
> I think this is both unnecessarily restrictive and that it doesn't fix
> the bug.  

You are going to have to work very hard to convince me this is
unnecessarily restrictive.  

>For example, I can exploit CVE-2014-8989 without ever
> writing a uid map or a gid map.

Yes.  I realized just after I sent the patch that setgroups(0, NULL)
would still work without a mapping set.  That is a first glass grade a
oversight that resulted in a bug.  None of the other uid or gid changing
syscalls without a mapping set, and setgroups was just overlooked
because it was different.  Oops.

I will send an updated patch that stops setgroups from working without
a mapping set shortly.

> IIUC, the only real issue is that user namespaces allow groups to be
> dropped using setgroups that wouldn't otherwise be dropped.  Can we
> get away with adding a per-user-ns flag that determines whether
> setgroups can be used?

Being able to call setgroups is fundamental to login programs, and login
programs are one of the things user namespaces need to support.  So
adding an extra flag and an extra place where privilege is required
is just noise, and will wind up breaking every user of user namespaces.

Further being able to setup uid and gid mappings without privilege is
primarily a nice to have.  The original design did not have unprivileged
setting of uid and gid maps and if it proves insecure I goofed and the
feature isn't safe so it needs to be removed.

This does mean that running a system with negative groups and users
delegated subordinate gids in /etc/subuid is a bad idea and system
administrators shouldn't do that as those negative groups won't prove
effective in stopping their users.  But this is all under system
administrator control so shrug.  There isn't a way to avoid that
fundamental conflict.

> setgroups would be unusable until the gid_map has been written and
> then it would become usable if and only if the parent userns could use
> setgroups and the opener of gid_map was privileged.

That proposal sounds a lot more restrictive and a lot more of a pain
to use than what I have implemented in my patch.

> If we wanted to allow finer-grained control, we could allow writing
> control lines like:
>
> options +setgroups
>
> or
>
> options -setgroups
>
> in gid_map, or we could add user_ns_flags that can only be written
> once and only before either uid_map or gid_map is written.

Definitely more complicated and I can't imagine a case where I need
a gid map without needing to call setgroups.

Eric
