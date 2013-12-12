Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3LLRqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:46:08 -0500
Received: from a9-99.smtp-out.amazonses.com ([54.240.9.99]:44443 "EHLO
	a9-99.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884Ab3LLRqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:46:05 -0500
Date: Thu, 12 Dec 2013 17:46:02 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Hansen <dave@sr71.net>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC][PATCH 2/3] mm: slab: move around slab ->freelist for
 cmpxchg
In-Reply-To: <20131211224025.70B40B9C@viggo.jf.intel.com>
Message-ID: <00000142e7ea519d-8906d225-c99c-44b5-b381-b573c75fd097-000000@email.amazonses.com>
References: <20131211224022.AA8CF0B9@viggo.jf.intel.com> <20131211224025.70B40B9C@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.12-54.240.9.99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Dave Hansen wrote:

>
> The write-argument to cmpxchg_double() must be 16-byte aligned.
> We used to align 'struct page' itself in order to guarantee this,
> but that wastes 8-bytes per page.  Instead, we take 8-bytes
> internal to the page before page->counters and move freelist
> between there and the existing 8-bytes after counters.  That way,
> no matter how 'stuct page' itself is aligned, we can ensure that
> we have a 16-byte area with which to to this cmpxchg.

Well this adds additional branching to the fast paths.
