Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaFFSz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:55:58 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:50630 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaFFSz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:55:57 -0400
Message-ID: <53920EBD.1010209@kernel.dk>
Date: Fri, 06 Jun 2014 12:55:57 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sam Bradshaw <sbradshaw@micron.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtip32xx: minor performance enhancements
References: <53921024.6080808@micron.com>
In-Reply-To: <53921024.6080808@micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 01:01 PM, Sam Bradshaw wrote:
> This patch adds the following:
> 
> 1) Compiler hinting in the fast path.
> 2) A prefetch of port->flags to eliminate moderate cpu stalling later 
> in mtip_hw_submit_io().
> 3) Eliminate a redundant rq_data_dir().
> 4) Reorder members of driver_data to eliminate false cacheline sharing 
> between irq_workers_active and unal_qdepth.
> 
> With some workload and topology configurations, I'm seeing ~1.5% 
> throughput improvement in small block random read benchmarks as well
> as improved latency std. dev.

Seems I got a small bump in peak perf as well. In any case, it's
innocuous, so should do no harm to apply.

-- 
Jens Axboe

