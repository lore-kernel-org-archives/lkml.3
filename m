Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab3H0JVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:21:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63075 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3H0JVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:21:06 -0400
Date: Tue, 27 Aug 2013 11:21:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH] DMA: shdma: fix a bad merge - remove free_irq()
In-Reply-To: <20130826135308.GP2748@intel.com>
Message-ID: <Pine.LNX.4.64.1308271028500.11515@axis700.grange>
References: <Pine.LNX.4.64.1308261426320.1767@axis700.grange>
 <20130826135308.GP2748@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:o9UmL5A+B8cMUoCyy9g+lXa6MUT0YIi7ITruE1pLIf/
 LR04dSgNW2gSxQkQrPR4tM9yXsD1OJ61mE1NP9qSIZ3u4ZWtsI
 IeEpZDtlPNmj6BCF9poODt2efhCt9beWFVrPbWcWdHgchKyUiS
 lbf4DVIMIUgT0QvRJVRHkYznGaBcCohVQ2ynNc4mL7VWEk7mw+
 01Ktd3s2+rtqrwmGleLFgs00JlHqFmwL1tuw+69hXjl9Okea+e
 JsU6M7v4Yd5R4MLYuQ1e0RQolEM2Id2pSGy3KWy9S3maSJ5kHb
 AQHUSihE14APntTN6y3M5NOPtCaryUcPWvo3XzINpD7XQTuRLy
 V7yqu/zL59Pn/xQHhji1nQUtoSO9KDw5Jm89ygXAR3W4EgCcHB
 ZzefFzKarMBBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Mon, 26 Aug 2013, Vinod Koul wrote:

> On Mon, Aug 26, 2013 at 02:27:51PM +0200, Guennadi Liakhovetski wrote:
> > A bad merge resulted in a left-over free_irq() call. This patch removes it.
> Applied, thanks
> 
> Can you also test this branch and see if anything is remaining
> 
> And can you take care then ARM patches in last serries are merged this week...

Ok, I wanted to just test -next, but the latest is still of 22 Aug and 
that's too old. So, I took the current sh-mobile tree and merged your 
tree on top. There was 1 merge conflict in arch/arm/Makefile, but that's 
unrelated. After doing that I've discovered the following problems:

1. you applied a wrong version (v1) of my patch "DMA: shdma: support the 
new CHCLR register layout" - not v2, whose patchwork ID I provided:

> DMA: shdma: support the new CHCLR register layout
> pw ID: 2825593

I suggest to revert that commit and apply the correct one.

2. you missed this patch:

> DMA: shdma: move two macros to a header
> pw ID: 2831934

Please, pick it up too, even though it's just a cosmetic one.

3. Your merge:

commit ba1e06e3dff9a0bb0758d169e50cbb04a67a402c
Merge: daabb76 74cd26c
Author: Vinod Koul <vinod.koul@intel.com>
Date:   Sun Aug 25 13:22:06 2013 +0530

    Merge branch 'topic/sh' into next
    
    Conflicts:
        drivers/dma/sh/shdmac.c

dropped a "const" from a variable, which now generates a compiler warning. 
I'll send an incremental fix for that soon.

After fixing all the above the tree seems to be in a proper state. After 
your tree is fixed we can push ARM patches too.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
