Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaEXMY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 08:24:56 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:45716 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaEXMYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 08:24:53 -0400
Message-ID: <53804FC0.1010207@gmail.com>
Date: Sat, 24 May 2014 09:52:32 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: mtk.manpages@gmail.com, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Jos Huisken <jos.huisken@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: inotify, new idea?
References: <CAOiKX_m8buaq=4_hVQjyfv36ZtFVFieZ-CU8JeDpcdbeiX5mug@mail.gmail.com> <20140417212834.GC17769@csclub.uwaterloo.ca> <CAHO5Pa1Rb5YkXF_0iE_KUhOOGeNo+zV+OWQW6L8_ix=iFvkTyg@mail.gmail.com> <CAFLxGvxx8_gJ+NAGVn_vZmkVfey45_1qTqAQnxKDCZD0gQsr5w@mail.gmail.com> <CAHO5Pa1hfp+uLiQ78-pn2RJ6SytSYqXTniyx3UvaTwU_=ECWjA@mail.gmail.com> <5354DA0B.2060204@nod.at>
In-Reply-To: <5354DA0B.2060204@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 10:42 AM, Richard Weinberger wrote:
> Am 21.04.2014 09:24, schrieb Michael Kerrisk:
>>> Does recursive monitoring even work with inotify?
>>> Last time I've tried it did failed as soon I did a mkdir -p a/b/c/d because
>>> mkdir() raced against the thread which installes the new watches.
>>
>> As I understand it, you have to program to deal with the races (rescan
>> directories after adding watches). I recently did a lot of work
>> updating the inotify(7) man page to discuss all the issues that I know
>> of, and their remedies. If I missed anything, I'd appreciate a note on
>> it, so that it can be added. See
>> http://man7.org/linux/man-pages/man7/inotify.7.html#NOTES
> 
> I'm aware of the rescan hack, but in my case it does not help
> because my program must not miss any event.
> Currently I'm using a fuse overlay filesystem to log everything.
> Not perfect but works... :-)

Richard,

A late follow up question. How does your application deal with the
event overflow problem (i.e., when you get a large number of events 
much faster than your application can deal with them?

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
