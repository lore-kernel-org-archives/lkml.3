Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbaDVT7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:59:09 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:36927 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaDVT7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:59:06 -0400
MIME-Version: 1.0
In-Reply-To: <535532B3.6060800@nod.at>
References: <CAOiKX_m8buaq=4_hVQjyfv36ZtFVFieZ-CU8JeDpcdbeiX5mug@mail.gmail.com>
	<20140417212834.GC17769@csclub.uwaterloo.ca>
	<CAHO5Pa1Rb5YkXF_0iE_KUhOOGeNo+zV+OWQW6L8_ix=iFvkTyg@mail.gmail.com>
	<CAFLxGvxx8_gJ+NAGVn_vZmkVfey45_1qTqAQnxKDCZD0gQsr5w@mail.gmail.com>
	<CAHO5Pa1hfp+uLiQ78-pn2RJ6SytSYqXTniyx3UvaTwU_=ECWjA@mail.gmail.com>
	<5354DA0B.2060204@nod.at>
	<53551DB0.6030302@gmail.com>
	<535532B3.6060800@nod.at>
Date: Tue, 22 Apr 2014 21:59:05 +0200
Message-ID: <CAOiKX_=X176bJHLwiJ2tfc8QdK_cFWuJh7VZPNLnp1ersr5A9A@mail.gmail.com>
Subject: Re: inotify, new idea?
From: Jos Huisken <jos.huisken@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like also 'mv' events are also not supported by fanotify, like
creation/deletion.
Therefore not an option (for lsyncd) probably. Maybe loggedfs is (if
time permits...).
Thanks for the discussion.

Jos

On Mon, Apr 21, 2014 at 5:01 PM, Richard Weinberger <richard@nod.at> wrote:
>
>
> Am 21.04.2014 15:31, schrieb Michael Kerrisk (man-pages):
>> On 04/21/2014 10:42 AM, Richard Weinberger wrote:
>>> Am 21.04.2014 09:24, schrieb Michael Kerrisk:
>>>>> Does recursive monitoring even work with inotify?
>>>>> Last time I've tried it did failed as soon I did a mkdir -p a/b/c/d because
>>>>> mkdir() raced against the thread which installes the new watches.
>>>>
>>>> As I understand it, you have to program to deal with the races (rescan
>>>> directories after adding watches). I recently did a lot of work
>>>> updating the inotify(7) man page to discuss all the issues that I know
>>>> of, and their remedies. If I missed anything, I'd appreciate a note on
>>>> it, so that it can be added. See
>>>> http://man7.org/linux/man-pages/man7/inotify.7.html#NOTES
>>>
>>> I'm aware of the rescan hack, but in my case it does not help
>>> because my program must not miss any event.
>>
>> Then, we're understand the same thing: you're out of luck :-}.
>>
>>> Currently I'm using a fuse overlay filesystem to log everything.
>>> Not perfect but works... :-)
>>
>> Interesting notion. I need to get to grips with FUSE...
>
> e.g. http://loggedfs.sourceforge.net/
>
> Thanks,
> //richard
