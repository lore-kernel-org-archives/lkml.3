Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaLAGdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 01:33:19 -0500
Received: from smtprelay0032.hostedemail.com ([216.40.44.32]:35085 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752521AbaLAGdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 01:33:18 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:4321:5007:6261:7875:10004:10400:10848:11026:11232:11657:11658:11914:12043:12114:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: skate29_56bc47af0a361
X-Filterd-Recvd-Size: 1619
Message-ID: <1417415594.4894.1.camel@perches.com>
Subject: Re: [PATCH] staging:lustre:lnet: Incorrect type in assignment
From: Joe Perches <joe@perches.com>
To: sunwxg <sun.wxg@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Amir Shehata <amir.shehata@intel.com>, Peng Tao <bergwolf@gmail.com>,
        Doug Oucharek <doug.s.oucharek@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 30 Nov 2014 22:33:14 -0800
In-Reply-To: <1417414684-9726-2-git-send-email-sun.wxg@gmail.com>
References: <1417414684-9726-2-git-send-email-sun.wxg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 14:18 +0800, sunwxg wrote:
> Incorrect type when assign value to varible iov_base.
[]
> diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
[]
> @@ -256,7 +256,8 @@ lnet_extract_iov(int dst_niov, struct iovec *dst,
>  		LASSERT((int)niov <= dst_niov);
>  
>  		frag_len = src->iov_len - offset;
> -		dst->iov_base = ((char *)src->iov_base) + offset;
> +		dst->iov_base = (void __user *)
> +				(((char *)src->iov_base) + offset);

Just use void * arithmetic and remove the cast

		dst->iov_base = src->iov_base + offset;


