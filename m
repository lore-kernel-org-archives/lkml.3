Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaHDNlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:41:04 -0400
Received: from relay2.sgi.com ([192.48.180.65]:60809 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751332AbaHDNlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:41:03 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2014 09:41:03 EDT
Date: Mon, 4 Aug 2014 08:30:37 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Hans Wennborg <hans@hanshq.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/19] gru: fix %d confusingly prefixed with 0x in
 format string
Message-ID: <20140804133037.GA31042@sgi.com>
References: <1407111577-14815-1-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407111577-14815-1-git-send-email-hans@hanshq.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decimal ("%d" without the "0x") for the ctxnum please.

Nacked-by: Dimitri Sivanich <sivanich@sgi.com>

On Sun, Aug 03, 2014 at 05:19:37PM -0700, Hans Wennborg wrote:
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  drivers/misc/sgi-gru/grumain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
> index ae16c8c..a1ce324 100644
> --- a/drivers/misc/sgi-gru/grumain.c
> +++ b/drivers/misc/sgi-gru/grumain.c
> @@ -283,7 +283,7 @@ static void gru_unload_mm_tracker(struct gru_state *gru,
>  	spin_lock(&gru->gs_asid_lock);
>  	BUG_ON((asids->mt_ctxbitmap & ctxbitmap) != ctxbitmap);
>  	asids->mt_ctxbitmap ^= ctxbitmap;
> -	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%d, asidmap 0x%lx\n",
> +	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%x, asidmap 0x%lx\n",
>  		gru->gs_gid, gts, gms, gts->ts_ctxnum, gms->ms_asidmap[0]);
>  	spin_unlock(&gru->gs_asid_lock);
>  	spin_unlock(&gms->ms_asid_lock);
> -- 
> 2.0.0.526.g5318336
