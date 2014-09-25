Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaIYObA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:31:00 -0400
Received: from smtprelay0071.hostedemail.com ([216.40.44.71]:55873 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751921AbaIYOa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:30:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:4321:5007:6642:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:12740:13019:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cap36_425c1faa25d5b
X-Filterd-Recvd-Size: 1695
Message-ID: <1411655454.4026.14.camel@joe-AO725>
Subject: Re: [PATCH] usb: core: log higher level message on malformed LANGID
 descriptor
From: Joe Perches <joe@perches.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>, Daniel Mack <daniel@caiaq.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 25 Sep 2014 07:30:54 -0700
In-Reply-To: <alpine.DEB.2.11.1409251356120.1920@localhost.localdomain>
References: <alpine.DEB.2.11.1409251356120.1920@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-25 at 13:56 +0000, Scot Doyle wrote:
> Commit 0cce2eda19923e5e5ccc8b042dec5af87b3ffad0
>     USB: fix LANGID=0 regression

trivia:

> diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
[]
> @@ -770,9 +770,7 @@ static int usb_get_langid(struct usb_device *dev, unsigned char *tbuf)
>  		dev->string_langid = 0x0409;
>  		dev->have_langid = 1;
>  		dev_err(&dev->dev,
> -			"string descriptor 0 malformed (err = %d), "
> -			"defaulting to 0x%04x\n",
> -				err, dev->string_langid);
> +			"language id specifier not provided by device, defaulting to English");

missing '\n' format termination.



