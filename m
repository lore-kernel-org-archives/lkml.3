Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaDOIM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:12:29 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:8208 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbaDOIMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:12:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtZeAGfpTFN5LEcvPGdsb2JhbABYgwaDUIULu1+BHxcDAQEBATg1giUBAQEEOhwVDhAIAxgJJQ8FJQMHLYd7zDIXFo5NBxaEIgSYYYpmiyMr
Date: Tue, 15 Apr 2014 18:11:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [regression, 3.15-rc1] vdso_gettimeofday hogs all my CPU
Message-ID: <20140415081158.GK15995@dastard>
References: <20140415075335.GE31578@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415075335.GE31578@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 05:53:36PM +1000, Dave Chinner wrote:
> Hi Peter,
> 
> I'm guessing that x86 vdso problems are in your area of expertise,
> if not can you point me at the right person to bug?

And you can ignore it. The VM wasn't running the kernel I thought it
was - it was an old kernel from half way through last week. A
3.15-rc1 kernel, which I'm now testing, doesn't show the regression:

FSUse%        Count         Size    Files/sec     App Overhead
     0      1600000            0     281779.0          9964735
     0      3200000            0     280343.0         10174512
     0      4800000            0     268615.2         11330160
     0      6400000            0     264782.4         11072193
.....

It shows all sorts of interesting new inode cache reclaim imbalances,
but other than that the peak performance is back to normal...

Sorry for the noise.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
