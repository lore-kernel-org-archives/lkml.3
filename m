Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3LQMfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:35:05 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:48966 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3LQMfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:35:01 -0500
Date: Tue, 17 Dec 2013 07:34:57 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Nigel Cunningham <nigel@nigelcunningham.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system
 is frozen
Message-ID: <20131217123457.GD29989@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <52AB9509.1080004@nigelcunningham.com.au>
 <20131214203121.GB4020@htj.dyndns.org>
 <8951916.gd5Uu6GpK1@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8951916.gd5Uu6GpK1@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Tue, Dec 17, 2013 at 03:34:00AM +0100, Rafael J. Wysocki wrote:
> No, it isn't.  [I guess it was originally, but it has not been the case
> for a very long time.]  It is about getting user space interactions (all of

Heh... no wonder people are all so confused about this thing.

> the sysfs/ioctl/mmap/read/write/you-name-it thingies user space can do to
> devices) when we're calling device suspend/resume routines.  The reason is
> that otherwise all of them would have had to do a "oh, are we suspending by
> the way?" check pretty much on every code path that can be triggered by
> user space.

Freezing userland is fine.  I have no problem with that but up until
now the only use case that seems fundamentally valid to me is freezing
IO processing kthread in a driver as a cheap way to implement
suspend/resume.  At this point, given the general level of confusion,
it seems to be costing more than benefiting.

> > Does that mean that it's safe to unfreeze before invoking resume?
> 
> No, it isn't.

So, are you saying it's really about giving device drivers easy way to
implement suspend/resume?  If that's the case, let's please make it
*way* more specific and clear - ie. things like helpers to implement
suspend/resume hooks trivially or whatnot.  Freezable kthreads (and
now workqueues) have been becoming a giant mess for a while now.

Thanks.

-- 
tejun
