Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab3JWJSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:18:22 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38837 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3JWJSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:18:20 -0400
Message-ID: <1382519898.10408.1.camel@mbp>
Subject: Re: [PATCH] arm64: allow ioremap_cache() to use existing RAM
 mappings
From: Catalin Marinas <catalin.marinas@arm.com>
To: "msalter@redhat.com" <msalter@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Oct 2013 10:18:18 +0100
In-Reply-To: <1382362594-24947-1-git-send-email-msalter@redhat.com>
References: <1382362594-24947-1-git-send-email-msalter@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-21 at 14:36 +0100, msalter@redhat.com wrote:
> diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> index 1725cd6..fb44b3d 100644
> --- a/arch/arm64/mm/ioremap.c
> +++ b/arch/arm64/mm/ioremap.c
> @@ -79,6 +79,21 @@ void __iounmap(volatile void __iomem *io_addr)
>  {
>  	void *addr = (void *)(PAGE_MASK & (unsigned long)io_addr);
>  
> +	/* Nothing to do for normal memory. See ioremap_cache() */
> +	if (pfn_valid(__virt_to_phys(addr) >> PAGE_SHIFT))
> +		return;

addr here can be some I/O address mapped previously, so __virt_to_phys()
is not valid (you don't actually get the pfn by shifting).

Catalin


