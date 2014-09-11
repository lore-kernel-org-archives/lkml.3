Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaIKStR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 14:49:17 -0400
Received: from smtprelay0027.hostedemail.com ([216.40.44.27]:39032 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752555AbaIKStQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 14:49:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:965:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3874:4250:4321:4385:4390:4395:5007:7576:7652:7875:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shape02_339359bc3ba20
X-Filterd-Recvd-Size: 2371
Message-ID: <1410461351.9942.19.camel@joe-AO725>
Subject: Re: [PATCH 2/4] drivers/bus: Freescale Management Complex (fsl-mc)
 bus driver
From: Joe Perches <joe@perches.com>
To: "J. German Rivera" <German.Rivera@freescale.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        stuart.yoder@freescale.com, Kim.Phillips@freescale.com,
        scottwood@freescale.com, agraf@suse.de,
        linuxppc-release@linux.freescale.net
Date: Thu, 11 Sep 2014 11:49:11 -0700
In-Reply-To: <1410456864-27890-3-git-send-email-German.Rivera@freescale.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	 <1410456864-27890-3-git-send-email-German.Rivera@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 12:34 -0500, J. German Rivera wrote:
> From: "J. German Rivera" <German.Rivera@freescale.com>
> 
> Platform device driver that sets up the basic bus infrastructure
> for the fsl-mc bus type, including support for adding/removing
> fsl-mc devices, register/unregister of fsl-mc drivers, and bus
> match support to bind devices to drivers.

[]

> diff --git a/drivers/bus/fsl-mc/fsl_mc_bus.c b/drivers/bus/fsl-mc/fsl_mc_bus.c
[]
> +/**
> + * fsl_mc_bus_match - device to driver matching callback
> + * @dev: the MC object device structure to match against
> + * @drv: the device driver to search for matching MC object device id
> + * structures
> + *
> + * Returns 1 on success, 0 otherwise.
> + */
> +static int fsl_mc_bus_match(struct device *dev, struct device_driver *drv)
> +{
> +	const struct fsl_mc_device_match_id *id;
> +	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
> +	struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(drv);
> +	bool found = false;
[]
> +out:
> +	pr_debug("%s: %s %s\n", __func__, dev_name(dev),
> +		 found ? "matched" : "not matched");

Thia should probably use dev_dbg

	dev_dbg(dev, "%smatched\n", found ? "" : "not ");

and let the dynamic debug mechanism emit the
function name if desired.


