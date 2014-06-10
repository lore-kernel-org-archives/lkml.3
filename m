Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaFJLpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:45:49 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:53353 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaFJLps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:45:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140610112827.GA359@lst.de>
References: <1402375925-21720-1-git-send-email-tom.leiming@gmail.com>
	<20140610112827.GA359@lst.de>
Date: Tue, 10 Jun 2014 19:45:47 +0800
Message-ID: <CACVXFVNxSh7ryy2vfnoNYpvmnjU0+TcipgdZxJ3tDbu-RBY=zA@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: kick requeue list in blk_mq_requeue_request()
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 7:28 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Tue, Jun 10, 2014 at 12:52:05PM +0800, Ming Lei wrote:
>> blk_mq_requeue_request() should kick off the requeue list so
>> that the request can be scheduled to queue finally.
>>
>> In nvme conversion patch, blk_mq_requeue_request() is called
>> to requeue failed request from completion handler, this patch
>> fixes the issue and makes the block API working as expected.
>
> I've intentionally kepts the two separate so that we can batch operations
> and just do a single kick for multiple requeued commands.
>

OK, but the API name is a bit confusing, and that is easy to cause
misuse, like in nvme.

Also requeue one request in completion handler may be a
common case, so maybe it is better to let blk_mq_requeue_request()
handle both adding to request list and kicking off, and introduce
blk_mq_prep_requeue_req()(or better name) to batch operations.


Thanks,
-- 
Ming Lei
