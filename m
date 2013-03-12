Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab3CLWE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:04:58 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35632 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755190Ab3CLWE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:04:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsodAOGlP1F5LKiV/2dsb2JhbABDhy64KYUaAQIBgUoXdIIpAQEFOhwjEAgDGAklDwUlAyETiBPBXBWNdxgfSgeDQAOWVZB3gS+Bbyg
Date: Wed, 13 Mar 2013 09:04:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sander <sander@humilis.net>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: torrent hash failures since 3.9.0-rc1
Message-ID: <20130312220452.GR21651@dastard>
References: <20130311171824.GA434@x4>
 <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
 <20130311203738.GB15478@thunk.org>
 <20130311204625.GA433@x4>
 <20130312082854.GA1515@panda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312082854.GA1515@panda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 09:28:54AM +0100, Sander wrote:
> Markus Trippelsdorf wrote (ao):
> > On 2013.03.11 at 16:37 -0400, Theodore Ts'o wrote:
> > > We actually run fsx in a number of different configruations as part of
> > > our regression testing before we send Linus a pull request, and
> > > haven't found any issues.  So unless it's a hardware problem, it seems
> > > unlikely to me that your running fsx would turn up anything.
> > 
> > Yes, I let it run for a while anyway and it didn't report any failure.
> 
> > Please note that my local rtorrent version was configured with
> > "--with-posix-fallocate".
> 
> Would it be possible to enhance fsx to detect such an issue?

fsx in xfstests already uses fallocate() for preallocation and hole
punching, so such problems related to these operations can be found
using fsx. The issue here, however, involves memory reclaim
interactions and so is not something fsx can reproduce in isolation.  :/


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
