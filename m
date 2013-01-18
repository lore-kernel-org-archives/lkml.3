Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3ARV01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:26:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34205 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3ARV0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:26:22 -0500
Date: Fri, 18 Jan 2013 13:25:43 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: Amit Kale <akale@stec-inc.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        lsf-pc@lists.linux-foundation.org
Subject: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC EnhanceIO SSD
 caching software for Linux kernel
Message-ID: <20130118212543.GB6425@blackbox.djwong.org>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD>
 <20130117132620.GA2438@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD>
 <50F844A3.9020300@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
 <50F970A3.4000403@warr.net>
 <20130118161135.GA3118@raspberrypi>
 <50F97C0F.9010405@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7345@MYMBX.MY.STEC-INC.AD>
 <50F9963A.2080608@warr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F9963A.2080608@warr.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Joe is putting together a testing tree to compare the three caching
things, what do you all think of having a(nother) session about ssd caching at
this year's LSFMM Summit?

[Apologies for hijacking the thread.]
[Adding lsf-pc to the cc list.]

--D

On Fri, Jan 18, 2013 at 12:36:42PM -0600, Jason Warr wrote:
> 
> On 01/18/2013 11:44 AM, Amit Kale wrote:
> >> As much as I dislike Oracle that is one of my primary applications.  I
> >> > am attempting to get one of my customers to setup an Oracle instance
> >> > that is modular in that I can move the storage around to fit a
> >> > particular hardware setup and have a consistent benchmark that they use
> >> > in the real world to gauge performance.  One of them is a debit card
> >> > transaction clearing entity on multi-TB databases so latency REALLY
> >> > matters there.  
> > I am curious as to how SSD latency matters so much in the overall transaction times.
> >
> > We do a lot of performance measurements using SQL database benchmarks. Transaction times vary a lot depending on location of data, complexity of the transaction etc. Typically TPM (transactions per minute) is of primary interest for TPC-C.
> >
> 
> It's not specifically SSD latency.  It's I/O transaction latency that
> matters.  This particular application is very sensitive to that because
> it is literally someone standing at a POS terminal swiping a
> debit/credit card.  You only have a couple of seconds after the PIN is
> entered for the transaction to go through your network, application
> server to authorize against a DB and back to the POS.
> 
> The entire I/O stack on the DB is only a small time-slice of that round
> trip.  Your 99th percentile needs to be under 20ms on the DB storage
> side.  If your worst case DB I/O goes beyond 300ms it is considered an
> outage because the POS transaction fails.  So it obviously takes allot
> of planning and optimization work on the DB itself to get good
> tablespace layout to even get into the realm where you can have that
> predictable of latency with multi-million dollar FC storage frames. 
> 
> One of my goals is to be able to offer this level of I/O service on
> commodity hardware.  Simplify the scope of hardware, reduce the number
> of points of failure, make the systems more portable, reduce or
> eliminate dependence on any specific vendor below the application and
> save money.  Not to mention reduce the number of fingers that can point
> away from themselves saying it is someone elses problem to find fault.
> 
> Allot of the pieces are already out there.  A good block caching target
> is one of the missing pieces to help fill the ever growing canyon
> between non-block device system performance and storage.  What they have
> done with L2ARC and SLOG in ZFS/Solaris is good but it has some serious
> short comings in other areas that DM/MD/LVM do extremely well.
> 
> I appreciate all of the brilliant work all of you guys do and hopefully
> I can contribute a little bit of usefulness to this effort.
> 
> Thank you,
> 
> Jason
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
