Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3JIPNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 11:13:10 -0400
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:54835 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753610Ab3JIPNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 11:13:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:857:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:4250:4321:5007:7652:8879:10004:10400:10848:11026:11232:11658:11914:12296:12438:12517:12519:12740:13069:13095:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: step35_55099eab83a1c
X-Filterd-Recvd-Size: 1742
Message-ID: <1381331583.2050.11.camel@joe-AO722>
Subject: Re: [PATCH v2 2/3] video: xilinxfb: Use devm_kzalloc instead of
 kzalloc
From: Joe Perches <joe@perches.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Date: Wed, 09 Oct 2013 08:13:03 -0700
In-Reply-To: <748c16093663172918a90a53dc472cb8beb584ca.1381315928.git.michal.simek@xilinx.com>
References: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381315928.git.michal.simek@xilinx.com>
	 <748c16093663172918a90a53dc472cb8beb584ca.1381315928.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 12:52 +0200, Michal Simek wrote:
> Simplify driver probe and release function.
[]
> diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
[]
> @@ -423,7 +419,7 @@ static int xilinxfb_of_probe(struct platform_device *pdev)
>  	pdata = xilinx_fb_default_pdata;
> 
>  	/* Allocate the driver data region */
> -	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
> +	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
>  	if (!drvdata) {
>  		dev_err(&pdev->dev, "Couldn't allocate device private record\n");

Be nice to remove the unnecessary OOM message.
There's already a generic dump_stack on OOM.


