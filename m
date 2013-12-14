Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab3LNBzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 20:55:22 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:59957 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224Ab3LNBzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 20:55:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEIAEW5q1J5LHyk/2dsb2JhbABZgwqDPLBihU+BIRd0giUBAQU6HCMQCAMYCSUPBSUDIROIA8puFxaOHREBUAeENgSYFZIVgz4ogTU
Date: Sat, 14 Dec 2013 12:55:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nigel Cunningham <nigel@nigelcunningham.com.au>
Cc: Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system
 is frozen
Message-ID: <20131214015518.GQ31386@dastard>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131213185237.GD27070@htj.dyndns.org>
 <20131213204034.GE27070@htj.dyndns.org>
 <52AB8E27.90308@nigelcunningham.com.au>
 <20131213230744.GA17954@htj.dyndns.org>
 <52AB9509.1080004@nigelcunningham.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AB9509.1080004@nigelcunningham.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 10:15:21AM +1100, Nigel Cunningham wrote:
> Hi again.
> 
> On 14/12/13 10:07, Tejun Heo wrote:
> >Hello, Nigel.
> >
> >On Sat, Dec 14, 2013 at 09:45:59AM +1100, Nigel Cunningham wrote:
> >>In your first email, in the first substantial paragraph (starting
> >>"Now, if the rest.."), you say "libata device removal waits for the
> >>scheduled writeback work item to finish". I wonder if that's the
> >>lynchpin. If we know the device is gone, why are we trying to write
> >>to it?
> >It's just a standard part of block device removal -
> >invalidate_partition(), bdi_wb_shutdown().
> Mmm. But perhaps there needs to be some special code in there to
> handle the "we can't write to this device anymore" case?

I've been asking for that "special code" for years, Nigel... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
