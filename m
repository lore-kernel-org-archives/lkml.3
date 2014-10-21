Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaJUFnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 01:43:14 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60023 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaJUFnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 01:43:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Aditya Kali <adityakali@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
	<1413235430-22944-8-git-send-email-adityakali@google.com>
	<20141016211236.GA4308@mail.hallyn.com>
	<CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com>
	<20141016214710.GA4759@mail.hallyn.com>
	<87iojgmy3o.fsf@x220.int.ebiederm.org>
	<CALCETrUC=yW72d2hDzjESmZAt85x1WcGz4L-DrtY5YXAQxbpMA@mail.gmail.com>
	<44072106-c0f3-46b8-b2b5-9b1cbd1b7d88@email.android.com>
	<CALCETrXhGnBM_xx=Auz3WRQXkqhGGTWuZN=PU+A9HZ7Ek27FLA@mail.gmail.com>
	<87zjcq10ya.fsf@x220.int.ebiederm.org>
	<CALCETrVkMtsnEh57jFZrdx5vHbz97BdO7OuupT+xVNnWpJjxng@mail.gmail.com>
Date: Mon, 20 Oct 2014 22:42:26 -0700
In-Reply-To: <CALCETrVkMtsnEh57jFZrdx5vHbz97BdO7OuupT+xVNnWpJjxng@mail.gmail.com>
	(Andy Lutomirski's message of "Mon, 20 Oct 2014 22:03:46 -0700")
Message-ID: <87lhoayo59.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18yLOwyww5Lf8J0C8ny8e/x4Bu0s4J6ags=
X-SA-Exim-Connect-IP: 68.113.178.29
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4996]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 355 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 4.2 (1.2%), b_tie_ro: 3.0 (0.8%), parse: 1.38 (0.4%),
	extract_message_metadata: 16 (4.5%), get_uri_detail_list: 4.0 (1.1%),
	tests_pri_-1000: 6 (1.8%), tests_pri_-950: 0.97 (0.3%), tests_pri_-900: 0.81
	(0.2%), tests_pri_-400: 27 (7.7%), check_bayes: 26 (7.3%), b_tokenize: 7
	(2.0%), b_tok_get_all: 10 (2.8%), b_comp_prob: 3.2 (0.9%), b_tok_touch_all:
	2.6 (0.7%), b_finish: 0.85 (0.2%), tests_pri_0: 291 (82.0%), tests_pri_500:
	3.6 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Mon, Oct 20, 2014 at 9:49 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On Sun, Oct 19, 2014 at 9:55 PM, Eric W.Biederman <ebiederm@xmission.com> wrote:
>>>>
>>>>
>>>> On October 19, 2014 1:26:29 PM CDT, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>>>>> Is the idea
>>>>>that you want a privileged user wrt a cgroupns's userns to be able to
>>>>>use this?  If so:
>>>>>
>>>>>Yes, that current_cred() thing is bogus.  (Actually, this is probably
>>>>>exploitable right now if any cgroup.procs inode anywhere on the system
>>>>>lets non-root write.)  (Can we have some kernel debugging option that
>>>>>makes any use of current_cred() in write(2) warn?)
>>>>>
>>>>>We really need a weaker version of may_ptrace for this kind of stuff.
>>>>>Maybe the existing may_ptrace stuff is okay, actually.  But this is
>>>>>completely missing group checks, cap checks, capabilities wrt the
>>>>>userns, etc.
>>>>>
>>>>>Also, I think that, if this version of the patchset allows non-init
>>>>>userns to unshare cgroupns, then the issue of what permission is
>>>>>needed to lock the cgroup hierarchy like that needs to be addressed,
>>>>>because unshare(CLONE_NEWUSER|CLONE_NEWCGROUP) will effectively pin
>>>>>the calling task with no permission required.  Bolting on a fix later
>>>>>will be a mess.
>>>>
>>>> I imagine the pinning would be like the userns.
>>>>
>>>> Ah but there is a potentially serious issue with the pinning.
>>>> With pinning we can make it impossible for root to move us to a different cgroup.
>>>>
>>>> I am not certain how serious that is but it bears thinking about.
>>>> If we don't implement pinning we should be able to implent everything with just filesystem mount options, and no new namespace required.
>>>>
>>>> Sigh.
>>>>
>>>> I am too tired tonight to see the end game in this.
>>>
>>> Possible solution:
>>>
>>> Ditch the pinning.  That is, if you're outside a cgroupns (or you have
>>> a non-ns-confined cgroupfs mounted), then you can move a task in a
>>> cgroupns outside of its root cgroup.  If you do this, then the task
>>> thinks its cgroup is something like "../foo" or "../../foo".
>>
>> Of the possible solutions that seems attractive to me, simply because
>> we sometimes want to allow clever things to occur.
>>
>> Does anyone know of a reason (beyond pretty printing) why we need
>> cgroupns to restrict the subset of cgroups processes can be in?
>>
>> I would expect permissions on the cgroup directories themselves, and
>> limited visiblilty would be (in general) to achieve the desired
>> visiblity.
>
> This makes the security impact of cgroupns very easy to understand,
> right?  Because there really won't be any -- cgroupns only affects
> reads from /proc and what cgroupfs shows, but it doesn't change any
> actual cgroups, nor does it affect any cgroup *changes*.

It seems like what we have described is chcgrouproot aka chroot for
cgroups.  At which point I think there are potentially similar security
issues as for chroot.  Can we confuse a setuid root process if we make
it's cgroup names look different.

Of course the confusing root concern is handled by the usual namespace
security checks that are already present.

I do wonder if we think of this as chcgrouproot if there is a simpler
implementation.

>>> While we're at it, consider making setns for a cgroupns *not* change
>>> the caller's cgroup.  Is there any reason it really needs to?
>>
>> setns doesn't but nsenter is going to need to change the cgroup
>> if the pinning requirement is kept.  nsenenter is going to want to
>> change the cgroup if the pinning requirement is dropped.
>>
>
> It seems easy enough for nsenter to change the cgroup all by itself.

Again.  I don't think anyone has suggested or implemented anything
different.

Eric
