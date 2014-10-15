Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaJOQLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:11:41 -0400
Received: from smtprelay0148.hostedemail.com ([216.40.44.148]:42417 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751227AbaJOQLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:11:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:4250:4321:4605:5007:6261:7903:9121:10004:10400:10848:11232:11233:11658:11914:12296:12517:12519:12555:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shock42_4875bcd55833d
X-Filterd-Recvd-Size: 1872
Message-ID: <1413389496.7484.3.camel@perches.com>
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 09:11:36 -0700
In-Reply-To: <1413378213.2412.13.camel@jtkirshe-mobl>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20141015123431.GA23154@mwanda> <20141015125934.GB23154@mwanda>
	 <1413378213.2412.13.camel@jtkirshe-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-15 at 06:03 -0700, Jeff Kirsher wrote:
[]
> I thought I remember Greg saying something about getting rid of this
> driver anyway, but I could be wrong.  If Greg decides to keep this
> driver around, then I think we should something like your suggestion
> above.

Or maybe just make the Kconfig depend on X86_32
---
 drivers/staging/bcm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/Kconfig b/drivers/staging/bcm/Kconfig
index 8acf4b2..fa5a3a4 100644
--- a/drivers/staging/bcm/Kconfig
+++ b/drivers/staging/bcm/Kconfig
@@ -1,6 +1,6 @@
 config BCM_WIMAX
        tristate "Beceem BCS200/BCS220-3 and BCSM250 wimax support"
-       depends on USB && NET
+       depends on USB && NET && X86_32
        help
          This is an experimental driver for the Beceem WIMAX chipset used
 	 by Sprint 4G.


