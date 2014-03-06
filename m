Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbaCFBAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 20:00:42 -0500
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:39117 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754846AbaCFBAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 20:00:41 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3868:3873:4250:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12296:12438:12517:12519:12740:13069:13181:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fowl29_5cf41811acd54
X-Filterd-Recvd-Size: 1564
Message-ID: <1394067637.12070.36.camel@joe-AO722>
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Mar 2014 17:00:37 -0800
In-Reply-To: <2136780.FIdBGb725A@avalon>
References: <1391958577.25424.22.camel@x220> <3099833.ZhlQFyxhbo@avalon>
	 <1394065683.12070.32.camel@joe-AO722> <2136780.FIdBGb725A@avalon>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 01:48 +0100, Laurent Pinchart wrote:
> Would you recommend to drop driver-specific Kconfig options related to 
> debugging and use CONFIG_DYNAMIC_DEBUG instead ?

For development, sure, if there's sufficient memory.

For embedded systems with limited memory, using
dynamic_debug isn't always possible or effective.

Also, there are sometimes reasons to have debugging
messages always enabled or emitted.

For those cases, either adding #define DEBUG or using
printk(KERN_DEBUG would be fine.


