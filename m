Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaJ1Nnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:43:39 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:34617 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbaJ1Nnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:43:35 -0400
Message-ID: <544F9D7D.40301@gmail.com>
Date: Tue, 28 Oct 2014 14:43:25 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andy Lutomirski <luto@amacapital.net>, mtk.manpages@gmail.com,
        Andrey Wagin <avagin@gmail.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] umount.2: Correct the description of MNT_DETACH
References: <87lhp12a2i.fsf@x220.int.ebiederm.org> <CALCETrXGojRGtT1B2Aib7m54j8T+LsnCOin_GL93-BWf-eSPkA@mail.gmail.com> <87oatxzwex.fsf@x220.int.ebiederm.org> <CALCETrUOeCrjAy---FM-8ovU1FD372ShgBeS5_1LUkgRWMQ4gQ@mail.gmail.com>
In-Reply-To: <CALCETrUOeCrjAy---FM-8ovU1FD372ShgBeS5_1LUkgRWMQ4gQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

I'm still hoping for a revised patch from you in the light
of Andy's comments and question.

Thanks,

Michael


On 09/30/2014 04:16 AM, Andy Lutomirski wrote:
> On Mon, Sep 29, 2014 at 7:15 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On Mon, Sep 29, 2014 at 6:04 PM, Eric W. Biederman
>>> <ebiederm@xmission.com> wrote:
>>>>
>>>> I recently realized that I had been reasoning improperly about what
>>>> umount(MNT_DETACH) did based on an insufficient description in
>>>> the umount.2 man page, that matched my intuition but not the
>>>> implementation.
>>>>
>>>> When there are no submounts MNT_DETACH is essentially harmless to
>>>> applications.  Where there are submounts MNT_DETACH changes what
>>>> is visible to applications using the detach directories.
>>>>
>>>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>>>> ---
>>>>  man2/umount.2 | 7 ++++---
>>>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/man2/umount.2 b/man2/umount.2
>>>> index 5ff88152c738..aea39d8306fe 100644
>>>> --- a/man2/umount.2
>>>> +++ b/man2/umount.2
>>>> @@ -66,9 +66,10 @@ This can cause data loss.
>>>>  (Only for NFS mounts.)
>>>>  .TP
>>>>  .BR MNT_DETACH " (since Linux 2.4.11)"
>>>> -Perform a lazy unmount: make the mount point unavailable for
>>>> -new accesses, and actually perform the unmount when the mount point
>>>> -ceases to be busy.
>>>> +Perform a lazy unmount: make the mount point unavailable for new
>>>> +accesses, immediately disconnect the filesystem and all filesystems
>>>> +mounted below it from each other and from the mount table, and
>>>> +actually perform the unmount when the mount point ceases to be busy.
>>>
>>> Want to add something like:
>>>
>>> MNT_DETACH on a shared mount will propagate unmount events to its peer
>>> group.  That means that recursively bind mounting a shared mount and
>>> then unmounting that recursive bind mount will unmount all submounts
>>> of the original mount.  This behavior can be avoided by remounting a
>>> directory with MS_REC | MS_PRIVATE before unmounting it.
>>
>> Make that any unmount on a shared mount that will propogate unmount
>> events to it's peer group.
> 
> I don't understand your proposed edit.  Can you type it out explicitly?
> 
> --Andy
> 
>>
>> Eric
>>
> 
> 
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
