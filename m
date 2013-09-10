Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3IJQGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:06:31 -0400
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:58238 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751166Ab3IJQGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:06:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2896:3138:3139:3140:3141:3142:3622:3865:3866:3868:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chalk35_1b59f7d0a845d
X-Filterd-Recvd-Size: 1267
Message-ID: <1378829187.15812.11.camel@joe-AO722>
Subject: Re: [PATCH] mei: Don't dev_err() on suspend
From: Joe Perches <joe@perches.com>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org, tomas.winkler@intel.com
Date: Tue, 10 Sep 2013 09:06:27 -0700
In-Reply-To: <1378828483-11813-1-git-send-email-ajax@redhat.com>
References: <1378828483-11813-1-git-send-email-ajax@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-10 at 11:54 -0400, Adam Jackson wrote:
> Suspend isn't an error condition, and I'm sick of seeing this (and only
> this) on the console when I suspend with quiet boot enabled.
[]
> diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
[]
> @@ -262,7 +262,7 @@ static int mei_me_pci_suspend(struct device *device)
>  	if (!dev)
>  		return -ENODEV;
>  
> -	dev_err(&pdev->dev, "suspend\n");
> +	dev_info(&pdev->dev, "suspend\n");

dev_dbg instead?


