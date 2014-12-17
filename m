Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaLQXia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 18:38:30 -0500
Received: from smtprelay0029.hostedemail.com ([216.40.44.29]:45683 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750981AbaLQXi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 18:38:29 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:3872:4321:4605:5007:6261:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12438:12517:12519:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: game81_49dfc59a0c740
X-Filterd-Recvd-Size: 2130
Message-ID: <1418859505.28384.3.camel@perches.com>
Subject: Re: [PATCH] Staging: unisys: virtpci: fixed some coding style issues
From: Joe Perches <joe@perches.com>
To: Andrew Milkovich <amilkovich@gmail.com>
Cc: benjamin.romer@unisys.com, david.kershner@unisys.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Wed, 17 Dec 2014 15:38:25 -0800
In-Reply-To: <1418858832-16043-1-git-send-email-amilkovich@gmail.com>
References: <1418858832-16043-1-git-send-email-amilkovich@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-17 at 15:27 -0800, Andrew Milkovich wrote:
> Fixed some coding style issues

This is not a very descriptive subject or commit log message.
Please describe what changes are being done.

> diff --git a/drivers/staging/unisys/virtpci/virtpci.c b/drivers/staging/unisys/virtpci/virtpci.c
[]
> @@ -279,9 +279,9 @@ static int add_vbus(struct add_vbus_guestpart *addparams)
> 		POSTCODE_LINUX_2(VPCI_CREATE_FAILURE_PC, POSTCODE_SEVERITY_ERR);
> 		return 0;
> 	}
> -	write_vbus_chp_info(vbus->platform_data /* chanptr */ ,
> +	write_vbus_chp_info(vbus->platform_data /* chanptr */,
> 			    &chipset_driver_info);

I think it better to just remove the comments like:

	write_vbus_chp_info(vbus->platform_data, &chipset_driver_info);

> @@ -466,7 +466,7 @@ static int pause_vhba(struct pause_virt_guestpart *pauseparams)
> 	GET_SCSIADAPINFO_FROM_CHANPTR(pauseparams->chanptr);
> 
> 	LOGINF("Pausing vhba wwnn:%x:%x\n", scsi.wwnn.wwnn1, scsi.wwnn.wwnn2);
> -	i = virtpci_device_serverdown(NULL /*no parent bus */ , VIRTHBA_TYPE,
> +	i = virtpci_device_serverdown(NULL /*no parent bus */, VIRTHBA_TYPE,
> 				      &scsi.wwnn, NULL);

	i = vittpci_device_serverdown(NULL, VIRTHBA_TYPE, &scsi.wwnn, NULL);

etc.


