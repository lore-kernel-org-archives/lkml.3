Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbbADHKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 02:10:51 -0500
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:36070 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750790AbbADHKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 02:10:50 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3868:3871:4321:5007:6261:7514:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: roof09_41215656ccc02
X-Filterd-Recvd-Size: 1872
Message-ID: <1420355446.2619.18.camel@perches.com>
Subject: Re: [PATCH] staging: rtl8192e: Fix duplicated conditional branch
From: Joe Perches <joe@perches.com>
To: Alexander Kuleshov <kuleshovmail@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Sat, 03 Jan 2015 23:10:46 -0800
In-Reply-To: <1420354755-5261-1-git-send-email-kuleshovmail@gmail.com>
References: <1420354755-5261-1-git-send-email-kuleshovmail@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-04 at 12:59 +0600, Alexander Kuleshov wrote:
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
[]
> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
[]
> @@ -1661,7 +1661,7 @@ void dm_change_dynamic_initgain_thresh(struct net_device *dev,
>  		dm_digtable.rssi_low_thresh = dm_value;
>  	} else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_HIGH) {
>  		dm_digtable.rssi_high_power_highthresh = dm_value;
> -	} else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_HIGH) {
> +	} else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_LOW) {
>  		dm_digtable.rssi_high_power_highthresh = dm_value;
>  	} else if (dm_type == DIG_TYPE_ENABLE) {
>  		dm_digtable.dig_state		= DM_STA_DIG_MAX;

Presumably, this is a copy/paste error and should have
both lines changed to HIGHPWR_LOW/high_power_lowthresh

	else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_LOW)
		dm_digtable.rssi_high_power_lowthresh = dm_value;



