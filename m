Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab3CUNIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:08:52 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37632
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756333Ab3CUNIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:08:51 -0400
Date: Thu, 21 Mar 2013 09:08:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Dave Chinner <david@fromorbit.com>,
        axboe@kernel.dk, laijs@cn.fujitsu.com, fengguang.wu@intel.com,
        linux-kernel@vger.kernel.org, jmoyer@redhat.com
Subject: Re: [PATCH 3/4] writeback: replace custom worker pool implementation
 with unbound workqueue
Message-ID: <20130321130819.GA8721@infradead.org>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
 <1362692649-25570-4-git-send-email-tj@kernel.org>
 <20130312150510.GF13152@quack.suse.cz>
 <20130318223244.GA11188@quack.suse.cz>
 <20130318223526.GH3042@htj.dyndns.org>
 <20130319154600.GC5222@quack.suse.cz>
 <CAOS58YMop8+TnCGK2+SH52WNyK011vP0BWu3XENjrGt9xks32w@mail.gmail.com>
 <20130321015721.GL17758@dastard>
 <20130321050718.GA8012@mtj.dyndns.org>
 <20130321113252.GA30777@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321113252.GA30777@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:32:52PM +0100, Jan Kara wrote:
> On Wed 20-03-13 22:07:18, Tejun Heo wrote:
> > Hello, Dave.
> > 
> > On Thu, Mar 21, 2013 at 12:57:21PM +1100, Dave Chinner wrote:
> > > When you have a system that has 50+ active filesystems (pretty
> > > common in the distributed storage environments were every disk has
> > > it's own filesystem), knowing which filesystem(s) are getting stuck
> > > in writeback from the sysrq-w or hangcheck output is pretty damn
> > > important....
> > 
> > Hmm... I guess, then, what we can do is adding a worker description
> > which is printed out with task dump.  ie. A work function can call
> > work_set_desc(fmt, arg....).  It won't be expensive and can be
> > implemented relatively easily.  Does that sound good enough?
>   Yeah, that sounds good! Thanks!

How about automatically doing this based on the workqueue name?

