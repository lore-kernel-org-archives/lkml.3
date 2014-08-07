Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbaHGNv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:51:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334AbaHGNvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:51:25 -0400
Date: Thu, 7 Aug 2014 15:51:10 +0200
From: Karel Zak <kzak@redhat.com>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        Boaz Harrosh <boaz@plexistor.com>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/4] brd: Request from fdisk 4k alignment
Message-ID: <20140807135110.GC9401@x2.net.home>
References: <53E21125.9080308@plexistor.com>
 <53E21317.7080403@plexistor.com>
 <1407362634.2869.2.camel@rzwisler-mobl1.amr.corp.intel.com>
 <53E36E53.3090008@gmail.com>
 <20140807130042.GB9401@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807130042.GB9401@x2.net.home>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 03:00:42PM +0200, Karel Zak wrote:
> On Thu, Aug 07, 2014 at 03:17:23PM +0300, Boaz Harrosh wrote:
> 
> > > Is there an error case that this patch fixes?  I've had page alignment checks
> > > in my PRD direct_access code forever, and I don't know if they've ever
> > > tripped.  
> > > 
> > 
> > Yes! as I said above fix fdisk. You never tripped on it because partitions never
> > worked and you never tried them. With current code fdisk is very trigger happy
> 
>  What do you mean with fdisk? which version?

Oh, I read all your email more carefully now, and if I good understand
the problem is what I/O limits the device provides to userspace rather
than with fdisk.

Anyway, I think you're right that alignment_offset is not the right
thing. It was introduced for backward compatibility with DOS-like
partitioning tools (~magical sector 63). I have doubts it's usable for
something else. For normal use-case should be enough to set proper
phy-sector size or min/optimal I/O limits (e.g. zram has all the
limits set to 4K(PAGE_SIZE)).

$ lsblk --topology /dev/zram0
NAME  ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
zram0         0   4096   4096    4096    4096    0           128 128 0B

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
