Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3LVWNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 17:13:45 -0500
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:40870 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754262Ab3LVWNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 17:13:44 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:960:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2914:2915:3138:3139:3140:3141:3142:3352:3622:3865:3868:3870:3871:3872:3873:3874:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12296:12438:12517:12519:12740:13069:13161:13229:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drain14_3d71c7b5d770c
X-Filterd-Recvd-Size: 2124
Message-ID: <1387750419.22671.25.camel@joe-AO722>
Subject: Re: [PATCH] drivers: firmware: edd: fixed coding style errors
From: Joe Perches <joe@perches.com>
To: Derek Perrin <d.roc16@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 22 Dec 2013 14:13:39 -0800
In-Reply-To: <1387747039-14098-1-git-send-email-d.roc16@gmail.com>
References: <1387747039-14098-1-git-send-email-d.roc16@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-22 at 15:17 -0600, Derek Perrin wrote:
> Fixed coding style errors. Spaces, tab and parenthesis errors.

There's a real error in this patch.

When you do whitespace only changes, please
verify that the old and new object files produced
are unchanged.

One trivial bit too,

> diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
[]
> @@ -62,8 +62,8 @@ struct edd_device {
>  
>  struct edd_attribute {
>  	struct attribute attr;
> -	ssize_t(*show) (struct edd_device * edev, char *buf);
> -	int (*test) (struct edd_device * edev);
> +	ssize_t(*show) (struct edd_device *edev, char *buf);
> +	int (*test) (struct edd_device *edev);

I think most prefer function pointer prototypes like:

	size_t (*show)(struct edd_device *edev, char *buf);
	int (*test)(struct edd_device *edev);

> @@ -791,7 +791,7 @@ edd_exit(void)
>  	struct edd_device *edev;
>  
>  	for (i = 0; i < edd_num_devices(); i++) {
> -		if ((edev = edd_devices[i]))
> +		if ((edev == edd_devices[i]))
>  			edd_device_unregister(edev);
>  	}
>  	kset_unregister(edd_kset);

This is wrong.
It's an assignment in the block and it's important.

This could be rewritten as:

	for (i = 0; i < edd_num_devices(); i++) {
		edev = edd_devices[i];
		if (edev)
			edd_device_unregister(edev);
	}

or just remove the temporary.

