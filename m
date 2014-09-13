Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaIMFBY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 01:01:24 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:60734 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaIMFBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 01:01:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140912170919.da0719f24020dc2c4a9ae0a7@linux-foundation.org>
References: <20140830163834.29066.98205.stgit@zurg>
	<20140912170919.da0719f24020dc2c4a9ae0a7@linux-foundation.org>
Date: Sat, 13 Sep 2014 09:01:22 +0400
Message-ID: <CALYGNiP7wGPqaCfVCcHwBJzOVTvCWfL6MK3NL5rFC2+vRT2A+A@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] mm/balloon_compaction: fixes and cleanups
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

On Sat, Sep 13, 2014 at 4:09 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 30 Aug 2014 20:41:06 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>
>> I've checked compilation of linux-next/x86 for allnoconfig, defconfig and
>> defconfig + kvmconfig + virtio-balloon with and without balloon-compaction.
>> For stable kernels first three patches should be enough.
>>
>> changes since v1:
>>
>> mm/balloon_compaction: ignore anonymous pages
>> * no changes
>>
>> mm/balloon_compaction: keep ballooned pages away from normal migration path
>> * fix compilation without CONFIG_BALLOON_COMPACTION
>>
>> mm/balloon_compaction: isolate balloon pages without lru_lock
>> * no changes
>>
>> mm: introduce common page state for ballooned memory
>> * move __Set/ClearPageBalloon into linux/mm.h
>> * remove inc/dec_zone_page_state from __Set/ClearPageBalloon
>>
>> mm/balloon_compaction: use common page ballooning
>> * call inc/dec_zone_page_state from balloon_page_insert/delete
>>
>> mm/balloon_compaction: general cleanup
>> * fix compilation without CONFIG_MIGRATION
>> * fix compilation without CONFIG_BALLOON_COMPACTION
>>
>
> The patch "selftests/vm/transhuge-stress: stress test for memory
> compaction" has silently and mysteriously vanished?
>

It's unchanged and has no direct connection to this patchset.
So I've dropped it. If you like it you can keep the v1 version.
