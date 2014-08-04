Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaHDWwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 18:52:31 -0400
Received: from smtprelay0112.hostedemail.com ([216.40.44.112]:50395 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753208AbaHDWwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 18:52:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:966:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2124:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3874:4321:4385:5007:7652:7903:9040:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12555:12679:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: waste95_6b8578b86f751
X-Filterd-Recvd-Size: 2657
Message-ID: <1407192737.16152.83.camel@joe-AO725>
Subject: Re: [PATCH] Staging: rtl8188eu: Lines over 80 characters fixed.
From: Joe Perches <joe@perches.com>
To: Adrian Remonda <adrianremonda@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 04 Aug 2014 15:52:17 -0700
In-Reply-To: <1407192303-23519-1-git-send-email-adrianremonda@gmail.com>
References: <1407192303-23519-1-git-send-email-adrianremonda@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-05 at 00:45 +0200, Adrian Remonda wrote:
> This is a patch to the hal/rtl8188eu_recv.c file that fixes up a "line
> over 80 characters" warning found by the checkpatch.pl tool.
[]
> diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
> index f25c87c..8be4819 100644
> --- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
> +++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
> @@ -41,15 +41,19 @@ int	rtl8188eu_init_recv_priv(struct adapter *padapter)
>  	/* init recv_buf */
>  	_rtw_init_queue(&precvpriv->free_recv_buf_queue);
>  
> -	precvpriv->pallocated_recv_buf = kzalloc(NR_RECVBUFF * sizeof(struct recv_buf) + 4, GFP_KERNEL);
> +	precvpriv->pallocated_recv_buf =
> +		kzalloc(NR_RECVBUFF * sizeof(struct recv_buf) + 4, GFP_KERNEL);
>  	if (precvpriv->pallocated_recv_buf == NULL) {
>  		res = _FAIL;
> -		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_, ("alloc recv_buf fail!\n"));
> +		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
> +				("alloc recv_buf fail!\n"));
>  		goto exit;
>  	}
> -	memset(precvpriv->pallocated_recv_buf, 0, NR_RECVBUFF * sizeof(struct recv_buf) + 4);
> +	memset(precvpriv->pallocated_recv_buf, 0,
> +			NR_RECVBUFF * sizeof(struct recv_buf) + 4);
>  
> -	precvpriv->precv_buf = (u8 *)N_BYTE_ALIGMENT((size_t)(precvpriv->pallocated_recv_buf), 4);
> +	precvpriv->precv_buf = (u8 *)N_BYTE_ALIGMENT((size_t)
> +			(precvpriv->pallocated_recv_buf), 4);

Several bits of this are not nice.

the +4 seems senseless.
zalloc followed by a memset(,0,) is senseless.
N_BYTE_ALIGNMENT seems senseless as alloc is
suitable for any alignmet.

btw: The merge window is open, please be patient
with any staging patch during the merge window.

