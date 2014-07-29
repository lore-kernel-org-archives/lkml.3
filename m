Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaG2B7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 21:59:25 -0400
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:42694 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751425AbaG2B7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 21:59:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:4321:5007:6119:7652:7903:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: roof04_175c6bf568d2b
X-Filterd-Recvd-Size: 2036
Message-ID: <1406599159.5285.12.camel@joe-AO725>
Subject: Re: [PATCH] Staging: bcm: Bcmchar.c: remove else statement after
 return
From: Joe Perches <joe@perches.com>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, klmckinney1@gmail.com,
        mail@beyermatthias.de
Date: Mon, 28 Jul 2014 18:59:19 -0700
In-Reply-To: <1406592554-9519-1-git-send-email-mopsfelder@gmail.com>
References: <1406592554-9519-1-git-send-email-mopsfelder@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-28 at 21:09 -0300, Murilo Opsfelder Araujo wrote:
> This patch makes checkpatch.pl script happier by fixing all warnings
> related to else statement after break or return.
[]
> diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
[]
> @@ -561,10 +561,10 @@ static int bcm_char_ioctl_gpio_set_request(void __user *argp,
>  		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
>  				"GPIO_MODE_REGISTER read failed");
>  		return Status;
> -	} else {
> -		Status = STATUS_SUCCESS;
>  	}
>  
> +	Status = STATUS_SUCCESS;

This set of Status is unnecessary

>  	/* Set the gpio mode register to output */
>  	*(UINT *)ucResetValue |= (1<<uiBit);
>  	Status = wrmaltWithLock(Adapter, GPIO_MODE_REGISTER,

as it's immediately overwritten.

> @@ -669,10 +669,10 @@ static int bcm_char_ioctl_gpio_status_request(void __user *argp,
>  		Status = bytes;
>  		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
>  				"RDM Failed\n");
> -		return Status;
>  	} else {
>  		Status = STATUS_SUCCESS;
>  	}
> +
>  	return Status;

	return STATUS_SUCCESS;

