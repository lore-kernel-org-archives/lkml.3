Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598Ab3EBRCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:02:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:51693 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab3EBRC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:02:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,597,1363158000"; 
   d="scan'208";a="296631994"
Date: Thu, 2 May 2013 21:58:37 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH/RFC 0/4] dmaengine: add DT support for DMA multiplexers
Message-ID: <20130502162837.GM1960@intel.com>
References: <1367305883-2997-1-git-send-email-g.liakhovetski@gmx.de>
 <20130430104354.GF1960@intel.com>
 <Pine.LNX.4.64.1304301405510.1489@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304301405510.1489@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 02:17:13PM +0200, Guennadi Liakhovetski wrote:
> (added Russell to CC, sorry for not including initially)
> 
> Hi Vinod
> 
> On Tue, 30 Apr 2013, Vinod Koul wrote:
> 
> > On Tue, Apr 30, 2013 at 09:11:19AM +0200, Guennadi Liakhovetski wrote:
> > > Previously an issue has been discussed, arising on sh-/r-mobile ARM-based 
> > > systems. There we typically have multiple DMA controller instances with 
> > > exactly equal or very similar capabilities. Each of them can serve the same 
> > > slaves, using the same slave identifiers (request line IDs). With the 
> > > present DMA DT implementation _each_ such DMA slave would have to reference 
> > > _each_ of those DMA controllers in its DMA bindings, e.g.
> > But why... if that is the case then we havent define DT-bindings clearly enough
> 
> Sorry, what do you mean "why?" Why each slave has to reference each DMA 
> controller? We have discussed this A LOT before... My understanding is, 
> that we decided, that the sh-/r-mobile case of multiple equal DMA 
> controllers is an exception and that we don't want to punish everyone for 
> it. So, the design includes only explicit requesting of specific DMA 
> request lines on specific DMA controllers, no wild-cards. If a slave DMA 
> channel can be provided by several DMA controllers we decided to list them 
> all explicitly too. And for the sh-/r-mobile case a DMA-mux DT node has 
> been proposed. This is exactly what this patch series is implementing. Is 
> my understanding wrong?
> 
> > And we havent merged that yet, so why not fix that in first set itself
> 
> Sorry, don't understand. The series isn't merged yet, that's right. That's 
> why I explicitly mention this dependency here. But this isn't a fix. This 
> is a new feature. The first patch-series only touches a specific DMA 
> controller driver and relevant platforms. No core changes, so, it's not 
> that intrusive and can be applied quickly. Whereas this series affects the 
> core and might need a more careful consideration, discussion, etc.
What i mean from above is if we were already defining the sh-DT binding then why
wasnt this taken care in the orignal definition?

It would make sense to have proper binding which works well for both of these
case, why a two shot approach?

--
~Vinod
