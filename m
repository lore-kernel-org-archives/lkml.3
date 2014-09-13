Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaIMFn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 01:43:57 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46122 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaIMFnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 01:43:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140912170616.cb4c832a09cc2b221453ad32@linux-foundation.org>
References: <20140830163834.29066.98205.stgit@zurg>
	<20140830164127.29066.99498.stgit@zurg>
	<20140912170404.f14663cc823691cab36bf793@linux-foundation.org>
	<20140912170616.cb4c832a09cc2b221453ad32@linux-foundation.org>
Date: Sat, 13 Sep 2014 09:43:54 +0400
Message-ID: <CALYGNiM-ArE2+M+xjSbDjLyNc_Rr0C=6TKBKPi4bEwxFfeU_tA@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] mm/balloon_compaction: general cleanup
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Rafael Aquini <aquini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 4:06 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 12 Sep 2014 17:04:04 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Sat, 30 Aug 2014 20:41:27 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>>
>> > * move special branch for balloon migraion into migrate_pages
>> > * remove special mapping for balloon and its flag AS_BALLOON_MAP
>> > * embed struct balloon_dev_info into struct virtio_balloon
>> > * cleanup balloon_page_dequeue, kill balloon_page_free
>>
>> Not sure what's going on here - your include/linux/balloon_compaction.h
>> seems significantly different from mine.
>
> OK, I worked it out.
>
>> I think I'll just drop this patch - it's quite inconvenient to have a
>> large "general cleanup" coming after a stack of significant functional
>> changes.  It makes review, debug, fix, merge and reversion harder.
>> Let's worry about it later.
>
> But I'm still thinking we should defer this one?

It seems in this case massive cleanup before fixies leads to much bigger mess.
I've separated fixes specially for merging into stable kernels.

The rest patches mostly rewrites this code using new approatch.
I don't know how to make it more reviewable, it's easier to write a
new version from the scratch.
Probably rework should be untied form fixes and sent as separate patchset.
