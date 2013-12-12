Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab3LLT3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:29:36 -0500
Received: from www.sr71.net ([198.145.64.142]:44821 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab3LLT3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:29:35 -0500
Message-ID: <52AA0E5D.30903@sr71.net>
Date: Thu, 12 Dec 2013 11:28:29 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kirill.shutemov@linux.intel.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] mm: slab: separate slab_page from 'struct page'
References: <20131210204641.3CB515AE@viggo.jf.intel.com> <00000142de5634af-f92870a7-efe2-45cd-b50d-a6fbdf3b353c-000000@email.amazonses.com> <52A78B55.8050500@sr71.net> <00000142de866123-cf1406b5-b7a3-4688-b46f-80e338a622a1-000000@email.amazonses.com> <52A793D0.4020306@sr71.net> <00000142e7e23135-20f346b1-a880-47b0-946c-122323669ec1-000000@email.amazonses.com>
In-Reply-To: <00000142e7e23135-20f346b1-a880-47b0-946c-122323669ec1-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 09:37 AM, Christoph Lameter wrote:
> On Tue, 10 Dec 2013, Dave Hansen wrote:
>> See? *EVERYTHING* is overridden by at least one of the sl?b allocators
>> except ->flags.  In other words, there *ARE* no relationships when it
>> comes to the sl?bs, except for page->flags.
> 
> Slab objects can be used for I/O and then the page fields become
> important.

OK, which fields?  How are they important?  Looking at 'struct page', I
don't see any fields other than ->flags that the slab allocators leave
alone.

I do see some refcounting (page->_count) done on
request_queue->dma_drain_buffer which is kmalloc()'d.  Although, I'm a
bit skeptical that this is correct or has been audited because the slabs
do seem to write over this storage.  Anything needing to do per-page
could probably be converted over to a raw alloc_pages() anyway because
it couldn't possibly be doing sub-page-size allocations.

What other cases were you thinking of?
