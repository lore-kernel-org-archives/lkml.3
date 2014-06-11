Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaFKRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:09:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:38501 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaFKRJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:09:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,459,1400050800"; 
   d="scan'208";a="526938857"
Date: Wed, 11 Jun 2014 13:09:17 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jens Axboe <axboe@fb.com>
Cc: Keith Busch <keith.busch@intel.com>,
        Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
Message-ID: <20140611170917.GA12025@linux.intel.com>
References: <1402392038-5268-2-git-send-email-m@bjorling.me>
 <alpine.LRH.2.03.1406100945250.4699@AMR>
 <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com>
 <alpine.LRH.2.03.1406101140490.4699@AMR>
 <5397636F.9050209@fb.com>
 <alpine.LRH.2.03.1406101458470.4699@AMR>
 <5397753B.2020009@fb.com>
 <alpine.LRH.2.03.1406101515430.4699@AMR>
 <20140610213333.GA10055@linux.intel.com>
 <539889DC.7090704@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539889DC.7090704@fb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:54:52AM -0600, Jens Axboe wrote:
> OK, so essentially any single request must be a virtually contig piece
> of memory. Is there any size limitations to how big this contig segment
> can be?

The maximum size of an I/O is 65536 sectors.  So on a 512-byte sector
device, that's 32MB, but on a 4k sector size device, that's 128MB.

> I think this is unique requirement, at least I haven't seen other pieces
> of hardware have it. But it would be pretty trivial to add a setting to
> limit merges based on virtually contig, similarly to what is done for
> number of physical segments.

I think there might be an FCoE device with that requirement too.
