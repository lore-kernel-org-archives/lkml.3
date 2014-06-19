Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965893AbaFSVmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:42:46 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:65329 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964845AbaFSVmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:42:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqVmAPdYo1N5LC2vPGdsb2JhbABZgw2DSIUIonQBAQEBAQEGmSkBgQ4XBAEBAQE4NYQDAQEFOhwjEAgDDgoJJQ8FJQMHGhOIQcxuFxaFTIhLSQeEQwSaQosxi3wrgTI
Date: Fri, 20 Jun 2014 07:42:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] cfq: Increase default value of target_latency
Message-ID: <20140619214214.GM4453@dastard>
References: <1403079807-24690-1-git-send-email-mgorman@suse.de>
 <1403079807-24690-2-git-send-email-mgorman@suse.de>
 <x49y4wslp6z.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49y4wslp6z.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 02:38:44PM -0400, Jeff Moyer wrote:
> Mel Gorman <mgorman@suse.de> writes:
> 
> > The existing CFQ default target_latency results in very poor performance
> > for larger numbers of threads doing sequential reads.  While this can be
> > easily described as a tuning problem for users, it is one that is tricky
> > to detect. This patch the default on the assumption that people with access
> > to expensive fast storage also know how to tune their IO scheduler.
> >
> > The following is from tiobench run on a mid-range desktop with a single
> > spinning disk.
> >
> >                                       3.16.0-rc1            3.16.0-rc1                 3.0.0
> >                                          vanilla          cfq600                     vanilla
> > Mean   SeqRead-MB/sec-1         121.88 (  0.00%)      121.60 ( -0.23%)      134.59 ( 10.42%)
> > Mean   SeqRead-MB/sec-2         101.99 (  0.00%)      102.35 (  0.36%)      122.59 ( 20.20%)
> > Mean   SeqRead-MB/sec-4          97.42 (  0.00%)       99.71 (  2.35%)      114.78 ( 17.82%)
> > Mean   SeqRead-MB/sec-8          83.39 (  0.00%)       90.39 (  8.39%)      100.14 ( 20.09%)
> > Mean   SeqRead-MB/sec-16         68.90 (  0.00%)       77.29 ( 12.18%)       81.64 ( 18.50%)
> 
> Did you test any workloads other than this?  Also, what normal workload
> has 8 or more threads doing sequential reads?  (That's an honest
> question.)

I'd also suggest that making changes basd on the assumption that
people affected by the change know how to tune CFQ is a bad idea.
When CFQ misbehaves, most people just switch to deadline or no-op
because they don't understand how CFQ works, nor what what all the
nobs do or which ones to tweak to solve their problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
