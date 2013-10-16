Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170Ab3JPM0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:26:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:55434 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab3JPM0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:26:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,507,1378882800"; 
   d="scan'208";a="411897616"
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
In-Reply-To: <CACz4_2er-_Xa8oRo_JJTC+HZtDTAcjJ+cNTjrXLhN0Dm7BtXFQ@mail.gmail.com>
References: <20131015001201.GC3432@hippobay.mtv.corp.google.com>
 <20131015100213.A0189E0090@blue.fi.intel.com>
 <CACz4_2er-_Xa8oRo_JJTC+HZtDTAcjJ+cNTjrXLhN0Dm7BtXFQ@mail.gmail.com>
Subject: Re: [PATCH 02/12] mm, thp, tmpfs: support to add huge page into page
 cache for tmpfs
Content-Transfer-Encoding: 7bit
Message-Id: <20131016122611.69CA0E0090@blue.fi.intel.com>
Date: Wed, 16 Oct 2013 15:26:11 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ning Qu wrote:
> Yes, I can try. The code is pretty much similar with some minor difference.
> 
> One thing I can do is to move the spin lock part (together with the
> corresponding err handling into a common function.
> 
> The only problem I can see right now is we need the following
> additional line for shm:
> 
> __mod_zone_page_state(page_zone(page), NR_SHMEM, nr);
> 
> Which means we need to tell if it's coming from shm or not, is that OK
> to add additional parameter just for that? Or is there any other
> better way we can infer that information? Thanks!

I think you can account NR_SHMEM after common code succeed, don't you?

-- 
 Kirill A. Shutemov
