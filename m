Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab3DYVPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:15:08 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:48783 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758852Ab3DYVPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:15:06 -0400
Date: Thu, 25 Apr 2013 14:14:59 -0700
From: Tejun Heo <tj@kernel.org>
To: scameron@beardog.cce.hp.com
Cc: axboe@kernel.dk, neilb@suse.de, hch@infradead.org, jmoyer@redhat.com,
        hare@suse.de, shaohua.li@intel.com, vgoyal@redhat.com,
        stephenmcameron@gmail.com, linux-kernel@vger.kernel.org,
        lsorense@csclub.uwaterloo.ca
Subject: Re: [RFC PATCH] block: Add new generic block device naming interface
Message-ID: <20130425211459.GC10990@mtj.dyndns.org>
References: <20130425202215.20557.75283.stgit@beardog.cce.hp.com>
 <20130425204033.GB10990@mtj.dyndns.org>
 <20130425210726.GL7917@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425210726.GL7917@beardog.cce.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 25, 2013 at 04:07:26PM -0500, scameron@beardog.cce.hp.com wrote:
> > Hmmm... maybe I'm missing something but the names assigned this way
> > wouldn't have any kind of stability across boots.  Is that good
> > enough?  
> 
> Perhaps not.  I am open to suggestions on that front -- perhaps there's
> some way for udev to help sort things out?

udev already does that by adding names by types, connection, UUID,
what not.  They aren't the names recognized by the kernel, so I
suppose aren't useful for your purpose?  But then again udev can't
really do anything further.

> > But, if so, I'm kinda having hard time understanding what
> > it'd be able to do which any other name can't do.
> > 
> > Can you please elaborate the use case?
> 
> Sure.
> 
> Right now, if you add a new block driver, if you want grub to be able
> to boot it, you also have to modify grub.  This is true for each new
> block driver that comes along.  This is not the case for SCSI HBA
> drivers, because they all get to share the sd driver and its device
> name space, and grub already knows about that.  You can add all kinds
> of SCSI HBA drivers and never have to worry about needing to modify
> grub to get boot support.

So, the question, I suppose, is why grub needs to be changed when the
stem of device names changes.  Why does it need to do that?  Is it
just an implementation detail or is it something more fundamental?

Thanks.

-- 
tejun
