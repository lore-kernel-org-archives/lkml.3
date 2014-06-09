Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbaFIO7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:59:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45312 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaFIO7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:59:51 -0400
Date: Mon, 9 Jun 2014 07:59:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@fb.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Matias Bj??rling <m@bjorling.me>,
        willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v6] NVMe: conversion to blk-mq
Message-ID: <20140609145944.GA30626@infradead.org>
References: <1402057225-7312-1-git-send-email-m@bjorling.me>
 <1402057225-7312-2-git-send-email-m@bjorling.me>
 <CACVXFVOieM2cT4FFJhD9MecfCLBtE3AwjCpOeGGRUcmWnN=B=A@mail.gmail.com>
 <5395BFF2.2080402@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5395BFF2.2080402@fb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 08:08:50AM -0600, Jens Axboe wrote:
> >[  487.704074] nvme 0000:00:07.0: Cancelling I/O 202 QID 1
> >[  487.717881] nvme 0000:00:07.0: Aborting I/O 202 QID 1
> >[  487.736093] end_request: I/O error, dev nvme0n1, sector 91532352
> >[  487.747378] nvme 0000:00:07.0: completed id 0 twice on queue 0
> >
> >
> >when running fio randread(libaio, iodepth:64) with more than 3 jobs.
> >
> >And looks no such failure when jobs is 1 or 2.
> 
> It's a known issue, make sure you have this patch:
> 
> http://git.kernel.dk/?p=linux-block.git;a=commit;h=f6be4fb4bcb396fc3b1c134b7863351972de081f

So without this patch we can get duplicate completions?  That could
explain the issues that Robert sees with scsi-mq and hpsa..

