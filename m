Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaDYOXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:23:53 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38119 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaDYOXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:23:49 -0400
Message-ID: <535A6FF1.6070805@kernel.dk>
Date: Fri, 25 Apr 2014 08:23:45 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: respect rq_affinity
References: <94D0CD8314A33A4D9D801C0FE68B402956EDDA26@G9W0745.americas.hpqcorp.net> <53592665.8050406@kernel.dk> <20140425053018.GA30957@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402956EDE0D8@G9W0745.americas.hpqcorp.net> <20140425071659.GA15384@infradead.org> <20140425093253.GA18345@infradead.org>
In-Reply-To: <20140425093253.GA18345@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 03:32 AM, Christoph Hellwig wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> The blk-mq code is using it's own version of the I/O completion affinity
> tunables, which causes a few issues:
> 
>  - the rq_affinity sysfs file doesn't work for blk-mq devices, even if it
>    still is present, thus breaking existing tuning setups.
>  - the rq_affinity = 1 mode, which is the defauly for legacy request based
>    drivers isn't implemented at all.
>  - blk-mq drivers don't implement any completion affinity with the default
>    flag settings.
> 
> This patches removes the blk-mq ipi_redirect flag and sysfs file, as well
> as the internal BLK_MQ_F_SHOULD_IPI flag and replaces it with code that
> respects the queue-wide rq_affinity flags and also implements the
> rq_affinity = 1 mode.
> 
> This means I/O completion affinity can now only be tuned block-queue wide
> instead of per context, which seems more sensible to me anyway.

Agree, this is a good cleanup, and there's no reason blk-mq needs its
own sysfs file for this.

-- 
Jens Axboe

