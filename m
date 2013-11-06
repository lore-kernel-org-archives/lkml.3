Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab3KFUeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:34:37 -0500
Received: from smtp137.dfw.emailsrvr.com ([67.192.241.137]:42804 "EHLO
	smtp137.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab3KFUef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:34:35 -0500
Date: Wed, 6 Nov 2013 21:34:30 +0100
From: Andreas Herrmann <andreas.herrmann@calxeda.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/slub: Switch slub_debug kernel option to early_param
 to avoid boot panic
Message-ID: <20131106203429.GL5661@alberich>
References: <20131106184529.GB5661@alberich>
 <000001422ed8406b-14bef091-eee0-4e0e-bcdd-a8909c605910-000000@email.amazonses.com>
 <20131106195417.GK5661@alberich>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131106195417.GK5661@alberich>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 08:54:17PM +0100, Andreas Herrmann wrote:
> On Wed, Nov 06, 2013 at 02:16:33PM -0500, Christoph Lameter wrote:
> > On Wed, 6 Nov 2013, Andreas Herrmann wrote:
> > 
> > > When I've used slub_debug kernel option (e.g.
> > > "slub_debug=,skbuff_fclone_cache" or similar) on a debug session I've
> > > seen a panic like:
> > 
> > Hmmm.. That looks like its due to some slabs not having names
> > during early boot. kmem_cache_flags is called with NULL as a parameter.
> 
> That's because the slub_debug parameter is not evaluated before
> kmem_cache_flags is called.
> 
> Older kernels didn't show this problem. I think the sequence of those
> calls has changed. Not sure what patch set has made that change.

Please ignore this comment.
I revisisted the code and of course you are right.
Hmm, now wondering why my patch covered the panic.

> > Are you sure that this fixes the issue? Looks like the
> > kmem_cache_flag function should fail regardless of how early you set it.
> > 
> > AFAICT the right fix would be:
> 
> That would avoid the panic but I guess it won't enable slub debugging.

Ok, the latter is bogus. Of course debugging is switched on.

> However I'll test this.

Your patch fixed it.


Andreas
