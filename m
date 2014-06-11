Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaFKWW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:22:59 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:44238 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaFKWW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:22:57 -0400
MIME-Version: 1.0
X-Originating-IP: [80.196.35.44]
In-Reply-To: <20140611170917.GA12025@linux.intel.com>
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
	<20140611170917.GA12025@linux.intel.com>
Date: Thu, 12 Jun 2014 00:22:57 +0200
Message-ID: <CAOu_J6kocZZ1mRQeSidyqJ_Ew0F_POS30v2kgUZX2wDOOnuExg@mail.gmail.com>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
From: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jens Axboe <axboe@fb.com>, Keith Busch <keith.busch@intel.com>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 7:09 PM, Matthew Wilcox <willy@linux.intel.com> wrote:
> On Wed, Jun 11, 2014 at 10:54:52AM -0600, Jens Axboe wrote:
>> OK, so essentially any single request must be a virtually contig piece
>> of memory. Is there any size limitations to how big this contig segment
>> can be?
>
> The maximum size of an I/O is 65536 sectors.  So on a 512-byte sector
> device, that's 32MB, but on a 4k sector size device, that's 128MB.
>
>> I think this is unique requirement, at least I haven't seen other pieces
>> of hardware have it. But it would be pretty trivial to add a setting to
>> limit merges based on virtually contig, similarly to what is done for
>> number of physical segments.
>
> I think there might be an FCoE device with that requirement too.

I've rebased nvmemq_review and added two patches from Jens that add
support for requests with single range virtual addresses.

Keith, will you take it for a spin and see if it fixes 068 for you?

There might still be a problem with some flushes, I'm looking into this.
