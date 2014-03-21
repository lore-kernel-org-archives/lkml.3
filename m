Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaCUXh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 19:37:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50348 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaCUXhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 19:37:07 -0400
Subject: Re: [PATCH v2 1/3] kmemleak: allow freeing internal objects after kmemleak was disabled
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=GB2312
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <5326750E.1000004@huawei.com>
Date: Fri, 21 Mar 2014 23:37:03 +0000
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F7314A69-24BE-42B9-8E99-8F9292B397C4@arm.com>
References: <5326750E.1000004@huawei.com>
To: Li Zefan <lizefan@huawei.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

On 17 Mar 2014, at 04:07, Li Zefan <lizefan@huawei.com> wrote:
> Currently if kmemleak is disabled, the kmemleak objects can never be freed,
> no matter if it's disabled by a user or due to fatal errors.
> 
> Those objects can be a big waste of memory.
> 
>  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> 1200264 1197433  99%    0.30K  46164       26    369312K kmemleak_object
> 
> With this patch, internal objects will be freed immediately if kmemleak is
> disabled explicitly by a user. If it's disabled due to a kmemleak error,
> The user will be informed, and then he/she can reclaim memory with:
> 
> 	# echo off > /sys/kernel/debug/kmemleak
> 
> v2: use "off" handler instead of "clear" handler to do this, suggested
>    by Catalin.

I think there was a slight misunderstanding. My point was about "echo
scan=off¡± before ¡°echo off¡±, they can just be squashed into the
same action of the latter.

I would keep the ¡°clear¡± part separately as per your first patch. I
recall people asked in the past to still be able to analyse the reports
even though kmemleak failed or was disabled.

Thanks,

Catalin