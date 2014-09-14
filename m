Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaINC6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 22:58:41 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35332 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaINC6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 22:58:39 -0400
Message-ID: <54150458.9060408@gmail.com>
Date: Sat, 13 Sep 2014 19:58:32 -0700
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: mtk.manpages@gmail.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: For review: user_namespace(7) man page
References: <53F5310A.5080503@gmail.com> <CALCETrX2qwvzmeoVcLFLxEK=1Fv+f0Ri0TouzzvbN_rgDjka4A@mail.gmail.com> <540F0810.7030408@gmail.com> <87ppf4n5ib.fsf@x220.int.ebiederm.org> <CALCETrV4WizRXD9JuwibUBbQE9hhNrRDJ3cYyXdhd=OfPziF5g@mail.gmail.com> <5411B5F5.2090500@gmail.com> <CALCETrXOgCUrrzeJYJ6VoPgR5Rt0HFCrhRC0H7+3XLv1Y+sJ_A@mail.gmail.com>
In-Reply-To: <CALCETrXOgCUrrzeJYJ6VoPgR5Rt0HFCrhRC0H7+3XLv1Y+sJ_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 08:15 AM, Andy Lutomirski wrote:
> On Thu, Sep 11, 2014 at 7:47 AM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>>
>> So, in the current draft of the setns(2) page, there is
>>
>>     CLONE_NEWNS
>>         ...
>>         Since  Linux 3.9, CLONE_NEWUSER also automatically  implies
>>         CLONE_FS.
>>
>> Does that cover your point? Or did you mean that more needs to be said?
> 
> Looks good, although you could add CLONE_THREAD and the rest of the
> things implied by CLONE_THREAD if you want to be fancier.

Yes, under CLONE_NEWUSER there is also a statement that that flag 
implies CLONE_THREAD, and elsewhere in the page there is the
following text:

[[
       In addition, CLONE_THREAD, CLONE_SIGHAND, and CLONE_VM  can  be
       specified  in  flags if the caller is single threaded (i.e., it
       is not sharing  its  address  space  with  another  process  or
       thread).  In this case, these flags have no effect.  (Note also
       that specifying CLONE_THREAD  automatically  implies  CLONE_VM,
       and  specifying  CLONE_VM automatically implies CLONE_SIGHAND.)
       If the process is multithreaded, then the use  of  these  flags
       results in an error.
]]

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
