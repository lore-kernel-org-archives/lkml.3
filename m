Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3KGIll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:41:41 -0500
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:46113 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293Ab3KGIld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:41:33 -0500
Date: Thu, 7 Nov 2013 09:41:29 +0100
From: Andreas Herrmann <andreas.herrmann@calxeda.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/slub: Switch slub_debug kernel option to early_param
 to avoid boot panic
Message-ID: <20131107084129.GP5661@alberich>
References: <20131106184529.GB5661@alberich>
 <000001422ed8406b-14bef091-eee0-4e0e-bcdd-a8909c605910-000000@email.amazonses.com>
 <20131106195417.GK5661@alberich>
 <20131106203429.GL5661@alberich>
 <20131106211604.GM5661@alberich>
 <000001422f59e79e-ba0d30e2-fe7d-4e6f-9029-65dc5978fe60-000000@email.amazonses.com>
 <20131107082732.GN5661@alberich>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131107082732.GN5661@alberich>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 09:27:32AM +0100, Andreas Herrmann wrote:
> On Wed, Nov 06, 2013 at 04:38:10PM -0500, Christoph Lameter wrote:
> > On Wed, 6 Nov 2013, Andreas Herrmann wrote:
> > 
> > > Would be nice, if your patch is pushed upstream asap.
> > 
> > Ok so this is a
> > 
> > Tested-by: Andreas Herrmann <andreas.herrmann@calxeda.com>
> > 
> > I think?
> 
> Yes.

And for sake of completeness. Here is some debug output with a kernel
that had your "slub: Handle NULL parameter in kmem_cache_flags" patch
applied. And of course there were a couple of unnamed slabs:

  ...
         .bss : 0xc089fd80 - 0xc094cc4c   ( 692 kB)
  slub_debug_slabs (c2956a08): skbuff_fclone_cache, name (c06fc90c): kmem_cache_node
  slub_debug_slabs (c2956a08): skbuff_fclone_cache, name (c06fc91c): kmem_cache
→ slub_debug_slabs (c2956a08): skbuff_fclone_cache, name (  (null)): (null)
  slub_debug_slabs (c2956a08): skbuff_fclone_cache, name (  (null)): (null)
  slub_debug_slabs (c2956a08): skbuff_fclone_cache, name (  (null)): (null)
  slub_debug_slabs (c2956a08): skbuff_fclone_cache, name (  (null)): (null)
  slub_debug_slabs (c2956a08): skbuff_fclone_cache, name (  (null)): (null)
  slub_debug_slabs (c2956a08): skbuff_fclone_cache, name (  (null)): (null)
  slub_debug_slabs (c2956a08): skbuff_fclone_cache, name (  (null)): (null)
  slub_debug_slabs (c2956a08): skbuff_fclone_cache, name (  (null)): (null)
  slub_debug_slabs (c2956a08): skbuff_fclone_cache, name (  (null)): (null)
  SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
  ...

The third one is wheree the panic happened w/o the fix.


Andreas
