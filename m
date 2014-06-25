Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaFYCmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 22:42:10 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:54776 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaFYCmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 22:42:09 -0400
MIME-Version: 1.0
In-Reply-To: <1403621588-25109-1-git-send-email-tom.leiming@gmail.com>
References: <1403621588-25109-1-git-send-email-tom.leiming@gmail.com>
Date: Wed, 25 Jun 2014 10:42:08 +0800
Message-ID: <CACVXFVMWDBEhRhKQ1V2O9sWbAdQNb_RM0Nz_BA7Cn7P_OrvndQ@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: run hw queue asynchronously in blk_mq_start_hw_queues
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ming Lei <tom.leiming@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 10:53 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> From API view, it isn't good to run all hw queues synchronously
> in one context, since it isn't correct for multi hw queue case.
>
> So this patch adds 'async' parameter to blk_mq_start_hw_queue(),
> and make blk_mq_start_hw_queues() to run hw queues asynchronously
> at default.

BTW, without the change, it is easy to trigger the WARN_ON() in
__blk_mq_run_hw_queue().

Thanks,
-- 
Ming Lei
