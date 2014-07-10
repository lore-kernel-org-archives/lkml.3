Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaGJNO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:14:58 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:61921 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaGJNO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:14:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 3/3] arm64: Use include/asm-generic/io.h
Date: Thu, 10 Jul 2014 15:14:16 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1404918699-17284-1-git-send-email-thierry.reding@gmail.com> <1404918699-17284-3-git-send-email-thierry.reding@gmail.com> <20140710110034.GI16137@arm.com>
In-Reply-To: <20140710110034.GI16137@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201407101514.16530.arnd@arndb.de>
X-Provags-ID: V02:K0:omDcwEmR4Ej4KEsP77vvfL3HWrU1yfeSXLMETHnF627
 5Ds79FwwhmhRibo5QhzZE51CZxbNFM9N/7Ts1Xfb6FhGaOrhTR
 D+OAuQMd4VEOXba4lKMkf+Xz6NEXunDHikTn5mv8I7OTLi9Slc
 XVQuObZZrMKugPem20EmGdZxZvLFI7051URIVHQz03HlFM+LQS
 8Fz1zczck6VAlJA9zgtxwtNmpZQ8/SA7gZylW70TCGCJzGzXsP
 ap9/G2Y2+5o3MABRUN1IdW074GPh4yBJztAG3Bn3yzNJEgDhep
 E/9BEsAqqapWC63uiPBZMdysuahhfxnj8bnfkFmErcGh9Ub3gp
 4S7vageMVkIt0P10l+nZO8M/K3Txk+nYDR/vvAxQ5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2014, Catalin Marinas wrote:
> > @@ -235,8 +155,7 @@ extern void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size);
> >  #define ioremap_wc(addr, size)               __ioremap((addr), (size), __pgprot(PROT_NORMAL_NC))
> >  #define iounmap                              __iounmap
> >  
> > -#define ARCH_HAS_IOREMAP_WC
> > -#include <asm-generic/iomap.h>
> > +#include <asm-generic/io.h>
> 
> We don't currently have PCIe support in mainline for arm64 but what I
> had in mind with the generic iomap is that functions like ioread32_rep
> first check whether the address is an IO address or a memory one and
> calls the insl or mmio_insl accordingly. With your generic
> implementation, this check disappears.
> 
> The question is whether this functionality would still be needed.

I think it's much better not to have that check on architectures that have a memory
mapped I/O space like arm64. The main advantage is that ioread32() is just a trivial
alias for readl(). The only reason for needing generic_iomap is architectures that
do something very different for I/O ports.

	Arnd
