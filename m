Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaFJVdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:33:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:18255 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbaFJVdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:33:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="353256278"
Date: Tue, 10 Jun 2014 17:33:33 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@fb.com>,
        Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
Message-ID: <20140610213333.GA10055@linux.intel.com>
References: <1402392038-5268-1-git-send-email-m@bjorling.me>
 <1402392038-5268-2-git-send-email-m@bjorling.me>
 <alpine.LRH.2.03.1406100945250.4699@AMR>
 <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com>
 <alpine.LRH.2.03.1406101140490.4699@AMR>
 <5397636F.9050209@fb.com>
 <alpine.LRH.2.03.1406101458470.4699@AMR>
 <5397753B.2020009@fb.com>
 <alpine.LRH.2.03.1406101515430.4699@AMR>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.03.1406101515430.4699@AMR>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 03:21:18PM -0600, Keith Busch wrote:
> Yeah, nvme_setup_prps is probably the least readable code in this driver.
> Maybe some comments are in order here...
> 
> There are two rules for an SGL to be mappable to a PRP:
> 
> 1. Every element must have zero page offset, except the first.
> 
> 2. Every element must end on a page boundary, except the last.

Or to put it another way, NVMe PRPs only support I/Os that describe a
single range of virtual memory.

