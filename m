Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3CUShS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:37:18 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46497 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3CUShQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:37:16 -0400
Date: Thu, 21 Mar 2013 11:37:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        axboe@kernel.dk, laijs@cn.fujitsu.com, fengguang.wu@intel.com,
        linux-kernel@vger.kernel.org, jmoyer@redhat.com
Subject: Re: [PATCH 3/4] writeback: replace custom worker pool implementation
 with unbound workqueue
Message-ID: <20130321183711.GD20500@htj.dyndns.org>
References: <1362692649-25570-4-git-send-email-tj@kernel.org>
 <20130312150510.GF13152@quack.suse.cz>
 <20130318223244.GA11188@quack.suse.cz>
 <20130318223526.GH3042@htj.dyndns.org>
 <20130319154600.GC5222@quack.suse.cz>
 <CAOS58YMop8+TnCGK2+SH52WNyK011vP0BWu3XENjrGt9xks32w@mail.gmail.com>
 <20130321015721.GL17758@dastard>
 <20130321050718.GA8012@mtj.dyndns.org>
 <20130321113252.GA30777@quack.suse.cz>
 <20130321130819.GA8721@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321130819.GA8721@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Christoph.

On Thu, Mar 21, 2013 at 09:08:19AM -0400, Christoph Hellwig wrote:
> > > Hmm... I guess, then, what we can do is adding a worker description
> > > which is printed out with task dump.  ie. A work function can call
> > > work_set_desc(fmt, arg....).  It won't be expensive and can be
> > > implemented relatively easily.  Does that sound good enough?
> >   Yeah, that sounds good! Thanks!
> 
> How about automatically doing this based on the workqueue name?

We already have that information and just need to print it.  The thing
is some users including writeback want further identifying information
inside the workqueue.  The same workqueue would be serving all
writeback work items but it would be nice to be able to distinguish
which specific device was being serviced, so we need more information
than the associated workqueue.

Thanks.

-- 
tejun
