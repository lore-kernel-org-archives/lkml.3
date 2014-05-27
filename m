Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaE0PXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:23:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbaE0PXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:23:46 -0400
Date: Tue, 27 May 2014 11:23:41 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Jens Axboe <axboe@kernel.dk>
cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
Subject: Re: [PATCH] block: flush queued bios when the process blocks
In-Reply-To: <5384AA79.4010206@kernel.dk>
Message-ID: <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com> <5384AA79.4010206@kernel.dk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 May 2014, Jens Axboe wrote:

> On 2014-05-27 09:03, Mikulas Patocka wrote:
> > The block layer uses per-process bio list to avoid recursion in
> > generic_make_request. When generic_make_request is called recursively, the
> > bio is added to current->bio_list and the function returns immediatelly.
> > The top-level instance of generic_make_requests takes bios from
> > current->bio_list and processes them.
> 
> This really begs the question of why we just don't use the per-process plugs
> for this. We already have scheduler hooks in place to flush those at the
> appropriate time. Why are we reinventing something for essentially the same
> thing?
> 
> -- 
> Jens Axboe

Plugs work with requests, this patch works with bios. They are different 
structures, so you can't use one infrastructure to process them.

The patch adds bio list flushing to the scheduler just besides plug 
flushsing.

Mikulas
