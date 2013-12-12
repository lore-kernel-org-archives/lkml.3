Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3LLSAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:00:22 -0500
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:47980 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519Ab3LLSAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:00:18 -0500
X-Greylist: delayed 959 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Dec 2013 13:00:18 EST
Date: Thu, 12 Dec 2013 17:44:18 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Hansen <dave@sr71.net>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC][PATCH 3/3] mm: slabs: reset page at free
In-Reply-To: <20131211224028.9D7AD2B7@viggo.jf.intel.com>
Message-ID: <00000142e7e8ba5d-bcdf8715-dd6a-411a-8c55-12a4668c6489-000000@email.amazonses.com>
References: <20131211224022.AA8CF0B9@viggo.jf.intel.com> <20131211224028.9D7AD2B7@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.12-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Dave Hansen wrote:

> We now have slub's ->freelist usage impinging on page->mapping's
> storage space.  The buddy allocator wants ->mapping to be NULL
> when a page is handed back, so we have to make sure that it is
> cleared.
>
> Note that slab already doeds this, so just create a common helper
> and have all the slabs do it this way.  ->mapping is right next
> to ->flags, so it's virtually guaranteed to be in the L1 at this
> point, so this shouldn't cost very much to do in practice.

Maybe add a common page alloc and free function in mm/slab_common.c?

All the allocators do similar things after all.
