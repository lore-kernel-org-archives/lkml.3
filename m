Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782Ab3EBUqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:46:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65285 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866Ab3EBUq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:46:28 -0400
Date: Thu, 2 May 2013 22:46:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH/RFC 0/4] dmaengine: add DT support for DMA multiplexers
In-Reply-To: <20130502162837.GM1960@intel.com>
Message-ID: <Pine.LNX.4.64.1305022157580.23970@axis700.grange>
References: <1367305883-2997-1-git-send-email-g.liakhovetski@gmx.de>
 <20130430104354.GF1960@intel.com> <Pine.LNX.4.64.1304301405510.1489@axis700.grange>
 <20130502162837.GM1960@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:JpUW4HF3sjMHIh4uEoV2/62vJouRoVfYDmKRyxJKjRd
 zkkTgdqf38SdaY9xj7uKVhwkPR3mHTui2OMwZctFQa7SCpotoc
 4gylNFCsaEzdzc8qEoojQL5g5k3Zzx2ek+LJfqLdy/1PEzdnAo
 JOAO1Mksp9FIcnzuOGEvhsarbhDvD1G+t2EDyBjXvJKBnC/6+C
 x9ngQm4bMOgt0/hdOM/36Whk2dO3H3hN3xY8ZnUg6qIuMD/Wvg
 Rv1XHXUFrd/sJQSaVlVymlPSEcLo2gb+GTEc4waSey7L+yHbWe
 bHbLXmPorSbGt4j7ScqjrcL1eAMiEgQhGEgvB0+9pNDnCAUmiz
 Yfb8ZwuXUL4aiZonMvkopD1Nn3vee/Ju2s8cpMSzK2vhO8ELVR
 WHkcPEM5nbWnw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Vinod Koul wrote:

> On Tue, Apr 30, 2013 at 02:17:13PM +0200, Guennadi Liakhovetski wrote:
> > (added Russell to CC, sorry for not including initially)
> > 
> > Hi Vinod
> > 
> > On Tue, 30 Apr 2013, Vinod Koul wrote:
> > 
> > > On Tue, Apr 30, 2013 at 09:11:19AM +0200, Guennadi Liakhovetski wrote:
> > > > Previously an issue has been discussed, arising on sh-/r-mobile ARM-based 
> > > > systems. There we typically have multiple DMA controller instances with 
> > > > exactly equal or very similar capabilities. Each of them can serve the same 
> > > > slaves, using the same slave identifiers (request line IDs). With the 
> > > > present DMA DT implementation _each_ such DMA slave would have to reference 
> > > > _each_ of those DMA controllers in its DMA bindings, e.g.
> > > But why... if that is the case then we havent define DT-bindings clearly enough
> > 
> > Sorry, what do you mean "why?" Why each slave has to reference each DMA 
> > controller? We have discussed this A LOT before... My understanding is, 
> > that we decided, that the sh-/r-mobile case of multiple equal DMA 
> > controllers is an exception and that we don't want to punish everyone for 
> > it. So, the design includes only explicit requesting of specific DMA 
> > request lines on specific DMA controllers, no wild-cards. If a slave DMA 
> > channel can be provided by several DMA controllers we decided to list them 
> > all explicitly too. And for the sh-/r-mobile case a DMA-mux DT node has 
> > been proposed. This is exactly what this patch series is implementing. Is 
> > my understanding wrong?
> > 
> > > And we havent merged that yet, so why not fix that in first set itself
> > 
> > Sorry, don't understand. The series isn't merged yet, that's right. That's 
> > why I explicitly mention this dependency here. But this isn't a fix. This 
> > is a new feature. The first patch-series only touches a specific DMA 
> > controller driver and relevant platforms. No core changes, so, it's not 
> > that intrusive and can be applied quickly. Whereas this series affects the 
> > core and might need a more careful consideration, discussion, etc.
> What i mean from above is if we were already defining the sh-DT binding then why
> wasnt this taken care in the orignal definition?
> 
> It would make sense to have proper binding which works well for both of these
> case, why a two shot approach?

In the first patch-series we implement DT support in shdma according to 
the existing API and add DT nodes to a platform. This is already a 
functioning implementation. The second patch-set is a new feature. It adds 
a new API - a DMA multiplexer and implementation examples. This way we can 
clearly show how the new API shall be used - what _changes_ are required 
to existing DMA DT implementations to support it. I think it makes sense 
to do this in two steps.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
