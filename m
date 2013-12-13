Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3LMOoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:44:20 -0500
Received: from relay2.sgi.com ([192.48.179.30]:57032 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753048Ab3LMOoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:44:19 -0500
Date: Fri, 13 Dec 2013 08:44:10 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH 1/5] drivers: misc: Mark functions as static in
 grukservices.c
Message-ID: <20131213144410.GA4684@sgi.com>
References: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 12:12:34PM +0530, Rashika Kheria wrote:
> This patch marks the function gru_get_cb_exception_detail_str() and
> gru_abort() as static in sgi-gru/grukservices.c because they are not
> used outside this file.
> 
> Thus, it also eliminates the following warnings in
> sgi-gru/grukservices.c:
> drivers/misc/sgi-gru/grukservices.c:432:7: warning: no previous prototype for ‘gru_get_cb_exception_detail_str’ [-Wmissing-prototypes]
> drivers/misc/sgi-gru/grukservices.c:508:6: warning: no previous prototype for ‘gru_abort’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Acked-by: Dimitri Sivanich <sivanich@sgi.com>

> ---
>  drivers/misc/sgi-gru/grukservices.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
> index 913de07..29d1582 100644
> --- a/drivers/misc/sgi-gru/grukservices.c
> +++ b/drivers/misc/sgi-gru/grukservices.c
> @@ -429,7 +429,7 @@ int gru_get_cb_exception_detail(void *cb,
>  	return 0;
>  }
>  
> -char *gru_get_cb_exception_detail_str(int ret, void *cb,
> +static char *gru_get_cb_exception_detail_str(int ret, void *cb,
>  				      char *buf, int size)
>  {
>  	struct gru_control_block_status *gen = (void *)cb;
> @@ -505,7 +505,7 @@ int gru_wait_proc(void *cb)
>  	return ret;
>  }
>  
> -void gru_abort(int ret, void *cb, char *str)
> +static void gru_abort(int ret, void *cb, char *str)
>  {
>  	char buf[GRU_EXC_STR_SIZE];
>  
> -- 
> 1.7.9.5
