Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaBMPv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:51:56 -0500
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:56328 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751742AbaBMPvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:51:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3871:3872:3873:3874:4250:4321:4470:5007:6119:7652:7875:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12295:12438:12517:12519:12663:12679:12740:13069:13071:13095:13160:13163:13229:13311:13357:13972:14093:14097:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:f
X-HE-Tag: plot63_67419f8ab5f56
X-Filterd-Recvd-Size: 3145
Message-ID: <1392306707.2214.65.camel@joe-AO722>
Subject: Re: [PATCH 08/14] net: axienet: Removed checkpatch errors/warnings
From: Joe Perches <joe@perches.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: netdev@vger.kernel.org, Srikanth Thokala <sthokal@xilinx.com>,
        Srikanth Thokala <srikanth.thokala@xilinx.com>,
        Michal Simek <monstr@monstr.eu>, Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Feb 2014 07:51:47 -0800
In-Reply-To: <ff5b1f6a-a6a7-405c-9e83-59ad33852b93@TX2EHSMHS044.ehs.local>
References: <cover.1392220536.git.michal.simek@xilinx.com>
	 <75b669c0a947effe74b291093abfa8c71f83736a.1392220536.git.michal.simek@xilinx.com>
	 <1392251494.2214.11.camel@joe-AO722>
	 <ff5b1f6a-a6a7-405c-9e83-59ad33852b93@TX2EHSMHS044.ehs.local>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-13 at 08:19 +0100, Michal Simek wrote:
> On 02/13/2014 01:31 AM, Joe Perches wrote:
> > On Wed, 2014-02-12 at 16:55 +0100, Michal Simek wrote:

Hi again Michal.

> >> +		netdev_warn(lp->ndev,
> >> +			 "Could not find clock ethernet controller property.");
> > 
> > here too. (and alignment)
> 
> This is problematic. I would like to keep 80 char limits and keeping
> this align just break it. That's why I was using tab alignment.
> Probably the solution is just to shorten message.

(overly long, tiresomely trivial stuff below)

Your choice.  I'm not an 80 column zealot but
please don't shorten the message just to fit
80 columns if it impacts intelligibility.

Generally, I'd write this something like:

		netdev_warn(lp->ndev,
			    "Could not find clock ethernet controller property\n");

(without the period) which is 83 columns.

checkpatch makes exceptions for 80 column line
length maximums for format strings.

I've no real issue if you indent it back one.

fyi: this is 77 columns

		netdev_warn(lp->ndev,
			    "No clock ethernet controller property found\n");

About the message itself.

You dropped the "axienet_mdio_setup" function name.

I believe the dmesg output will look something like:

xilinx_temac 0000:01:00.0 (unregistered net_device): Could not find clock ethernet controller property.
xilinx_temac 0000:01:00.0 (unregistered net_device): Setting MDIO clock divisor to default 29

Because these 2 messages are effectively linked,
my preference would be to emit them on a single line,

Something like:

xilinx_temac 0000:01:00.0 (unregistered net_device): of_get_property("clock-frequency") not found - setting MDIO clock divisor to default 29

or

		netdev_warn(lp->ndev,
			    "of_get_property(\"clock-frequency\") not found - setting MDIO clock divisor to default %u\n",
			    DEFAULT_CLOCK_DIVISOR);


