Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119Ab3JPMLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:11:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:41640 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab3JPMLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:11:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,507,1378882800"; 
   d="scan'208";a="411891664"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Ning Qu <quning@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CACz4_2eh3F2An9F0GxSvw8kSmn2VZbqbdRVGXA2B=gvPFCChUw@mail.gmail.com>
References: <20131015001214.GD3432@hippobay.mtv.corp.google.com>
 <20131015102912.2BC99E0090@blue.fi.intel.com>
 <CACz4_2eh3F2An9F0GxSvw8kSmn2VZbqbdRVGXA2B=gvPFCChUw@mail.gmail.com>
Subject: Re: [PATCH 03/12] mm, thp, tmpfs: handle huge page cases in
 shmem_getpage_gfp
Content-Transfer-Encoding: 7bit
Message-Id: <20131016121145.EFC7AE0090@blue.fi.intel.com>
Date: Wed, 16 Oct 2013 15:11:45 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ning Qu wrote:
> you mean something like this? If so, then fixed.
> 
>                if (must_use_thp) {
>                         page = shmem_alloc_hugepage(gfp, info, index);
>                         if (page) {
>                                 count_vm_event(THP_WRITE_ALLOC);
>                         } else
>                                 count_vm_event(THP_WRITE_ALLOC_FAILED);
>                 } else {
>                         page = shmem_alloc_page(gfp, info, index);
>                 }
> 
>                 if (!page) {
>                         error = -ENOMEM;
>                         goto unacct;
>                 }
>                 nr = hpagecache_nr_pages(page);

Yeah.

count_vm_event() part still looks ugly, but I have similar in my code.
I'll think more how to rework in to make it better.

-- 
 Kirill A. Shutemov
