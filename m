Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3KDQEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:04:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab3KDQEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:04:34 -0500
Date: Mon, 4 Nov 2013 11:04:30 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: axboe@kernel.dk, kmo@daterainc.com, dm-devel@redhat.com, agk@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next] dm: fix missing bi_remaining accounting
Message-ID: <20131104160336.GB12398@redhat.com>
References: <20131101135931.GA22903@redhat.com>
 <5273C2B8.5030608@kernel.dk>
 <alpine.LRH.2.02.1311041003400.4548@file01.intranet.prod.int.rdu2.redhat.com>
 <20131104152001.GA12398@redhat.com>
 <alpine.LRH.2.02.1311041023090.4548@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1311041023090.4548@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04 2013 at 10:25am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Mon, 4 Nov 2013, Mike Snitzer wrote:
> 
> > On Mon, Nov 04 2013 at 10:06am -0500,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > 
> > > The code uses atomic_inc for restoration of bi_remaining. This patch
> > > changes it to atomic_set(1) to avoid an interlocked instruction. In the
> > > target's bi_endio routine we are sure that bi_remaining is zero
> > > (otherwise, the bi_endio routine wouldn't be called) and there are no
> > > concurrent users of the bio, so we can replace atomic_inc with
> > > atomic_set(1).
> > 
> > This isn't DM-specific.  Shouldn't the other places in the tree that use
> > atomic_inc on bi_remaining should really be converted at the same time?
> 
> There is no 'atomic_inc.*bi_remaining' in other drivers.

Wrong.  I know btrfs has at least one.  As does bcache afaik.
