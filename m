Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaK1Qfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:35:54 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59384 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaK1Qfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:35:52 -0500
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
	<87wq6frjcw.fsf@x220.int.ebiederm.org>
	<CALCETrX2s-7iaLMEKLQsExTEp3JyoAPQG44p0v5wkeED3-6dQA@mail.gmail.com>
Date: Fri, 28 Nov 2014 10:34:30 -0600
In-Reply-To: <CALCETrX2s-7iaLMEKLQsExTEp3JyoAPQG44p0v5wkeED3-6dQA@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 28 Nov 2014 07:11:51 -0800")
Message-ID: <874mtjp9m1.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19bYvJWUkT95gYiuRJ4BUqkUQd0wUqe1us=
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
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 934 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 2.9 (0.3%), b_tie_ro: 2.0 (0.2%), parse: 0.71 (0.1%),
	extract_message_metadata: 14 (1.5%), get_uri_detail_list: 3.2 (0.3%),
	tests_pri_-1000: 7 (0.7%), tests_pri_-950: 1.03 (0.1%), tests_pri_-900: 0.90
	(0.1%), tests_pri_-400: 38 (4.1%), check_bayes: 37 (4.0%), b_tokenize: 9
	(1.0%), b_tok_get_all: 16 (1.7%), b_comp_prob: 2.9 (0.3%), b_tok_touch_all: 5
	(0.6%), b_finish: 2.0 (0.2%), tests_pri_0: 862 (92.3%), tests_pri_500: 5
	(0.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [CFT][PATCH] userns: Avoid problems with negative groups
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Thu, Nov 27, 2014 at 9:21 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>>> This change should break userspace by the minimal amount needed
>>>> to fix this issue.
>>>>
>>>> This should fix CVE-2014-8989.
>>>
>>> I think this is both unnecessarily restrictive and that it doesn't fix
>>> the bug.
>>
>> You are going to have to work very hard to convince me this is
>> unnecessarily restrictive.
>>
>>>For example, I can exploit CVE-2014-8989 without ever
>>> writing a uid map or a gid map.
>>
>> Yes.  I realized just after I sent the patch that setgroups(0, NULL)
>> would still work without a mapping set.  That is a first glass grade a
>> oversight that resulted in a bug.  None of the other uid or gid changing
>> syscalls without a mapping set, and setgroups was just overlooked
>> because it was different.  Oops.
>>
>> I will send an updated patch that stops setgroups from working without
>> a mapping set shortly.
>>
>>> IIUC, the only real issue is that user namespaces allow groups to be
>>> dropped using setgroups that wouldn't otherwise be dropped.  Can we
>>> get away with adding a per-user-ns flag that determines whether
>>> setgroups can be used?
>>
>> Being able to call setgroups is fundamental to login programs, and login
>> programs are one of the things user namespaces need to support.  So
>> adding an extra flag and an extra place where privilege is required
>> is just noise, and will wind up breaking every user of user namespaces.
>>
>> Further being able to setup uid and gid mappings without privilege is
>> primarily a nice to have.  The original design did not have unprivileged
>> setting of uid and gid maps and if it proves insecure I goofed and the
>> feature isn't safe so it needs to be removed.
>
> Being able to set a single-user uid map and gid map is very useful for
> sandboxing.  This lets unprivileged users drop filesystem and network
> access and still run most normal programs.  A surprising number of
> normal unprivileged programs fail if run without a mapping.

You can still set a single uid map unprivileged.  That should be enough
to keep your capabilities inside the namespace as long as you need them.

I am sad that in practice you can't set a single gid map, as everyone
calls setgroups.

Although I sort of think it might be worth scouring userspace for
something that will call setgroups and drop all of your groups.  If we
can find something preexisting that will solve this entire mess in a
much more elegant way.

>> This does mean that running a system with negative groups and users
>> delegated subordinate gids in /etc/subuid is a bad idea and system
>> administrators shouldn't do that as those negative groups won't prove
>> effective in stopping their users.  But this is all under system
>> administrator control so shrug.  There isn't a way to avoid that
>> fundamental conflict.
>>
>>> setgroups would be unusable until the gid_map has been written and
>>> then it would become usable if and only if the parent userns could use
>>> setgroups and the opener of gid_map was privileged.
>>
>> That proposal sounds a lot more restrictive and a lot more of a pain
>> to use than what I have implemented in my patch.
>>
>>> If we wanted to allow finer-grained control, we could allow writing
>>> control lines like:
>>>
>>> options +setgroups
>>>
>>> or
>>>
>>> options -setgroups
>>>
>>> in gid_map, or we could add user_ns_flags that can only be written
>>> once and only before either uid_map or gid_map is written.
>>
>> Definitely more complicated and I can't imagine a case where I need
>> a gid map without needing to call setgroups.
>
> I do it all the time.  Unshare, set mappings (with no inner uid 0 at
> all), set no_new_privs, drop caps, and go.
>
> Can we try the intermediate approach?  If you set gid_map without
> privilege and you have supplementary groups, then let the write to
> gid_map succeed but prevent setgroups from ever working?  That should
> only be a couple of lines of code longer than your patch, and it will
> avoid breaking sandbox use cases.

I am torn.  Send me an incremental patch and I will be happy to evaluate
it and if all is good fold the change in.  I hate breaking userspace but
if I break it I would rather it be a clean break that is easy to spot
and work around rather than something that almost works, and causes
people a lot of difficulty debugging.

My expectation is that systems that are serious will have /etc/subuid
and /etc/subgid and newuidmap and newgidmap setup.  Which is the other
way to allow you to map your own gid.

> If we want to get really fancy in the future, we could have a concept
> of pinned groups.  That is, if you're in a userns and you're a member
> of an unmapped group, then you can't drop that group.  (Actually, that
> all by itself might be enough to fix this issue.)

Not allowing you to drop groups really isn't enough.  One of the first
things applications like ssh do is call setgroups(0, NULL) to drop the
privileges granted by supplementary groups.  Further login program
somewhere call setgroups(N, ....) and give you every group mapped
by /etc/group.

I don't think I want to run containers with every supplementary group I
might want to drop mapped, and more than that, it would require changing
a lot more userspace than just the userspace that just does unpriv
containers with a single uid, and a single gid mapped.

But please test and see if you really need to map your group, and send
me an incremental patch if you see a way to do better.  Breaking
userspace sucks.

Eric
