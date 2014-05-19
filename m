Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaESU37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:29:59 -0400
Received: from smtprelay0114.hostedemail.com ([216.40.44.114]:38620 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750890AbaESU35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:29:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:4250:4321:4384:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: week50_398fb60363646
X-Filterd-Recvd-Size: 2031
Message-ID: <1400531394.14238.35.camel@joe-AO725>
Subject: Re: [PATCH 5/5] usb: gadget: net2280: Use pr_* function
From: Joe Perches <joe@perches.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Amit Uttamchandani <auttamchandani@logicube.com>
Date: Mon, 19 May 2014 13:29:54 -0700
In-Reply-To: <Pine.LNX.4.44L0.1405191615451.1538-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1405191615451.1538-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 16:17 -0400, Alan Stern wrote:
> On Mon, 19 May 2014, Ricardo Ribalda Delgado wrote:
> > I really think that setting/unsetting DEBUG and VERBOSE is not a good
> > idea, and the generic functions are there to be used.
> You could change the definitions of DEBUG and VDEBUG to make them use 
> the generic functions.
> > What do you think that makes it more difficult to read? The GETDEV macro?

Maybe add ep_<level> helper macros and remove xprint

#define ep_err(ep, fmt, ...)					\
	dev_err(&(ep)->dev->pdev->dev, fmt, ##__VA_ARGS__)
#define ep_warn(ep, fmt, ...)					\
	dev_warn(&(ep)->dev->pdev->dev, fmt, ##__VA_ARGS__)
#define ep_info(ep, fmt, ...)					\
	dev_info(&(ep)->dev->pdev->dev, fmt, ##__VA_ARGS__)
#define ep_dbg(ep, fmt, ...)					\
	dev_dbg(&(ep)->dev->pdev->dev, fmt, ##__VA_ARGS__)
#define ep_vdbg(ep, fmt, ...)					\
	dev_vdbg(&(ep)->dev->pdev->dev, fmt, ##__VA_ARGS__)

but even that conversion isn't straightforward.


