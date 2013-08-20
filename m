Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3HTXO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 19:14:26 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:55091 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3HTXOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 19:14:24 -0400
Message-ID: <1377040462.24869.70.camel@bobble.lax.corp.google.com>
Subject: Re: dm: Make MIN_IOS, et al, tunable via sysctl.
From: Frank Mayhar <fmayhar@google.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 20 Aug 2013 16:14:22 -0700
In-Reply-To: <20130820222439.GA5883@redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
	 <alpine.LRH.2.02.1308201712090.8826@file01.intranet.prod.int.rdu2.redhat.com>
	 <1377034118.24869.48.camel@bobble.lax.corp.google.com>
	 <alpine.LRH.2.02.1308201745130.8826@file01.intranet.prod.int.rdu2.redhat.com>
	 <1377035833.24869.57.camel@bobble.lax.corp.google.com>
	 <20130820222439.GA5883@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 18:24 -0400, Mike Snitzer wrote:
> Mikulas' point is that you cannot reduce the size to smaller than 1.
> And aside from rq-based DM, 1 is sufficient to allow for forward
> progress even when memory is completely consumed.
> 
> A patch that simply changes them to 1 but makes the rq-based DM
> mempool's size configurable should actually be fine.

So you're saying that I should submit a patch to drop the pool size for
BIO_BASED to 1 and make the pool size for REQUEST_BASED configurable?
At the moment, in dm.c the former is hardcoded to 16 and the latter is
set via MIN_IOS (currently 256).  There's also io_pool, a slab pool,
which is also set via MIN_IOS.

How does this relate to the rest of the DM modules?  Mpath also sets
MIN_IOS to 256 and creates a slab pool from that, and there are a number
of hardcoded constants in dm-io (MIN_IOS and MIN_BIOS), dm-snap
(MIN_IOS), dm-crypt (MIN_IOS and MIN_POOL_PAGES), dm-bufio
(DM_BUFIO_HASH_BITS, which is allocated via vmalloc per client) and
dm-verity (DM_VERITY_MEMPOOL_SIZE, which is allocated per device).

For the most part I can't imagine that people will want to change these
from their defaults, but when someone does need to change one of these,
they need to do so badly and there's currently no good way to do that
besides hacking the source and building a new kernel.

By the way, I do appreciate the advice.  I'm just trying to clear up
confusion on my part, make sure that our needs are met and, while I'm at
it, make things a bit better for those who come after me.
-- 
Frank Mayhar
310-460-4042

