Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab3LLNQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:16:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:3379 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab3LLNQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:16:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,878,1378882800"; 
   d="scan'208";a="448931856"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@gentwo.org,
        kirill.shutemov@linux.intel.com, Andi Kleen <ak@linux.intel.com>,
        akpm@linux-foundation.org, Dave Hansen <dave@sr71.net>
In-Reply-To: <20131211223632.8B2DFD41@viggo.jf.intel.com>
References: <20131211223631.51094A3D@viggo.jf.intel.com>
 <20131211223632.8B2DFD41@viggo.jf.intel.com>
Subject: RE: [PATCH 2/2] mm: blk-mq: uses page->list incorrectly
Content-Transfer-Encoding: 7bit
Message-Id: <20131212131636.B7C44E0090@blue.fi.intel.com>
Date: Thu, 12 Dec 2013 15:16:36 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> 'struct page' has two list_head fields: 'lru' and 'list'.
> Conveniently, they are unioned together.  This means that code
> can use them interchangably, which gets horribly confusing.
> 
> The blk-mq made the logical decision to try to use page->list.
> But, that field was actually introduced just for the slub code.
> ->lru is the right field to use outside of slab/slub.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Looks good to me.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

for both.

-- 
 Kirill A. Shutemov
