Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab3HGHQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:16:23 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44543 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab3HGHQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:16:21 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-c8-5201f4438539
Date: Wed, 7 Aug 2013 16:16:24 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 1/4] mm, rmap: do easy-job first in anon_vma_fork
Message-ID: <20130807071624.GA32449@lge.com>
References: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130806125854.GG1845@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130806125854.GG1845@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Johannes.

On Tue, Aug 06, 2013 at 08:58:54AM -0400, Johannes Weiner wrote:
> >  	if (anon_vma_clone(vma, pvma))
> > -		return -ENOMEM;
> > -
> > -	/* Then add our own anon_vma. */
> > -	anon_vma = anon_vma_alloc();
> > -	if (!anon_vma)
> > -		goto out_error;
> > -	avc = anon_vma_chain_alloc(GFP_KERNEL);
> > -	if (!avc)
> >  		goto out_error_free_anon_vma;
> 
> Which heavy work?  anon_vma_clone() is anon_vma_chain_alloc() in a
> loop.
> 
> Optimizing error paths only makes sense if they are common and you
> actually could save something by reordering.  This matches neither.

Yes, you are right. I drop this one.

Thanks.
