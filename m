Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab3CUB5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 21:57:25 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:57707 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303Ab3CUB5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 21:57:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgZAFRoSlF5LAzK/2dsb2JhbABDwAOFMwEDAYFWF3SCJAEBBTocIxAIAw4KCSUPBSUDIROIE8JaFY1RDyAeXQeDQAOWX5EDgVSBSiiBLw
Date: Thu, 21 Mar 2013 12:57:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, axboe@kernel.dk, laijs@cn.fujitsu.com,
        fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
        jmoyer@redhat.com
Subject: Re: [PATCH 3/4] writeback: replace custom worker pool implementation
 with unbound workqueue
Message-ID: <20130321015721.GL17758@dastard>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
 <1362692649-25570-4-git-send-email-tj@kernel.org>
 <20130312150510.GF13152@quack.suse.cz>
 <20130318223244.GA11188@quack.suse.cz>
 <20130318223526.GH3042@htj.dyndns.org>
 <20130319154600.GC5222@quack.suse.cz>
 <CAOS58YMop8+TnCGK2+SH52WNyK011vP0BWu3XENjrGt9xks32w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YMop8+TnCGK2+SH52WNyK011vP0BWu3XENjrGt9xks32w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:28:24AM -0700, Tejun Heo wrote:
> Hello, Jan.
> 
> On Tue, Mar 19, 2013 at 8:46 AM, Jan Kara <jack@suse.cz> wrote:
> >   Well, but what you often get is just output of sysrq-w, or sysrq-t, or
> > splat from scheduler about stuck task. You often don't have the comfort of
> > tracing... Can't we somehow change 'comm' of the task when it starts
> > processing work of some bdi?
> 
> You sure can but I'd prefer not to do that. If you wanna do it
> properly, you have to grab task lock every time a work item starts
> execution. I'm not sure how beneficial having the block device
> identifier would be. Backtrace would be there the same. Is identifying
> the block device that important?

When you have a system that has 50+ active filesystems (pretty
common in the distributed storage environments were every disk has
it's own filesystem), knowing which filesystem(s) are getting stuck
in writeback from the sysrq-w or hangcheck output is pretty damn
important....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
