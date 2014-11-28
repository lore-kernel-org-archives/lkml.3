Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaK1KaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:30:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51959 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaK1KaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:30:01 -0500
Date: Fri, 28 Nov 2014 13:29:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, eunb.song@samsung.com,
        aaro.koskinen@iki.fi, paul.gortmaker@windriver.com
Subject: Re: [PATCH v2] staging: octeon: Fix checkpatch warnings
Message-ID: <20141128102928.GD4860@mwanda>
References: <20141127161432.GA32577@ks395439.kimsufi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127161432.GA32577@ks395439.kimsufi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 05:18:10PM +0100, Luis de Bethencourt wrote:
> Fixing 80 character limit warnings in octeon/ethernet-rx.c
> 
> Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
> ---
>  drivers/staging/octeon/ethernet-rx.c | 51 +++++++++++++++++++++++++-----------
>  1 file changed, 35 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
> index 1789a12..e387eb1 100644
> --- a/drivers/staging/octeon/ethernet-rx.c
> +++ b/drivers/staging/octeon/ethernet-rx.c
> @@ -109,6 +109,7 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
>  		int interface = cvmx_helper_get_interface_num(work->ipprt);
>  		int index = cvmx_helper_get_interface_index_num(work->ipprt);
>  		union cvmx_gmxx_rxx_frm_ctl gmxx_rxx_frm_ctl;
> +

Do this in a separate patch.

> @@ -332,8 +343,10 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
>  				skb->protocol = eth_type_trans(skb, dev);
>  				skb->dev = dev;
>  
> -				if (unlikely(work->word2.s.not_IP || work->word2.s.IP_exc ||
> -					work->word2.s.L4_error || !work->word2.s.tcp_or_udp))
> +				if (unlikely(work->word2.s.not_IP ||
> +					work->word2.s.IP_exc ||
> +					work->word2.s.L4_error ||
> +					!work->word2.s.tcp_or_udp))
>  					skb->ip_summed = CHECKSUM_NONE;

Your patch aligns everything with tabs but it should be slightly
different.  Run your patch through checkpatch.pl --strict to see what I
mean and then redo it all.  This one should look like:

				if (unlikely(work->word2.s.not_IP ||
					     work->word2.s.IP_exc ||
					     work->word2.s.L4_error ||
					     !work->word2.s.tcp_or_udp))
					skb->ip_summed = CHECKSUM_NONE;

[tab][tab][tab][tab][tab][space][space][space][space][space]work->...

regards,
dan carpenter


