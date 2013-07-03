Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3GCLZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:25:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36848 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3GCLZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:25:46 -0400
Date: Wed, 3 Jul 2013 13:25:44 +0200
From: Jens Axboe <axboe@kernel.dk>
To: majianpeng <majianpeng@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1] elevator: Fix a race about elevator switching.
Message-ID: <20130703112544.GG6694@kernel.dk>
References: <201307011851511379161@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201307011851511379161@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01 2013, majianpeng wrote:
> Thare's a race between elevator switching and normal io operation.
>     Because the allocation of struct elevator_queue and struct elevator_data
>     don't in a atomic operation.So there are have chance to use NULL
>     ->elevator_data.
>     For example:
>         Thread A:                               Thread B
>         blk_queu_bio                            elevator_switch
>         spin_lock_irq(q->queue_block)           elevator_alloc
>         elv_merge                               elevator_init_fn
>     
>     Because call elevator_alloc, it can't hold queue_lock and the
>     ->elevator_data is NULL.So at the same time, threadA call elv_merge and
>     nedd some info of elevator_data.So the crash happened.
>     
>     Move the elevator_alloc into func elevator_init_fn, it make the
>     operations in a atomic operation.
>     
>     Using the follow method can easy reproduce this bug
>     1:dd if=/dev/sdb of=/dev/null
>     2:while true;do echo noop > scheduler;echo deadline > scheduler;done
>     
>     The test method also use this method.

Applied, thanks.

-- 
Jens Axboe

