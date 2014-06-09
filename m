Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbaFIQTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:19:48 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57665 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbaFIQTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:19:45 -0400
Message-ID: <5395DEA4.90000@kernel.dk>
Date: Mon, 09 Jun 2014 10:19:48 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: add timer in blk_mq_start_request
References: <1402330601-12837-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1402330601-12837-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 10:16 AM, Ming Lei wrote:
> This way will become consistent with non-mq case, also
> avoid to update rq->deadline twice for mq.
> 
> The comment said: "We do this early, to ensure we are on
> the right CPU.", but no percpu stuff is used in blk_add_timer(),
> so it isn't necessary. Even when inserting from plug list, there
> is no such guarantee at all.

Thanks, this is a good cleanup. That particular comment predates the
strict mappings of the queues, so it doesn't apply anymore anyway.

-- 
Jens Axboe

