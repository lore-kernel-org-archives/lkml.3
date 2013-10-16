Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935038Ab3JPRum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:50:42 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:48416 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934722Ab3JPRui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:50:38 -0400
MIME-Version: 1.0
In-Reply-To: <20131016121145.EFC7AE0090@blue.fi.intel.com>
References: <20131015001214.GD3432@hippobay.mtv.corp.google.com>
 <20131015102912.2BC99E0090@blue.fi.intel.com> <CACz4_2eh3F2An9F0GxSvw8kSmn2VZbqbdRVGXA2B=gvPFCChUw@mail.gmail.com>
 <20131016121145.EFC7AE0090@blue.fi.intel.com>
From: Ning Qu <quning@google.com>
Date: Wed, 16 Oct 2013 10:50:17 -0700
Message-ID: <CACz4_2fcnV6UQQU9pKu0cF0MTzC7wu+X_swvyOwmgw0sTxZWWA@mail.gmail.com>
Subject: Re: [PATCH 03/12] mm, thp, tmpfs: handle huge page cases in shmem_getpage_gfp
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Great! Thanks!
Best wishes,
-- 
Ning Qu (曲宁) | Software Engineer | quning@google.com | +1-408-418-6066


On Wed, Oct 16, 2013 at 5:11 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Ning Qu wrote:
>> you mean something like this? If so, then fixed.
>>
>>                if (must_use_thp) {
>>                         page = shmem_alloc_hugepage(gfp, info, index);
>>                         if (page) {
>>                                 count_vm_event(THP_WRITE_ALLOC);
>>                         } else
>>                                 count_vm_event(THP_WRITE_ALLOC_FAILED);
>>                 } else {
>>                         page = shmem_alloc_page(gfp, info, index);
>>                 }
>>
>>                 if (!page) {
>>                         error = -ENOMEM;
>>                         goto unacct;
>>                 }
>>                 nr = hpagecache_nr_pages(page);
>
> Yeah.
>
> count_vm_event() part still looks ugly, but I have similar in my code.
> I'll think more how to rework in to make it better.
>
> --
>  Kirill A. Shutemov
