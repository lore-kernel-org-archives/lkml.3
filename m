Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbaCFA2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:28:09 -0500
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:42099 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754865AbaCFA2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:28:07 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3870:3871:3874:4321:5007:6119:6755:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12219:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hall03_639abd0c7cd22
X-Filterd-Recvd-Size: 1580
Message-ID: <1394065683.12070.32.camel@joe-AO722>
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Mar 2014 16:28:03 -0800
In-Reply-To: <3099833.ZhlQFyxhbo@avalon>
References: <1391958577.25424.22.camel@x220> <1600194.93iSF4Yz3E@avalon>
	 <20140305171006.6243354a@samsung.com> <3099833.ZhlQFyxhbo@avalon>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 00:50 +0100, Laurent Pinchart wrote:

> Please note that -DDEBUG is equivalent to '#define DEBUG', not to '#define 
> CONFIG_DEBUG'. 'DEBUG' needs to be defined for dev_dbg() to have any effect. 

Not quite.  If CONFIG_DYNAMIC_DEBUG is set, these
dev_dbg statements are compiled in but not by default
set to emit output.  Output can be enabled by using
dynamic_debug controls like:

# echo -n 'file omap4iss/* +p' > <debugfs>/dynamic_debug/control

See Documentation/dynamic-debug-howto.txt for more details.


