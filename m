Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3JYWhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 18:37:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:39360 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab3JYWht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 18:37:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,573,1378882800"; 
   d="scan'208";a="417367322"
Date: Fri, 25 Oct 2013 23:37:42 +0100
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "Artem S. Tashkinov" <t.artem@lycos.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131025223742.GA31280@localhost>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <20131025091842.GA28681@thunk.org>
 <20131025022937.12623dcd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025022937.12623dcd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 02:29:37AM -0700, Andrew Morton wrote:
> On Fri, 25 Oct 2013 05:18:42 -0400 "Theodore Ts'o" <tytso@mit.edu> wrote:
> 
> > What I think would make sense is to dynamically measure the speed of
> > writeback, so that we can set these limits as a function of the device
> > speed.
> 
> We attempt to do this now - have a look through struct backing_dev_info.

To be exact, it's backing_dev_info.write_bandwidth which is estimated
in bdi_update_write_bandwidth() and exported as "BdiWriteBandwidth" in
debugfs file bdi.stats.

> Apparently all this stuff isn't working as desired (and perhaps as designed)
> in this case.  Will take a look after a return to normalcy ;)

Right. The write bandwidth estimation is only estimated and used when
background dirty threshold is reached and hence the disk is actively
doing writeback IO -- which is the case that we can do reasonable
estimation of the writeback bandwidth.

Note that this estimated BdiWriteBandwidth may better be named
"writeback" bandwidth because it may change depending on the workload
at the time -- eg. sequential vs. random writes; whether there are
parallel reads or direct IO competing the disk time.

BdiWriteBandwidth is only designed for use by the dirty throttling
logic and is not generally useful/reliable for other purposes.

It's a bit late and I'd like to carry the original question as
exercises in tomorrow's airplanes. :)

Thanks,
Fengguang
