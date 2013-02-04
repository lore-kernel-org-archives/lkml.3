Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3BDX32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:29:28 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45019 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab3BDX30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:29:26 -0500
MIME-Version: 1.0
In-Reply-To: <20130204150657.6d05f76a.akpm@linux-foundation.org>
References: <1359973626-3900-1-git-send-email-m.szyprowski@samsung.com>
	<20130204150657.6d05f76a.akpm@linux-foundation.org>
Date: Tue, 5 Feb 2013 08:29:26 +0900
X-Google-Sender-Auth: clHY7LJFtqg5kSyxwxsY8e1unqk
Message-ID: <CAH9JG2Usd4HJKrBXwX3aEc3i6068zU=F=RjcoQ8E8uxYGrwXgg@mail.gmail.com>
Subject: Re: [PATCH] mm: cma: fix accounting of CMA pages placed in high memory
From: Kyungmin Park <kmpark@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, minchan@kernel.org, mgorman@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 8:06 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 04 Feb 2013 11:27:05 +0100
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>
>> The total number of low memory pages is determined as
>> totalram_pages - totalhigh_pages, so without this patch all CMA
>> pageblocks placed in highmem were accounted to low memory.
>
> What are the end-user-visible effects of this bug?

Even though CMA is located at highmem. LowTotal has more than lowmem
address spaces.

e.g.,
lowmem  : 0xc0000000 - 0xdf000000   ( 496 MB)
LowTotal:         555788 kB

>
> (This information is needed so that others can make patch-scheduling
> decisions and should be included in all bugfix changelogs unless it is
> obvious).

CMA Highmem support is new feature. so don't need to go stable tree.

Thank you,
Kyungmin Park
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
