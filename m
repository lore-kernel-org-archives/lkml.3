Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbaDUHZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 03:25:11 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:39821 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaDUHZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 03:25:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvxx8_gJ+NAGVn_vZmkVfey45_1qTqAQnxKDCZD0gQsr5w@mail.gmail.com>
References: <CAOiKX_m8buaq=4_hVQjyfv36ZtFVFieZ-CU8JeDpcdbeiX5mug@mail.gmail.com>
 <20140417212834.GC17769@csclub.uwaterloo.ca> <CAHO5Pa1Rb5YkXF_0iE_KUhOOGeNo+zV+OWQW6L8_ix=iFvkTyg@mail.gmail.com>
 <CAFLxGvxx8_gJ+NAGVn_vZmkVfey45_1qTqAQnxKDCZD0gQsr5w@mail.gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 21 Apr 2014 09:24:47 +0200
X-Google-Sender-Auth: 5BdHoJ9UvD5rA7AkuIMFb__nX30
Message-ID: <CAHO5Pa1hfp+uLiQ78-pn2RJ6SytSYqXTniyx3UvaTwU_=ECWjA@mail.gmail.com>
Subject: Re: inotify, new idea?
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Jos Huisken <jos.huisken@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 12:22 AM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> On Fri, Apr 18, 2014 at 6:15 AM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
>> On Thu, Apr 17, 2014 at 11:28 PM, Lennart Sorensen
>> <lsorense@csclub.uwaterloo.ca> wrote:
>>> On Thu, Apr 17, 2014 at 11:00:37PM +0200, Jos Huisken wrote:
>>>> I was trying to maintain a local and remote directory in sync with
>>>> lsync, using inotify.
>>>> I happen to have >4M files and >400k directories... running over
>>>> /proc/sys/fs/inotify/max_user_watches
>>>
>>> Would fanotify perhaps be a better interface to use?
>>
>> (One of us is misunderstanding fanotify; it might be me.)
>>
>> Did you look at fanotify closely? I don't think it could be used for
>> this task -- does not notify linka dn unlink events, difficult to set
>> up recursive monitoring, etc.
>
> Does recursive monitoring even work with inotify?
> Last time I've tried it did failed as soon I did a mkdir -p a/b/c/d because
> mkdir() raced against the thread which installes the new watches.

As I understand it, you have to program to deal with the races (rescan
directories after adding watches). I recently did a lot of work
updating the inotify(7) man page to discuss all the issues that I know
of, and their remedies. If I missed anything, I'd appreciate a note on
it, so that it can be added. See
http://man7.org/linux/man-pages/man7/inotify.7.html#NOTES

Cheers,

Michael


-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
