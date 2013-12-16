Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3LPMvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:51:37 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:51139 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3LPMvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:51:35 -0500
Date: Mon, 16 Dec 2013 07:51:24 -0500
From: Tejun Heo <tj@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Message-ID: <20131216125124.GC32509@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131214015343.GP31386@dastard>
 <20131214202324.GA4020@htj.dyndns.org>
 <20131216035652.GY31386@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216035652.GY31386@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 02:56:52PM +1100, Dave Chinner wrote:
> > What are you suggesting?  Implementing separate warm and hot unplug
> > paths?  That makes no sense whatsoever.  Device hot unplug is just a
> > sub operation of general device unplug which should be able to succeed
> > whether the underlying device is failing IOs or not.
> 
> I don't care. Trying to issue IO from an an IO error handling path
> where the device has just been removed is fundamentally broken.

What?  Have you even read the original message?  IO error handling
path isn't issuing the IO here.  The hot unplug operation is
completely asynchronous to the IO path.  What's dead locking is not
the filesystem and IO path but device driver layer and hot unplug
path.  IOs are not stalled.

> Indeed, what I'm asking for is for a notification so that we can
> *shut the filesystem down* straight away, rather than have to wait
> for an IO error in a critical metadata structure to trigger the
> shutdown for us.

which has exactly zero to do with the issue at hand.  Would you please
stop derailing the discussion?  Again, IOs are not stalled.  That's
not the issue here.

> > > It's simply not a valid thing to do - just how is the filesystem
> > > supposed to sync to a non-existent device?
> > 
> > By issuing all IOs and then handling the failures appropriately.
> 
> Which bit of "filesystem might deadlock trying to issue IO" didn't
> you understand?

smh, I give up.

-- 
tejun
