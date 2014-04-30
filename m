Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870AbaD3Ol2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:41:28 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:53432 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589AbaD3Ol0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:41:26 -0400
Message-ID: <53610B92.4000308@gmail.com>
Date: Wed, 30 Apr 2014 16:41:22 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@poochiereds.net>
CC: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: Re: [PATCH man-pages v1] fcntl.2: update manpage with verbiage about
 open file description locks
References: <1398797474-744-1-git-send-email-jlayton@poochiereds.net>	<5360D56F.4070509@gmail.com> <20140430081501.3aca5cba@tlielax.poochiereds.net>
In-Reply-To: <20140430081501.3aca5cba@tlielax.poochiereds.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

Thanks for your reply. Comments below.

On 04/30/2014 02:15 PM, Jeff Layton wrote:
> On Wed, 30 Apr 2014 12:50:23 +0200
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:

[...]

>> #      The record locks described above are associated with the  process
>> #      (unlike  the  open file description locks described below).  This
>> #      has some unfortunate consequences:
>>
>> #      *  If a process holding a lock on a file closes any file descrip‐
>> #         tor  referring to the file, then all of the process's locks on
>> #         the file are released, no matter which  file  descriptor  they
>> #         were  obtained  via.  This is bad: it means that a process can
> 
> "were obtained via" is a little awkward. How about "regardless of which
> file descriptor on which they were obtained".

Yeah, it is clumsy. I fixed, and also otherwise made the text more 
precise/concise:

       *  If a process closes any file descriptor referring to a file,
          then  all  of the process's locks on that file are released,
          regardless of the file descriptor(s) on which the locks were
          obtained.
 

[...]

>>   ERRORS
>>   [...]
>>
>> #      EINVAL cmd is  F_OFD_SETLK,  F_OFD_SETLKW,  or  F_OFD_GETLK,  and
>> #             l_pid was not specified as zero.
>>
> 
> The kernel will also return -EINVAL if it doesn't recognize the cmd
> value being passed in. It may be worth mentioning that as well as
> that's the best mechanism to tell whether the kernel actually supports
> OFD locks.

Good point. I added that error case under ERRORS, and added this text to
the top of the page:

       Certain  of  the operations below are supported only since a par‐
       ticular Linux kernel version.  The preferred method  of  checking
       whether  the  host  kernel  supports a aprticular operation is to
       invoke fcntl() with the desired cmd value and then  test  whether
       the  call failed with EINVAL, indicating that the kernel does not
       recognize this value.

==

And getting back to the missed piece:

>>>> The "EACCES or EAGAIN" thing comes from POSIX, because different
>>>> implementations of tradition record locks returned one of these errors.
>>>> So, portable applications using traditional locks must handle either
>>>> possibility. However, that argument doesn't apply for these new locks.
>>>> Surely, we just want to say "set errno to EAGAIN" for this case?
>
> Ahh good catch. I fixed that in the glibc doc but I missed it here.
> Yes, we should be clear that this OFD locks will get back EAGAIN in
> this situation. Can you fix it, or would you prefer I respin the
> patch?

No problem. I fixed it.

Thanks for checking over my revisions!

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
