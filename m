Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab3DYVJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:09:01 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:32185 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab3DYVJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:09:00 -0400
Date: Thu, 25 Apr 2013 16:07:26 -0500
From: scameron@beardog.cce.hp.com
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, neilb@suse.de, hch@infradead.org, jmoyer@redhat.com,
        hare@suse.de, shaohua.li@intel.com, vgoyal@redhat.com,
        stephenmcameron@gmail.com, linux-kernel@vger.kernel.org,
        lsorense@csclub.uwaterloo.ca, scameron@beardog.cce.hp.com
Subject: Re: [RFC PATCH] block: Add new generic block device naming interface
Message-ID: <20130425210726.GL7917@beardog.cce.hp.com>
References: <20130425202215.20557.75283.stgit@beardog.cce.hp.com> <20130425204033.GB10990@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425204033.GB10990@mtj.dyndns.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 01:40:33PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Apr 25, 2013 at 03:22:15PM -0500, Stephen M. Cameron wrote:
> > If block drivers could (optionally) share a common device namespace then
> > grub could be taught about this common namespace once, and any new block
> > device drivers could take advantage of this namespace and grub would
> > automatically work with them.
> 
> Hmmm... maybe I'm missing something but the names assigned this way
> wouldn't have any kind of stability across boots.  Is that good
> enough?  

Perhaps not.  I am open to suggestions on that front -- perhaps there's
some way for udev to help sort things out?

> But, if so, I'm kinda having hard time understanding what
> it'd be able to do which any other name can't do.
> 
> Can you please elaborate the use case?

Sure.

Right now, if you add a new block driver, if you want grub to be able
to boot it, you also have to modify grub.  This is true for each new
block driver that comes along.  This is not the case for SCSI HBA
drivers, because they all get to share the sd driver and its device
name space, and grub already knows about that.  You can add all kinds
of SCSI HBA drivers and never have to worry about needing to modify
grub to get boot support.

It seems wrong to me that for every new block driver needing boot support
grub has to be modified.  If there were a common block device name space
which grub knew about, any new block driver which comes along that needs
support from grub could get it by using this common block device name space.

So that is the problem I'd like to solve.  I realize the patch I've put
up for discussion may fall short.  And it's possible there's a good reason
such a thing as I propose isn't already present, in which case I'd like
to learn what that reason is.

Thanks,

-- steve

