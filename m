Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbaEPPc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:32:58 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:38708 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbaEPPc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:32:56 -0400
Message-ID: <53762FA5.6040203@kernel.dk>
Date: Fri, 16 May 2014 09:32:53 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v1] virtio_blk: fix race between start and stop queue
References: <1400254281-11294-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1400254281-11294-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-16 09:31, Ming Lei wrote:
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

Thanks, this looks good, I'll apply it for 3.16 (with a stable marker, 
even if it is an unlikely event).

-- 
Jens Axboe

