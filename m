Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbaJ3MDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:03:41 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60092 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198AbaJ3MDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:03:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tom Gundersen <teg@jklm.no>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>,
        Daniel Mack <daniel@zonque.org>, alban.crequy@collabora.co.uk,
        javier.martinez@collabora.co.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ@mail.gmail.com>
	<20141029222729.GB8129@kroah.com>
	<CALCETrVxvF2ie=vVgpjeqikn+nci_9jyKfU4s3t=4cjyNZNaNQ@mail.gmail.com>
	<87bnourxx4.fsf@x220.int.ebiederm.org>
	<CAG-2HqUChohNrRSdXzckSiv8ZUYwFLMvRTc41Uo7-b-qmkSFMQ@mail.gmail.com>
Date: Thu, 30 Oct 2014 05:02:39 -0700
In-Reply-To: <CAG-2HqUChohNrRSdXzckSiv8ZUYwFLMvRTc41Uo7-b-qmkSFMQ@mail.gmail.com>
	(Tom Gundersen's message of "Thu, 30 Oct 2014 11:15:35 +0100")
Message-ID: <87ioj1kbog.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18qtUT+dw+Vrhji+2pjqRKfwuQ9P4svWdI=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Tom Gundersen <teg@jklm.no>
X-Spam-Relay-Country: 
X-Spam-Timing: total 677 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 8 (1.2%), b_tie_ro: 6 (0.9%), parse: 0.86 (0.1%),
	extract_message_metadata: 15 (2.2%), get_uri_detail_list: 4.0 (0.6%),
	tests_pri_-1000: 7 (1.0%), tests_pri_-950: 1.04 (0.2%), tests_pri_-900: 0.91
	(0.1%), tests_pri_-400: 35 (5.2%), check_bayes: 34 (5.0%), b_tokenize: 12
	(1.7%), b_tok_get_all: 13 (2.0%), b_comp_prob: 3.7 (0.5%), b_tok_touch_all:
	2.4 (0.4%), b_finish: 0.64 (0.1%), tests_pri_0: 600 (88.6%), tests_pri_500: 7
	(1.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 00/12] Add kdbus implementation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Gundersen <teg@jklm.no> writes:

> Hi Eric,
>
> On Thu, Oct 30, 2014 at 5:20 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> The userspace API breaks userspace in an unfixable way.
>>
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>> Problem the first.
>> - Using global names for containers makes it impossible to create
>>   unprivileged containers.
>
> I don't follow.
>
> Just so we are on the same page:
>   - creating a domain per container is only a convention, and has to
> be done manually. I.e., the worst case scenario is that you are able
> to create some container which cannot get a corresponding kdbus
> domain.

Which is the classic definition of failure to restore a checkpoint.  You
can't get the name you needed.

>   - domain names are only unique per parent-domain, and domains are
> fully recursive. We explicitly tested recursive domains by running
> kdbus-enabled containers within kdbus-enabled containers, a number of
> iterations deep.
>
> Could you explain the problem you see in more detail? This might just
> be a documenation issue, after all.

Partly there is just a ridiculous amount of complexity in having
hiearchical names when there is fundamentally no hierarchy.

The problem I see is that creating a kdbus requires someone to grant you
privilege to do it.  You have to ask permission from the system
administrator.  For unprivileged containers you don't have to ask
permission to create one, you just need the appropriate support in your
kernel.

Given the fact you smash all of the names together in a hierarchy I
can't see how you can avoid requiring privilege for part of the
hierarchy creation.

>>   This is a back to the drawing board problem, and makes device
>>   nodes fundamentally unsuited to what you are doing.
>>
>>   There is no way that I can see to make it safe for an unprivileged
>>   user to create arbitrary named busses.  Especially in the presence
>>   of allowing unprivileged checkpoint/restart.
>
> Note that unprivileged users cannot create arbitrary named busses, the
> names must have the format $PID-<arbitrary name>. Do you see a problem
> with this?

Yes.  What pid namespace is that in?

How do I restore a checkpoint?

>>   This is particularly bad as kdbus explicitly allows unprivielged
>>   creation of new kdbus instances.
>
> What do you mean by kdbus instance? A new domain? This is not allowed
> by unprivileged processes. Or do you mean a new bus, in which case see
> above.

Oh great two concepts domains and busses.  The bottom line if I can't
create both unprivileged it is a regression in the functionality of
unprivileged containers.

>>   This problem is a userspace regression.
>
> This is all new functionality, how does it affect current code?

If you simply change the existing dbus users to use kdbus you get a
regression in containers.  Furthermore you get a regression in what
kinds of userspace a container can contain.

>> Problem the second.
>> - The security checks in the code are not based on who opens the
>>   file descriptors but instead based on who is used the file
>>   descriptors at any give moment.
>>
>>   That pattern has been shown to be exploitable.
>>
>>   I expect the policy database makes this poor choice of permission
>>   checks even worse.  Pass a more privileged user a kdbus file
>>   descriptor and all of sudden things that were not possible on
>>   that file descriptor become possible.
>
> Djalal already commented on this point in another thread. But just to
> recap: Please note that we do not do read()/write() at all, only
> ioctl's, so the most common exploits do not apply. Moreover, we are
> following the same API pattern as used by other similar APIs in the
> kernel. 

A pattern that has led to an exploitable kernel, because it breaks the
principle of least surprise.

> With that in mind, could you give some more specific
> information about what kind of exploits you imagine?

I don't know if it is exploitable or simply a maintenance disaster.  But
the behavior of file descriptors changing based on who is performing
operations on it is wrong.  It breaks the common unix expectations.

It means I can not pass a file descriptor into a strongly sandboxed
application and be able to predict what can be done with the file
descriptor in the sand box.

I suspect what you really want are system calls.  As system calls are
both less overhead and easier to understand what is going on.
Especially for something as commonly used as kdbus is aiming to be
ioctls seem like code obfuscation.

The easiest problem to trigger that I can imagine is an application that
calls setresuid will have unpredicatable behavior if the change their
effective uid happens between one call and the next of your ioctl.
Which can create subtle and difficult to find bugs.

There are also all kinds of issues with respect to namespaces that if
you care about the namespace you are referring to has to be pinned at
open time.

>> Problem the third.
>> - You are using device numbers for things created by unprivileged
>>   users.  That breaks checkpoint/restart.  Aka CRIU.
>>
>>   We can not migrate a container to a new machine and preserve the
>>   device numbers.
>
> I must admit to not being too familiar with checkpoint/restart. What
> precisely is the problem with unprivileged users?

>>   We can not migrate a container to a new machine and have any hope
>>   of preserving the container patsh under /dev/kdbus/...
>
> You may not be able to preserve the full path, no, but the container
> should not know/care about the parent paths anyway.  Note that the
> containers only see their own domain subtree mounted to /dev/kdbus,
> they see nothing from the parent. Hence when you migrate containers
> you can change the naming of the parent freely, but the processes
> inside the containers won't see that, they'll have stable paths.   I'm
> not seeing the problem here, care to elaborate?

Domain creation.
Random path conflicts for no reason except we have two machines.

>> I think a kdbusfs modeled on devpts with newinstance at
>> mount time would solve the naming problems.
>
> Effectively, what we have in place in the current patch set delivers
> similar semantics, however without introducing a new file system. You
> just create a new domain and get a new subdir in /dev/kdbus/ for it,
> and then inside the container you mount that subdir of /dev/kdbus onto
> /dev/kdbus itself.
>
> Do I understand you correctly that what you want is unnamed/anonymous
> domains? Considering that domain creation is anyway privileged, why is
> this necessary?

When an unprivileged user needs a new domain?  If domains are unnamed
it is possible that their creation not require privilege.

Anything that requires stopping and asking the system administrator
for something so that I can do today with an unprivileged container
winds up being a regression, a design bug, and a showstopper.

Unless there is a massive miscommunication you have those kinds of
issues with the kbus design.


I would love to hear different but it sounds like domains are a weird
partial solution for the fact you have crammed everything into a
hierarchy for no good reason.

>> That would break one of the current kdbus use cases that allows an
>> unprivileged user to create a bus.
>
> That is a fundamental usecase, so I don't think it makes much sense to
> do anything that precludes that.

Eric

