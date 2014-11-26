Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaKZCFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 21:05:47 -0500
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:34662 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750938AbaKZCFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 21:05:46 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3874:4321:5007:6261:10004:10400:10848:11026:11232:11657:11658:11914:12043:12517:12519:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stick36_4f21945c54457
X-Filterd-Recvd-Size: 2005
Message-ID: <1416967542.8358.20.camel@perches.com>
Subject: Re: [PATCH] staging: lustre: fix pointer declarations
From: Joe Perches <joe@perches.com>
To: Zahari Doychev <zahari.doychev@linux.com>
Cc: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, oleg.drokin@intel.com,
        andreas.dilger@intel.com, gregkh@linuxfoundation.org,
        bergwolf@gmail.com
Date: Tue, 25 Nov 2014 18:05:42 -0800
In-Reply-To: <1b2734828d1cfcab4aaf7f72a2444793c1d74fd0.1416947671.git.zahari.doychev@linux.com>
References: <1b2734828d1cfcab4aaf7f72a2444793c1d74fd0.1416947671.git.zahari.doychev@linux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-25 at 21:44 +0100, Zahari Doychev wrote:
> This patch fixes pointer declarations from void * to void __user * in order
> to remove some sparse warnings.

This patch does more than that.

Please make sure to describe all of the changes
in a patch in the commit message.

> diff --git a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
[]
> @@ -780,22 +780,22 @@ void lnet_copy_kiov2kiov(unsigned int ndkiov, lnet_kiov_t *dkiov,
>  			  unsigned int soffset, unsigned int nob);
>  
>  static inline void
> -lnet_copy_iov2flat(int dlen, void *dest, unsigned int doffset,
> +lnet_copy_iov2flat(int dlen, void __user *dest, unsigned int doffset,
>  		   unsigned int nsiov, struct iovec *siov, unsigned int soffset,
>  		   unsigned int nob)
>  {
> -	struct iovec diov = {/*.iov_base = */ dest, /*.iov_len = */ dlen};
> +	struct iovec diov = {.iov_base = dest, .iov_len = dlen};

Now using named initializers too.


