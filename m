Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab3JIPsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 11:48:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:35828 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab3JIPsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 11:48:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1064,1371106800"; 
   d="scan'208";a="416714764"
Date: Wed, 9 Oct 2013 09:48:17 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@linux.intel.com>,
        =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] Convert from bio-based to blk-mq
In-Reply-To: <20131008183949.GB23288@kernel.dk>
Message-ID: <alpine.LRH.2.03.1310090921220.4763@AMR>
References: <1381224862-5299-1-git-send-email-m@bjorling.me> <20131008131036.GC7422@linux.intel.com> <20131008183949.GB23288@kernel.dk>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1934113754-1381333702=:4763"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1934113754-1381333702=:4763
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 8 Oct 2013, Jens Axboe wrote:
> On Tue, Oct 08 2013, Matthew Wilcox wrote:
>> On Tue, Oct 08, 2013 at 11:34:20AM +0200, Matias Bjørling wrote:
>>> The nvme driver implements itself as a bio-based driver. This primarily because
>>> of high lock congestion for high-performance nvm devices. To remove the
>>> congestion, a multi-queue block layer is being implemented.
>>
>> Um, no.  You'll crater performance by adding another memory allocation
>> (of the struct request).  multi-queue is not the solution.
>
> That's a rather "jump to conclusions" statement to make. As Matias
> mentioned, there are no extra fast path allocations. Once the tagging is
> converted as well, I'd be surprised if it performs worse than before.
> And that on top of a net reduction in code.
>
> blk-mq might not be perfect as it stands, but it's a helluva lot better
> than a bunch of flash based drivers with lots of duplicated code and
> mechanisms. We need to move away from that.
>
> -- 
> Jens Axboe

But this wastes copious amounts of memory on an NVMe device with more
than 1 namespace. The hardware's queues are shared among all namespaces,
so you can't possibly have all the struct requests in use. What would
be better is if I can create one blk-mq for each device/host and attach
multiple gendisks to that.
--8323328-1934113754-1381333702=:4763--
