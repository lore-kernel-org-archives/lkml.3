Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaAKUCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 15:02:55 -0500
Received: from smtprelay0023.hostedemail.com ([216.40.44.23]:51483 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751616AbaAKUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 15:02:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:4321:5007:6119:6120:7514:7652:7901:7903:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13095:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trail09_532c043c07e61
X-Filterd-Recvd-Size: 1825
Message-ID: <1389470568.2537.81.camel@joe-AO722>
Subject: Re: [PATCH v2] Staging: lustre: Use of fls to find last set bit
From: Joe Perches <joe@perches.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        peter.p.waskiewicz.jr@intel.com, tao.peng@emc.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 11 Jan 2014 12:02:48 -0800
In-Reply-To: <1389468763-25662-1-git-send-email-monamagarwal123@gmail.com>
References: <1389440466-6895-1-git-send-email-monamagarwal123@gmail.com>
	 <1389468763-25662-1-git-send-email-monamagarwal123@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-01-12 at 01:02 +0530, Monam Agarwal wrote:
> This introduces fls in lustre/ldlm/ldlm_extent.c 
> to find the last set bit. 
[]
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
> ---
> Changes since v1:
> *Incorrect commit message
> *Use of fls function
[]
> diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c b/drivers/staging/lustre/lustre/ldlm/ldlm_extent.c
[]
> @@ -150,10 +150,12 @@ struct ldlm_interval *ldlm_interval_detach(struct ldlm_lock *l)
>  static inline int lock_mode_to_index(ldlm_mode_t mode)
>  {
>  	int index;
> +	int len;
>  
>  	LASSERT(mode != 0);
>  	LASSERT(IS_PO2(mode));
> -	for (index = -1; mode; index++, mode >>= 1) ;
> +	len = fls(mode);
> +	index = len-1;

There's no need for len at all.

	index = fls(mode) - 1;

would be fine.


