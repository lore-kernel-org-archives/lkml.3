Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab3CAIx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:53:57 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62238 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3CAIx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:53:56 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <87fw0f5xfw.fsf@xmission.com>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
 <20130228142440.GA6328@cachalot> <CAKgNAkjXAfq4RwtX1ELier+GLv0D5e9spM3Os3-oqSCXGqRqOg@mail.gmail.com>
 <87fw0f5xfw.fsf@xmission.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 1 Mar 2013 09:53:35 +0100
Message-ID: <CAKgNAkhuzSjkak__1FdQ9jUv0VcovoxLLXA=Lq1GBdcQ-aYbTw@mail.gmail.com>
Subject: Re: For review: pid_namespaces(7) man page
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vasily Kulikov <segoon@openwall.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 9:36 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>
>> [CC += Lennart]
>>
>> On Thu, Feb 28, 2013 at 3:24 PM, Vasily Kulikov <segoon@openwall.com> wrote:
>>> Hi Michael,
>>>
>>> On Thu, Feb 28, 2013 at 12:24 +0100, Michael Kerrisk (man-pages) wrote:
>>>>    The namespace init process
>>>>        The first process created in a new namespace (i.e., the process
>>>>        created using clone(2) with the CLONE_NEWPID flag, or the first
>>>>        child created by a process after a call to unshare(2) using the
>>>>        CLONE_NEWPID flag) has the PID 1, and is the "init" process for
>>>>        the namespace (see init(1)).  Children that are orphaned within
>>>>        the namespace will be reparented to this  process  rather  than
>>>>        init(1).
>>>
>>> Probably it worth noting here that this is true unless
>>> prctl() with PR_SET_CHILD_SUBREAPER option is called.
>>
>> Thanks Vasily. It probably is worth mentioning that, and I will add some words.
>>
>> One thing I am not sure of (have not tested), but maybe you (or Eric)
>> know the answer: does the effect of PR_SET_CHILD_SUBREAPER  cross a
>> PID namespace boundary?
>
> No.

Thanks for the clarification, Eric. I'll note that point in the page.

Cheers,

Michael


>> In other words, if it was a process in the
>> parent PID namespace that employed PR_SET_CHILD_SUBREAPER , will that
>> affect child processes in a child PID namespace, or  wiill
>> PR_SET_CHILD_SUBREAPER  only apply to child processes in the same PID
>> namespace as the caller?
>
> With respect to reparenting it acts like an additional pid namespace
> init is on the path.
>
> If you want to read the code it is in kernel/exit.c:find_new_reaper().
> called from forget_original_parent, which does the actual reparenting.
>
> Eric
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
