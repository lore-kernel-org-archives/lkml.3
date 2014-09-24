Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaIXOqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:46:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49271 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaIXOqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:46:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140924101850.GA19078@lst.de>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com>
	<1410786675-7761-3-git-send-email-ming.lei@canonical.com>
	<20140924101850.GA19078@lst.de>
Date: Wed, 24 Sep 2014 22:46:03 +0800
Message-ID: <CACVXFVMmU0P_C2HRMRXdAw=YqttyrM7dA=9jPppucTYzxHFPHw@mail.gmail.com>
Subject: Re: [PATCH v4 02/10] block: introduce blk_init_flush and its pair
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 6:18 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Sep 15, 2014 at 09:11:06PM +0800, Ming Lei wrote:
>> These two temporary functions are introduced for holding flush
>> initialization and de-initialization, so that we can
>> introduce 'flush queue' easier in the following patch. And
>> once 'flush queue' and its allocation/free functions are ready,
>> they will be removed for sake of code readability.
>
> Shouldn't we just do the mq work in this helper as well?  blk_mq_init_flush
> does exactly the same work, plus initializing a lock, which is harmless
> for the !mq case as well.

The initialization handler is just introduced for putting all initialization
into one place, then all will be put into blk_alloc_flush_queue() once
flush queue is introduced.

It is harmless to initialize mq lock for !mq, but may lose one benefit
of detecting misusing mq lock for !mq.

Thanks,
--
Ming Lei
