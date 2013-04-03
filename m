Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089Ab3DCLlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:41:55 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46261
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761996Ab3DCLlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:41:53 -0400
Date: Wed, 3 Apr 2013 13:41:42 +0200
From: Jens Axboe <axboe@kernel.dk>
To: CAI Qian <caiqian@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
        LKML <linux-kernel@vger.kernel.org>, psusi@ubuntu.com
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
 xfstests case #78]
Message-ID: <20130403114142.GP4667@kernel.dk>
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com>
 <247719576.438259.1364882929749.JavaMail.root@redhat.com>
 <20130402070537.GP6369@dastard>
 <20130402071937.GC3670@kernel.dk>
 <20130402073035.GD3670@kernel.dk>
 <14055702.547701.1364891947331.JavaMail.root@redhat.com>
 <20130402090047.GF3670@kernel.dk>
 <985125161.581860.1364895066584.JavaMail.root@redhat.com>
 <20130402094834.GA4667@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402094834.GA4667@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02 2013, Jens Axboe wrote:
> On Tue, Apr 02 2013, CAI Qian wrote:
> > 
> > 
> > ----- Original Message -----
> > > From: "Jens Axboe" <axboe@kernel.dk>
> > > To: "CAI Qian" <caiqian@redhat.com>
> > > Cc: "Dave Chinner" <david@fromorbit.com>, xfs@oss.sgi.com, "LKML" <linux-kernel@vger.kernel.org>
> > > Sent: Tuesday, April 2, 2013 5:00:47 PM
> > > Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running xfstests case #78]
> > > 
> > > On Tue, Apr 02 2013, CAI Qian wrote:
> > > > 
> > > > 
> > > > ----- Original Message -----
> > > > > From: "Jens Axboe" <axboe@kernel.dk>
> > > > > To: "Dave Chinner" <david@fromorbit.com>
> > > > > Cc: "CAI Qian" <caiqian@redhat.com>, xfs@oss.sgi.com, "LKML"
> > > > > <linux-kernel@vger.kernel.org>
> > > > > Sent: Tuesday, April 2, 2013 3:30:35 PM
> > > > > Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5
> > > > > running xfstests case #78]
> > > > > 
> > > > > On Tue, Apr 02 2013, Jens Axboe wrote:
> > > > > > On Tue, Apr 02 2013, Dave Chinner wrote:
> > > > > > > [Added jens Axboe to CC]
> > > > > > > 
> > > > > > > On Tue, Apr 02, 2013 at 02:08:49AM -0400, CAI Qian wrote:
> > > > > > > > Saw on almost all the servers range from x64, ppc64 and s390x with
> > > > > > > > kernel
> > > > > > > > 3.9-rc5 and xfsprogs-3.1.10. Never caught this in 3.9-rc4, so looks
> > > > > > > > like
> > > > > > > > something new broke this. Log is here with sysrq debug info.
> > > > > > > > http://people.redhat.com/qcai/stable/log
> > > > > > 
> > > > > > CAI Qian, can you try and back the below out and test again?
> > > > > 
> > > > > Nevermind, it's clearly that one. The below should improve the
> > > > > situation, but it's not pretty. A better fix would be to allow
> > > > > auto-deletion even if PART_NO_SCAN is set.
> > > > Jens, when compiled the mainline (up to fefcdbe) with this patch,
> > > > it error-ed out,
> > > 
> > > Looks like I sent the wrong one, updated below.
> > The patch works well. Thanks!
> 
> Thanks for testing! I don't particularly like this stuff in loop,
> though. It's quite nasty and depends on other behaviour. It would be
> prettier if we just had rescan_partitions() do the right thing, and only
> drop partitions and not rescan if NO_PART_SCAN is set.
> 
> Ala the below, dropping the loop change and implementing that change in
> the core code. Phillip, can you check whether this does the right thing
> for your bug too?

Phillip? I'm going to revert the loop change asap, so if you want this
fixed for 3.10, it's about that time to test it out.

-- 
Jens Axboe

