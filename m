Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaE0FwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 01:52:08 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:42131 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaE0FwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 01:52:04 -0400
Message-ID: <538427F9.7090501@gmail.com>
Date: Tue, 27 May 2014 07:51:53 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: mtk.manpages@gmail.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documenting execve() and EAGAIN
References: <537CEC90.7060000@gmail.com> <20140526181120.GB11145@cachalot>
In-Reply-To: <20140526181120.GB11145@cachalot>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vasiliy,

On 05/26/2014 08:11 PM, Vasiliy Kulikov wrote:
> Hi Michael,
> 
> On Wed, May 21, 2014 at 20:12 +0200, Michael Kerrisk (man-pages) wrote:
>> Vasily (and Motohiro),
>>
>> Sometime ago, Motohiro raised a documentation bug
>> ( https://bugzilla.kernel.org/show_bug.cgi?id=42704 ) which 
>> relates to your commit 72fa59970f8698023045ab0713d66f3f4f96945c
>> ("move RLIMIT_NPROC check from set_user() to do_execve_common()")
>>
>> I have attempted to document this, and I would like to ask you
>> (and Motohiro) if you would review the text proposed below for
>> the exceve(2) man page.
>>
>> Thank you,
>>
>> Michael
>>
>>
>> ERRORS
>>        EAGAIN (since Linux 3.1)
>>               Having  changed its real UID using one of the set*uid()
>>               calls,  the  caller  was—and  is  now  still—above  its
>>               RLIMIT_NPROC  resource limit (see setrlimit(2)).  For a
>>               more detailed explanation of this error, see NOTES.
>>
>> NOTES
>>    execve() and EAGAIN
>>        A more detailed explanation of the EAGAIN error that can occur
>>        (since Linux 3.1) when calling execve() is as follows.
>>
>>        The EAGAIN error can occur when a preceding call to setuid(2),
>>        setreuid(2), or setresuid(2) caused the real user  ID  of  the
>>        process  to  change,  and  that  change  caused the process to
>>        exceed its RLIMIT_NPROC resource limit (i.e.,  the  number  of
>>        processes  belonging  to the new real UID exceeds the resource
>>        limit).  In Linux 3.0 and earlier, this caused  the  set*uid()
>>        call to fail.
>>
>>        Since  Linux 3.1, the scenario just described no longer causes
>>        the set*uid() call to fail, because it too often led to  secu‐
>>        rity  holes because buggy applications didn't check the return
>>        status and assumed that—if the caller had root  privileges—the
>>        call  would  always succeed.  Instead, the set*uid() calls now
>>        successfully change real UID, but the kernel sets an  internal
>>        flag,  named  PF_NPROC_EXCEEDED, to note that the RLIMIT_NPROC
>>        resource limit has been exceeded.  If the  resource  limit  is
>>        still exceeded at the time of a subsequent execve() call, that
>>        call fails with the error EAGAIN.  This kernel  logic  ensures
>>        that the RLIMIT_NPROC resource limit is still enforced for the
>>        common privileged daemon workflow—namely, fork(2)+  set*uid()+
>>        execve(2).
>>
>>        If  the  resource  limit was not still exceeded at the time of
>>        the execve() call (because other processes belonging  to  this
>>        real  UID  terminated  between  the  set*uid()  call  and  the
>>        execve() call), then the execve() call succeeds and the kernel
>>        clears  the  PF_NPROC_EXCEEDED process flag.  The flag is also
>>        cleared if a subsequent call to fork(2) by this  process  suc‐
>>        ceeds.
> 
> Probably explicitly state that NPROC check on execve() is processed only
> in case of a previous set*uid() call?  If there was no previous
> set*uid() call the semantics of execve() checks are the same as before
> (IOW, RLIMIT_NPROC is ignored).

Yes, good idea. I'll add some words to make that clearer.

> The rest is fine.

Thanks for checking it!

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
