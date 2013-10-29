Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3J2S6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:58:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57115 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3J2S6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:58:18 -0400
Message-ID: <52700541.70405@kernel.dk>
Date: Tue, 29 Oct 2013 12:58:09 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Subject: Re: [PATCH] cciss: return 0 from driver probe function on success,
 not 1
References: <20131029184135.5505.77412.stgit@beardog.cce.hp.com>
In-Reply-To: <20131029184135.5505.77412.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 12:41 PM, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> A return value of 1 is interpreted as an error
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/block/cciss.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index edfa251..0c004ac 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -5183,7 +5183,7 @@ reinit_after_soft_reset:
>  	rebuild_lun_table(h, 1, 0);
>  	cciss_engage_scsi(h);
>  	h->busy_initializing = 0;
> -	return 1;
> +	return 0;
>  
>  clean4:
>  	cciss_free_cmd_pool(h);
> 

How did this ever work?

-- 
Jens Axboe

