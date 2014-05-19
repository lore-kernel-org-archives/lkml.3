Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaESPeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:34:44 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:40210 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaESPen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:34:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140519151824.GA21762@lst.de>
References: <1400511950-18522-1-git-send-email-tom.leiming@gmail.com>
	<20140519151824.GA21762@lst.de>
Date: Mon, 19 May 2014 23:34:42 +0800
Message-ID: <CACVXFVPgMBoEa-Q1WaCVeq5_3kJCPfCt=LZ=pGQxmJv4EnTMoQ@mail.gmail.com>
Subject: Re: [PATCH] block: mq flush: fix race between IPI handler and mq
 flush worker
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 11:18 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, May 19, 2014 at 11:05:50PM +0800, Ming Lei wrote:
>> Another simple fix is to disable ipi for flush request, but looks
>> this one should be better.
>
> I think the first thing is to bite the bullet and sort out and document
> the various unions in struct request for real.

I agree, unions should be documented in detail.

>
> For example the first union has the call_single_data for the blk-mq

blk-softirq need rq->csd too in raise_blk_irq().

> completions, while the second one has the ipi_list that is used by
> the old blk-softirq code.

Also we can put some mq specific fields and legacy fields into
one union too.

>
> If we get this right with a single union that contains a struct for
> each phase of the request we might find enough space to keep using
> the current way.

If we can figure it out, that should be better solution, but changing/
merging fields may affect performance too, and need careful
verification.

Thanks,
-- 
Ming Lei
