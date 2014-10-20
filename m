Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaJTE4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 00:56:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37611 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaJTE4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 00:56:07 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrUC=yW72d2hDzjESmZAt85x1WcGz4L-DrtY5YXAQxbpMA@mail.gmail.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com> <1413235430-22944-8-git-send-email-adityakali@google.com> <20141016211236.GA4308@mail.hallyn.com> <CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com> <20141016214710.GA4759@mail.hallyn.com> <87iojgmy3o.fsf@x220.int.ebiederm.org> <CALCETrUC=yW72d2hDzjESmZAt85x1WcGz4L-DrtY5YXAQxbpMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
From: "Eric W.Biederman" <ebiederm@xmission.com>
Date: Sun, 19 Oct 2014 23:55:50 -0500
To: Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@amacapital.net>
CC: "Serge E. Hallyn" <serge@hallyn.com>, Aditya Kali <adityakali@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        Aditya Kali <adityakali@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Message-ID: <44072106-c0f3-46b8-b2b5-9b1cbd1b7d88@email.android.com>
X-XM-AID: U2FsdGVkX1+MDcWUr9Ooa5BCbpfs+laA12gPy6uj0gQ=
X-SA-Exim-Connect-IP: 68.113.178.29
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.3 TooManyTo_001 Multiple "To" Header Recipients 2x (uncommon)
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>,Andy Lutomirski
	<luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1318 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 5 (0.4%), parse: 1.62 (0.1%), extract_message_metadata:
	18 (1.4%), get_uri_detail_list: 6 (0.5%), tests_pri_-1000: 10 (0.8%),
	tests_pri_-950: 2 (0.2%), tests_pri_-900: 1.69 (0.1%), tests_pri_-400: 49
	(3.7%), check_bayes: 47 (3.5%), tests_pri_0: 1218 (92.5%), tests_pri_500: 7
	(0.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On October 19, 2014 1:26:29 PM CDT, Andy Lutomirski <luto@amacapital.net> wrote:
>On Sat, Oct 18, 2014 at 10:23 PM, Eric W. Biederman
><ebiederm@xmission.com> wrote:
>> "Serge E. Hallyn" <serge@hallyn.com> writes:
>>
>>> Quoting Aditya Kali (adityakali@google.com):
>>>> On Thu, Oct 16, 2014 at 2:12 PM, Serge E. Hallyn <serge@hallyn.com>
>wrote:
>>>> > Quoting Aditya Kali (adityakali@google.com):
>>>> >> setns on a cgroup namespace is allowed only if
>>>> >> * task has CAP_SYS_ADMIN in its current user-namespace and
>>>> >>   over the user-namespace associated with target cgroupns.
>>>> >> * task's current cgroup is descendent of the target
>cgroupns-root
>>>> >>   cgroup.
>>>> >
>>>> > What is the point of this?
>>>> >
>>>> > If I'm a user logged into
>>>> > /lxc/c1/user.slice/user-1000.slice/session-c12.scope and I start
>>>> > a container which is in
>>>> > /lxc/c1/user.slice/user-1000.slice/session-c12.scope/x1
>>>> > then I will want to be able to enter the container's cgroup.
>>>> > The container's cgroup root is under my own (satisfying the
>>>> > below condition0 but my cgroup is not a descendent of the
>>>> > container's cgroup.
>>>> >
>>>> This condition is there because we don't want to do implicit cgroup
>>>> changes when a process attaches to another cgroupns. cgroupns tries
>to
>>>> preserve the invariant that at any point, your current cgroup is
>>>> always under the cgroupns-root of your cgroup namespace. But in
>your
>>>> example, if we allow a process in "session-c12.scope" container to
>>>> attach to cgroupns root'ed at "session-c12.scope/x1" container
>>>> (without implicitly moving its cgroup), then this invariant won't
>>>> hold.
>>>
>>> Oh, I see.  Guess that should be workable.  Thanks.
>>
>> Which has me looking at what the rules are for moving through
>> the cgroup hierarchy.
>>
>> As long as we have write access to cgroup.procs and are allowed
>> to open the file for write, we can move any of our own tasks
>> into the cgroup.  So the cgroup namespace rules don't seem
>> to be a problem.
>>
>> Andy can you please take a look at the permission checks in
>> __cgroup_procs_write.
>
>The actual requirements for calling that function haven't changed,
>right?  IOW, what does this have to do with cgroupns?

Excluding user namespaces the requirements have not changed.  

The immediate correlation is that to enter a cgroupns you must first put your process in one of it's cgroups.

So I was examining what it would take to enter the cgroup of cgroupns.

> Is the idea
>that you want a privileged user wrt a cgroupns's userns to be able to
>use this?  If so:
>
>Yes, that current_cred() thing is bogus.  (Actually, this is probably
>exploitable right now if any cgroup.procs inode anywhere on the system
>lets non-root write.)  (Can we have some kernel debugging option that
>makes any use of current_cred() in write(2) warn?)
>
>We really need a weaker version of may_ptrace for this kind of stuff.
>Maybe the existing may_ptrace stuff is okay, actually.  But this is
>completely missing group checks, cap checks, capabilities wrt the
>userns, etc.
>
>Also, I think that, if this version of the patchset allows non-init
>userns to unshare cgroupns, then the issue of what permission is
>needed to lock the cgroup hierarchy like that needs to be addressed,
>because unshare(CLONE_NEWUSER|CLONE_NEWCGROUP) will effectively pin
>the calling task with no permission required.  Bolting on a fix later
>will be a mess.

I imagine the pinning would be like the userns.

Ah but there is a potentially serious issue with the pinning.
With pinning we can make it impossible for root to move us to a different cgroup. 

I am not certain how serious that is but it bears thinking about.
If we don't implement pinning we should be able to implent everything with just filesystem mount options, and no new namespace required.

Sigh.

I am too tired tonight to see the end game in this.

Eric
>> As I read the code I see 3 security gaffaws in the permssion check.
>> - Using current->cred instead of file->f_cred.
>> - Not checking tcred->euid.
>> - Checking GLOBAL_ROOT_UID instead of having a capable call.
>>
>> The file permission on cgroup.procs seem just sufficient to keep
>> to keep those bugs from being easily exploitable.
>>
>> Eric

