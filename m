Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaHNQxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 12:53:45 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53179 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaHNQxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 12:53:43 -0400
Message-ID: <53ECE998.8070407@kernel.dk>
Date: Thu, 14 Aug 2014 10:53:44 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
CC: Zach Brown <zab@zabbo.net>, Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1 0/9] block & aio: kernel aio and loop mq conversion
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 09:50 AM, Ming Lei wrote:
> Hi,
> 
> The 1st two patches introduce kernel AIO support, most of
> is borrowed from Dave's work last year, and thanks to ITER_BVEC,
> it is much simper to implement kernel AIO now. AIO model
> is quite suitable for implementing kernel stuff, and can
> help improve both throughput and CPU utilization. Lots of
> kernel components should benefit from it, such as:
> 	- loop driver,
> 	- all kinds of kernel I/O target driver(SCSI, USB storage
> 	or UAS, ...)
> 	- kernel socket users might benefit from it too if socket
> 	AIO is mature
> 
> The following 6 patches convert current loop driver into blk-mq:
> 	- loop's scalability gets improved much
> 	- loop driver gets quite simplified, and the conversion can
> 	be throught as cleanup too
> 
> The 9th patch uses kernel AIO with O_DIRECT to improve loop's
> performance in single job situation, and avoid double cache
> issue for loop driver too.
> 
> With the change, loop block's performance can be doubled in my
> fio test(randread, single job, libaio). If more fio jobs are used,
> the throughput can be improved much more because of blk-mq.
> 
> Given loop is used quite widely, especially in VM environment,
> also the change is quite small, hope it can be merged finally.

Looks pretty damn good to me, even the kernel aio bits are nice and
simple. Do you have any numbers on loop performance before and after the
blk-mq conversion? Just curious.

-- 
Jens Axboe

