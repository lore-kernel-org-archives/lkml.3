Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbaISOL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:11:57 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52981 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaISOL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:11:56 -0400
Message-ID: <541C39BB.8010804@kernel.dk>
Date: Fri, 19 Sep 2014 08:12:11 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] blk-timeout: fix blk_add_timer
References: <1411134826-6772-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1411134826-6772-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 07:53 AM, Ming Lei wrote:
> Commit 8cb34819cdd5d(blk-mq: unshared timeout handler) introduces
> blk-mq's own timeout handler, and removes following line
> 
> 	blk_queue_rq_timed_out(q, blk_mq_rq_timed_out);
> 
> then cause blk_add_timer() to do nop in case of blk-mq.
> 
> This patch fixes the problem by bypassing the check for blk-mq.

Good catch, this explains something I ran into yesterday on a missing
timer. I had a hard time understanding your description here, I'll
reword it a little bit and apply. Thanks!

-- 
Jens Axboe

