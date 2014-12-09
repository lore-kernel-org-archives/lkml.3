Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbaLIE4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 23:56:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56746 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551AbaLIE4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 23:56:30 -0500
MIME-Version: 1.0
In-Reply-To: <54867CFA.8040304@fb.com>
References: <1417606684-20907-1-git-send-email-ming.lei@canonical.com>
	<CACVXFVMzQ8TkxsiUujUZR0E=0Lx=BtZ2BsLmhCTHk8D9dr8rag@mail.gmail.com>
	<54867CFA.8040304@fb.com>
Date: Tue, 9 Dec 2014 12:56:27 +0800
Message-ID: <CACVXFVMULejnsWR+Deya9G1SS797HtoZqvSYgo0E+jWqrAzGmA@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: prevent unmapped hw queue from being scheduled
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 12:39 PM, Jens Axboe <axboe@fb.com> wrote:
> On 12/08/2014 05:41 PM, Ming Lei wrote:
>
>
> Picked up for 3.19, sorry for the delay. I'm curious how this queue gets

Thanks!

> scheduled, though. My worry here would be that we are masking a bug that
> should be fixed separately.

That is because the schedule unit of following interfaces is
per request_queue, and they are easily used in drivers now:

   blk_mq_start_hw_queues()
   blk_mq_start_stopped_hw_queues()
   blk_mq_kick_requeue_list().

Thanks,
Ming Lei
