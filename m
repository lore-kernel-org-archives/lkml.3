Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaCGARf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:17:35 -0500
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:35947 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751169AbaCGARc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:17:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3866:3867:3870:3872:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12114:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: level15_41577cc1dbf41
X-Filterd-Recvd-Size: 1392
Message-ID: <1394151447.16156.20.camel@joe-AO722>
Subject: Re: [PATCH] usbip:usbip_common.c: check return value of sscanf
From: Joe Perches <joe@perches.com>
To: John de la Garza <john@jjdev.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Thu, 06 Mar 2014 16:17:27 -0800
In-Reply-To: <20140306235156.GA3498@vega.jjdev.com>
References: <20140306235156.GA3498@vega.jjdev.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 15:51 -0800, John de la Garza wrote:
> Added code to check return value of sscanf.
[]
> diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
[]
> @@ -55,7 +55,8 @@ static ssize_t usbip_debug_store(struct device *dev,
>  				 struct device_attribute *attr, const char *buf,
>  				 size_t count)
>  {
> -	sscanf(buf, "%lx", &usbip_debug_flag);
> +	if (sscanf(buf, "%lx", &usbip_debug_flag) != 1)
> +		return -EINVAL;

Generally, it's probably better to convert these
sscanf uses to kstrto<foo>, kstrtoul in this case.


