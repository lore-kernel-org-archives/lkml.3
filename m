Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaDUIm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 04:42:59 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750902AbaDUIm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 04:42:56 -0400
Message-ID: <5354DA0B.2060204@nod.at>
Date: Mon, 21 Apr 2014 10:42:51 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Jos Huisken <jos.huisken@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: inotify, new idea?
References: <CAOiKX_m8buaq=4_hVQjyfv36ZtFVFieZ-CU8JeDpcdbeiX5mug@mail.gmail.com> <20140417212834.GC17769@csclub.uwaterloo.ca> <CAHO5Pa1Rb5YkXF_0iE_KUhOOGeNo+zV+OWQW6L8_ix=iFvkTyg@mail.gmail.com> <CAFLxGvxx8_gJ+NAGVn_vZmkVfey45_1qTqAQnxKDCZD0gQsr5w@mail.gmail.com> <CAHO5Pa1hfp+uLiQ78-pn2RJ6SytSYqXTniyx3UvaTwU_=ECWjA@mail.gmail.com>
In-Reply-To: <CAHO5Pa1hfp+uLiQ78-pn2RJ6SytSYqXTniyx3UvaTwU_=ECWjA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.04.2014 09:24, schrieb Michael Kerrisk:
>> Does recursive monitoring even work with inotify?
>> Last time I've tried it did failed as soon I did a mkdir -p a/b/c/d because
>> mkdir() raced against the thread which installes the new watches.
> 
> As I understand it, you have to program to deal with the races (rescan
> directories after adding watches). I recently did a lot of work
> updating the inotify(7) man page to discuss all the issues that I know
> of, and their remedies. If I missed anything, I'd appreciate a note on
> it, so that it can be added. See
> http://man7.org/linux/man-pages/man7/inotify.7.html#NOTES

I'm aware of the rescan hack, but in my case it does not help
because my program must not miss any event.
Currently I'm using a fuse overlay filesystem to log everything.
Not perfect but works... :-)

Thanks,
//richard
