Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3JXSpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 14:45:47 -0400
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:42632 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754939Ab3JXSpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 14:45:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3874:4250:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12114:12296:12438:12517:12519:12740:13019:13069:13095:13
X-HE-Tag: bite01_31a484e15ce5e
X-Filterd-Recvd-Size: 2114
Message-ID: <1382640339.22433.73.camel@joe-AO722>
Subject: Re: [PATCH 4/8] input: Remove OOM message after
 input_allocate_device
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wan ZongShun <mcuos.com@gmail.com>,
        Andrey Moiseev <o2g.org.ru@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Josh Wu <josh.wu@atmel.com>,
        Ferruh Yigit <fery@cypress.com>, Pau Oliva Fora <pof@eslack.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Date: Thu, 24 Oct 2013 11:45:39 -0700
In-Reply-To: <20131024183707.GA5281@core.coreip.homeip.net>
References: <cover.1382555436.git.joe@perches.com>
	 <cc5e6a317bc9ef33cfdfae3ed9d3a47b5319a47b.1382555436.git.joe@perches.com>
	 <20131024183707.GA5281@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-24 at 11:37 -0700, Dmitry Torokhov wrote:
> Hi Joe,
> 
> On Wed, Oct 23, 2013 at 12:14:50PM -0700, Joe Perches wrote:
> > Emitting an OOM message isn't necessary after input_allocate_device
> > as there's a generic OOM and a dump_stack already done.
> 
> No, please don't. The kzalloc may get changed in the future to not dump
> stack (that was added originally because not everyone was handling OOM
> properly, right?), input core might get changed to use something else
> than kzalloc, etc, etc.
> 
> The majority of errors use dev_err so we also get idea what device
> failed (if there are several), and more.

I think that's not valuable as input_allocate_device already has
dozens of locations that don't emit a specific OOM and centralizing
the location for any generic message would work anyway.



