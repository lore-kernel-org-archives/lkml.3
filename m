Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbaEaNyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 09:54:08 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:56926 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390AbaEaNyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 09:54:07 -0400
Date: Sat, 31 May 2014 09:54:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 09/12] block, bfq: reduce latency during
 request-pool saturation
Message-ID: <20140531135402.GC24557@mtj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <1401354343-5527-10-git-send-email-paolo.valente@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401354343-5527-10-git-send-email-paolo.valente@unimore.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:05:40AM +0200, Paolo Valente wrote:
> This patch introduces an heuristic that reduces latency when the
> I/O-request pool is saturated. This goal is achieved by disabling
> device idling, for non-weight-raised queues, when there are weight-
> raised queues with pending or in-flight requests. In fact, as
> explained in more detail in the comment to the function
> bfq_bfqq_must_not_expire(), this reduces the rate at which processes
> associated with non-weight-raised queues grab requests from the pool,
> thereby increasing the probability that processes associated with
> weight-raised queues get a request immediately (or at least soon) when
> they need one.

Wouldn't it be more straight-forward to simply control how many
requests each queue consume by returning ELV_MQUEUE_NO?  Seeky ones do
benefit from larger number of requests in elevator but to only certain
number given the fifo timeout anyway and controlling that explicitly
would be a lot easier to anticipate the behavior of than playing
roulette with random request allocation failures.

Thanks.

-- 
tejun
