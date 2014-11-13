Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620AbaKMS2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:28:49 -0500
Received: from smtprelay0123.hostedemail.com ([216.40.44.123]:47702 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932784AbaKMS2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:28:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4250:4321:5007:6119:6261:7903:8531:8603:10004:10400:10848:11232:11658:11914:12050:12517:12519:12740:13069:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wound71_2f6a388c49e3e
X-Filterd-Recvd-Size: 1869
Message-ID: <1415903324.4223.5.camel@perches.com>
Subject: Re: [PATCH] dmaengine: pl330: Fix linker error "undefined reference
 to `__aeabi_uldivmod'"
From: Joe Perches <joe@perches.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Nov 2014 10:28:44 -0800
In-Reply-To: <1415902763.1787.8.camel@linaro.org>
References: <1415896047.1787.4.camel@linaro.org>
	 <1415898172.4223.1.camel@perches.com> <1415902763.1787.8.camel@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 18:19 +0000, Jon Medhurst (Tixy) wrote:
> There are many ways to code the limiting of the burst width, but as it
> starts out as the data bus width the DMA can handle (maximum 16 bytes)
> then at most we'll be going round the existing while loop 4 times so I
> don't think it's that much overhead, and probably less code size than
> using ffs.

For arm, isn't ffs just a few instruction with no loops?

> And as the driver has been broken for the unaligned memcpy case since
> the day it was added then I can't see that anyone is actually using it
> that way anyway, so all existing users (if any) must already be doing
> bus aligned copies and the current while loop will iterate zero times.

That's probably right, I just don't like reading
while loops where ffs/fls might be suitable.

> That's probably enough bikeshedding from me :-)

;)  Me too.  cheers, Joe


