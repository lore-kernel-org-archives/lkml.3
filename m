Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab3CAIgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:36:13 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33181 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3CAIgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:36:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: mtk.manpages@gmail.com
Cc: Vasily Kulikov <segoon@openwall.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
	<20130228142440.GA6328@cachalot>
	<CAKgNAkjXAfq4RwtX1ELier+GLv0D5e9spM3Os3-oqSCXGqRqOg@mail.gmail.com>
Date: Fri, 01 Mar 2013 00:36:03 -0800
In-Reply-To: <CAKgNAkjXAfq4RwtX1ELier+GLv0D5e9spM3Os3-oqSCXGqRqOg@mail.gmail.com>
	(Michael Kerrisk's message of "Fri, 1 Mar 2013 09:03:18 +0100")
Message-ID: <87fw0f5xfw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+pmCh1f1uon3Eo40i9RZs8qvUv9Ouc0VY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0161]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;mtk.manpages@gmail.com
X-Spam-Relay-Country: 
Subject: Re: For review: pid_namespaces(7) man page
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> [CC += Lennart]
>
> On Thu, Feb 28, 2013 at 3:24 PM, Vasily Kulikov <segoon@openwall.com> wrote:
>> Hi Michael,
>>
>> On Thu, Feb 28, 2013 at 12:24 +0100, Michael Kerrisk (man-pages) wrote:
>>>    The namespace init process
>>>        The first process created in a new namespace (i.e., the process
>>>        created using clone(2) with the CLONE_NEWPID flag, or the first
>>>        child created by a process after a call to unshare(2) using the
>>>        CLONE_NEWPID flag) has the PID 1, and is the "init" process for
>>>        the namespace (see init(1)).  Children that are orphaned within
>>>        the namespace will be reparented to this  process  rather  than
>>>        init(1).
>>
>> Probably it worth noting here that this is true unless
>> prctl() with PR_SET_CHILD_SUBREAPER option is called.
>
> Thanks Vasily. It probably is worth mentioning that, and I will add some words.
>
> One thing I am not sure of (have not tested), but maybe you (or Eric)
> know the answer: does the effect of PR_SET_CHILD_SUBREAPER  cross a
> PID namespace boundary?

No.

> In other words, if it was a process in the
> parent PID namespace that employed PR_SET_CHILD_SUBREAPER , will that
> affect child processes in a child PID namespace, or  wiill
> PR_SET_CHILD_SUBREAPER  only apply to child processes in the same PID
> namespace as the caller?

With respect to reparenting it acts like an additional pid namespace
init is on the path.

If you want to read the code it is in kernel/exit.c:find_new_reaper().
called from forget_original_parent, which does the actual reparenting.

Eric

