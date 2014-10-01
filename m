Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaJARoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:44:14 -0400
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:52579 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751728AbaJARoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:44:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3867:3871:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rub46_41a712fd40d22
X-Filterd-Recvd-Size: 1604
Message-ID: <1412185449.3247.18.camel@joe-AO725>
Subject: Re: [PATCH] Staging: rtl8712 removed unnecessary else after return
From: Joe Perches <joe@perches.com>
To: Nitin Kuppelur <nitinkuppelur@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 01 Oct 2014 10:44:09 -0700
In-Reply-To: <1412174651-21418-1-git-send-email-nitinkuppelur@gmail.com>
References: <1412174651-21418-1-git-send-email-nitinkuppelur@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 16:44 +0200, Nitin Kuppelur wrote:
> Removed unnecessary else after return to solve
> checkpatch.pl warning
[]
> diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
[]
> @@ -389,10 +389,8 @@ uint rtl871x_hal_init(struct _adapter *padapter)
>  	padapter->hw_init_completed = false;
>  	if (padapter->halpriv.hal_bus_init == NULL)
>  		return _FAIL;
> -	else {
> -		if (padapter->halpriv.hal_bus_init(padapter) != _SUCCESS)
> -			return _FAIL;
> -	}
> +	if (padapter->halpriv.hal_bus_init(padapter) != _SUCCESS)
> +		return _FAIL;

Perhaps a more common style is to use:

	if (!padapter->halpriv.hal_bus_init ||
	    padapter->halpriv.hal_bus_init(padapter) != _SUCCESS)
		return _FAIL;


