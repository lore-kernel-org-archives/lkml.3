Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaBZXHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:07:19 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54119 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaBZXHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:07:17 -0500
Date: Wed, 26 Feb 2014 15:07:14 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 3/3] percpu_ida: Sanity check initialization
 parameters
Message-ID: <20140226230714.GF11655@kmo>
References: <cover.1391688720.git.agordeev@redhat.com>
 <a883f10da60a023134928bd9be01b37e7c55df0d.1391688720.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a883f10da60a023134928bd9be01b37e7c55df0d.1391688720.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 01:24:55PM +0100, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Kent Overstreet <kmo@daterainc.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
> ---
>  lib/percpu_ida.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
> index c2fa3dc..81b5ae9 100644
> --- a/lib/percpu_ida.c
> +++ b/lib/percpu_ida.c
> @@ -305,6 +305,11 @@ int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
>  {
>  	unsigned i, cpu, order;
>  
> +	if (batch_size > max_size)
> +		return -ERANGE;
> +	if (!batch_size)
> +		return -EINVAL;
> +
>  	memset(pool, 0, sizeof(*pool));
>  
>  	init_waitqueue_head(&pool->wait);

Acked-by: Kent Overstreet <koverstreet@daterainc.com>
