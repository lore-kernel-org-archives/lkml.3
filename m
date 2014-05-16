Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbaEPOx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:53:27 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:41497 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbaEPOxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:53:25 -0400
Message-ID: <53762662.2050702@kernel.dk>
Date: Fri, 16 May 2014 08:53:22 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio_blk: fix race between start and stop queue
References: <1400157181-17800-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1400157181-17800-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-15 06:33, Ming Lei wrote:
> When there isn't enough vring descriptor for adding to vq,
> blk-mq will be put as stopped state until some of pending
> descriptors are completed & freed.
>
> Unfortunately, the vq's interrupt may come just before
> blk-mq's BLK_MQ_S_STOPPED flag is set, so the blk-mq will
> still be kept as stopped even though lots of descriptors
> are completed and freed in the interrupt handler. The worst
> case is that all pending descriptors are freed in the
> interrupt handler, and the queue is kept as stopped forever.
>
> This patch fixes the problem by starting/stopping blk-mq
> with holding vq_lock.

Why not just use blk_mq_start_hw_queues()?

-- 
Jens Axboe

