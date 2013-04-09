Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936820Ab3DIHIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:08:53 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:46045 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935060Ab3DIHIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:08:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AggUABq+Y1F5LPOF/2dsb2JhbABRgwaCeLlehRoEAYEQF3SCHwEBBTocIxAIAxgJJQ8FJQMhE4gTrXOQLxWNcIEdB4NBA5ZzkQ6BVYFIKg
Date: Tue, 9 Apr 2013 17:08:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Phillip Susi <psusi@ubuntu.com>, CAI Qian <caiqian@redhat.com>,
        xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
 xfstests case #78]
Message-ID: <20130409070832.GI17758@dastard>
References: <20130402073035.GD3670@kernel.dk>
 <14055702.547701.1364891947331.JavaMail.root@redhat.com>
 <20130402090047.GF3670@kernel.dk>
 <985125161.581860.1364895066584.JavaMail.root@redhat.com>
 <20130402094834.GA4667@kernel.dk>
 <20130403114142.GP4667@kernel.dk>
 <515C4D9D.10103@ubuntu.com>
 <515DE2FE.1080201@ubuntu.com>
 <20130409065519.GH17758@dastard>
 <20130409070139.GS12244@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409070139.GS12244@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 09:01:39AM +0200, Jens Axboe wrote:
> On Tue, Apr 09 2013, Dave Chinner wrote:
> > On Thu, Apr 04, 2013 at 04:30:54PM -0400, Phillip Susi wrote:
> > > > I have not tested it yet, but I am pretty sure it won't work.  It
> > > > looks like the patch changes the BLKRRPART path to go ahead and remove
> > > > existing partitions when GENHD_FL_NO_PARTSCAN is set.  loop doesn't
> > > > issue the BLKRRPART ioctl when !LO_FLAGS_PARTSCAN so this won't help.
> > > >  I think loop needs to set GENHD_FL_NO_PARTSCAN and then issue the
> > > > ioctl regardless of the LO_FLAGS_PARTSCAN flag to get the partitions
> > > > to be removed.  I will try to test tonight.
> > > 
> > > After testing, my initial thoughts appeared to have been correct.  I had
> > > to modify the patch as follows.  To test, simply do:
> > > 
> > > truncate -s 10m img
> > > losetup /dev/loop0 img
> > > parted /dev/loop0
> > > mklabel msdos
> > > mkpart primary ext2 1m 2m
> > > quit
> > > ls /dev/loop0*
> > > 
> > > Note the /dev/loop0p1 node.  Run losetup -d /dev/loop0 and see if it is
> > > still there.
> > 
> > Jens, can we get one of these fixes merged quickly? xfstests is
> > unusable on any kernel more recent than 3.9-rc4 because of these
> > problems....
> 
> Yep, did the revert yesterday and it's going out today.

Great, I didn't see an update in the latest -rc, so I wanted to make
sure it hadn't fallen through he cracks....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
