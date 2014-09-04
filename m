Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaIDPcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:32:35 -0400
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:52541 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751140AbaIDPce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:32:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3872:4321:5007:7652:7808:8957:9040:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hands12_6d5e4f6319e1e
X-Filterd-Recvd-Size: 1762
Message-ID: <1409844750.2770.10.camel@joe-AO725>
Subject: Re: [PATCH] Staging: rtl8192u: fix brace style coding issue in
 r819xU_firmware.c
From: Joe Perches <joe@perches.com>
To: Chaitra Ramaiah <linux.delve@gmail.com>
Cc: gregkh@linuxfoundation.org, burzalodowa@gmail.com, anarey@gmail.com,
        rmfrfs@gmail.com, gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 04 Sep 2014 08:32:30 -0700
In-Reply-To: <1409843463-3702-2-git-send-email-linux.delve@gmail.com>
References: <1409843463-3702-1-git-send-email-linux.delve@gmail.com>
	 <1409843463-3702-2-git-send-email-linux.delve@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 20:41 +0530, Chaitra Ramaiah wrote:
[]
> diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/rtl8192u/r819xU_firmware.c
[]
> @@ -153,11 +153,10 @@ static bool CPUcheck_maincodeok_turnonCPU(struct net_device *dev)
>  			break;
>  	}while(check_bootOk_time--);
>  
> -	if (!(CPU_status&CPU_GEN_BOOT_RDY)) {
> +	if (!(CPU_status&CPU_GEN_BOOT_RDY))
>  		goto CPUCheckMainCodeOKAndTurnOnCPU_Fail;
> -	} else {
> +	else
>  		RT_TRACE(COMP_FIRMWARE, "Download Firmware: Boot ready!\n");
> -	}

This would be better as:

	if (!(CPU_status & CPU_GEN_BOOT_RDY))
		goto CPUCheckMainCodeOKandTurnOnCPU_Fail;

	RT_TRACE(etc...)

It'd be nice to eliminate the StudlyCaps and
rather long labels too.

