Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3JYKV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:21:58 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:65211 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab3JYKV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:21:57 -0400
Date: Fri, 25 Oct 2013 12:21:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 01/11] Export __smp_call_function_single()
Message-ID: <20131025102154.GB3481@gmail.com>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
 <1382606764-8309-2-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382606764-8309-2-git-send-email-axboe@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <axboe@kernel.dk> wrote:

> The blk-mq core and the blk-mq null driver uses it.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  kernel/smp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 0564571..9de461e 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -340,6 +340,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *csd,
>  	}
>  	put_cpu();
>  }
> +EXPORT_SYMBOL(__smp_call_function_single);

I agree with exporting it to in-kernel users, but I'd prefer a _GPL 
export for newly exported symbols that are for in-kernel use.

Thanks,

	Ingo
