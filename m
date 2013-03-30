Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3C3N3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 09:29:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48556 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab3C3N3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 09:29:46 -0400
Date: Sat, 30 Mar 2013 13:29:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        c.aeschlimann@acn-group.ch
Subject: Re: [PATCH] Fix IXP4xx coherent allocations
Message-ID: <20130330132915.GB17995@n2100.arm.linux.org.uk>
References: <m3obe9lxil.fsf@intrepid.localdomain> <20130323.195740.2108147521543354261.davem@davemloft.net> <1364152267.3620.31.camel@deadeye.wl.decadent.org.uk> <m3r4j4sdmv.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3r4j4sdmv.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 10:15:36PM +0100, Krzysztof Halasa wrote:
> The problem on ARM (and probably on powerpc, and on something called
> "metag" - grep -r 'coherent DMA mask is unset' arch) is that the default
> coherent DMA mask is zero. IOW, coherent DMA allocations are, by
> default, disabled. A driver has to dma_set_coherent_mask() or, as many
> drivers do, set dev->coherent_dma_mask directly (IMHO
> dev->coherent_dma_mask along with dev->dma_mask are private DMA API
> stuff and e.g. device drivers have no interest there).
> 
> The zero default is IMHO, WRT the actual DMA API, an ARM bug (and
> powerpc's etc). Nevertheless, the patch I posted does everything as
> required by the API. Specifically, the IXP4xx arch part makes
> IXP4xx's dma_set_coherent_mask() compliant with DMA API, and the actual
> dma_set_coherent_mask() calls in drivers are both valid and I guess
> recommended by the API.
> 
> The patch doesn't touch the core ARM issue, that's right.

I'm having a hard time understanding what is an ARM issue here, what is
an ARM bug, and what the DMA API requires.  The DMA API documentation
is extremely sparse in describing what's required of the DMA masks,
what these functions are supposed to do, and what determines whether
a mask is "possible" or not.

Moreover, I'm also having a hard time understanding what broke in 3.7,
and why this fixes it.

In other words, I'm completely failing to understand everything about
this patch.
