Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaFJVL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:11:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:44980 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbaFJVLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:11:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="353241935"
Date: Tue, 10 Jun 2014 15:10:16 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Jens Axboe <axboe@fb.com>
cc: Keith Busch <keith.busch@intel.com>,
        =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>,
        "willy@linux.intel.com" <willy@linux.intel.com>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
In-Reply-To: <5397636F.9050209@fb.com>
Message-ID: <alpine.LRH.2.03.1406101458470.4699@AMR>
References: <1402392038-5268-1-git-send-email-m@bjorling.me> <1402392038-5268-2-git-send-email-m@bjorling.me>,<alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com> <alpine.LRH.2.03.1406101140490.4699@AMR>
 <5397636F.9050209@fb.com>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Jens Axboe wrote:
> On 06/10/2014 01:29 PM, Keith Busch wrote:
>> I have two devices, one formatted 4k, the other 512. The 4k is used as
>> the TEST_DEV and 512 is used as SCRATCH_DEV. I'm always hitting a BUG when
>> unmounting the scratch dev in xfstests generic/068. The bug looks like
>> nvme was trying to use an SGL that doesn't map correctly to a PRP.
>
> I'm guessing it's some of the coalescing settings, since the driver is
> now using the generic block rq mapping.

Ok, sounds right. I mentioned in a way earlier review it doesn't look
like a request that doesn't conform to a PRP list would get split anymore,
and this test seems to confirm that.

Can we create something that will allow a driver to add DMA constraints to
a request queue with the rules of a PRP list?
