Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab3CYMkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:40:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58929 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab3CYMkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:40:11 -0400
Date: Mon, 25 Mar 2013 06:40:07 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Alex.Lemberg@sandisk.com, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] block: Add API for urgent request handling
Message-ID: <20130325124007.GH22327@kernel.dk>
References: <1364202178-8936-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364202178-8936-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25 2013, Tanya Brokhman wrote:
> This patch add support in block & elevator layers for handling
> urgent requests. The decision if a request is urgent or not is taken
> by the scheduler. Request is marked as urgent in cmd_flags (by the
> scheduler) with a new flag - REQ_URGENT.
> Urgent request notification is passed to the underlying
> block device driver (eMMC for example). Block device driver may decide to
> interrupt the currently running low priority request to serve the new
> urgent request. By doing so READ latency is greatly reduced in read&write
> collision scenarios.
> 
> Note that if the current scheduler doesn't implement the urgent request
> mechanism, this code path is never activated.

I really don't like this out-of-band mechanism. Lets say there is an
urgent request, the IO scheduler would put that at the head of the
queue. So the first time the driver fetches a request, it'll see this
urgent request. A driver that has support for this, would check the head
of queue everytime its request_fn was invoked. There's no need to add a
elevator_is_urgent_fn() and ->notified_urgent.

-- 
Jens Axboe

