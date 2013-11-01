Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3KAFkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 01:40:52 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:24988
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823Ab3KAFkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 01:40:51 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1155h)
Date: Fri, 1 Nov 2013 13:27:24 +0800
From: Nicolin Chen <b42378@freescale.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <joe@perches.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] lib/genalloc: add a helper function for DMA
 buffer allocation
Message-ID: <20131101052723.GA28401@MrMyself>
References: <1383210967-25804-1-git-send-email-b42378@freescale.com>
 <20131031142619.d7aed35fe536f5a177012d27@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131031142619.d7aed35fe536f5a177012d27@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sir,

On Thu, Oct 31, 2013 at 02:26:19PM -0700, Andrew Morton wrote:
> On Thu, 31 Oct 2013 17:16:07 +0800 Nicolin Chen <b42378@freescale.com> wrote:
> 
> > When using pool space for DMA buffer, there might be duplicated calling
> > of gen_pool_alloc() and gen_pool_virt_to_phys() in each implementation.
> > 
> > Thus it's better to add a simple helper function, a compatible one to
> > the common dma_alloc_coherent(), to save some code.
> > 
> 
> Well OK, but this new function doesn't have any callers.  So it
> increases kernel size and is untestable.
> 
> Do you have any conversion patches which we can merge to address these
> problems?
> 
>

I'll later send a patch to convert all the combinations of gen_pool_alloc()
and gen_pool_virt_to_phys(), within the entire kernel, to this helper func.

This would need quite a lot people engaged to test it.

If anything unexpected happens during the test, we can refine and fix it.
Surely, if some owners of modified driver don't want their code be altered,
I can drop those modification to their drivers.

Is this okay?

Thank you,
Nicolin Chen


