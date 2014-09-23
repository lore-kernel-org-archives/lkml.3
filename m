Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbaIWKhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:37:36 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38758 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754466AbaIWKhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:37:35 -0400
Date: Tue, 23 Sep 2014 11:37:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jingchang Lu <jingchang.lu@freescale.com>
Cc: vinod.koul@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dmaengine: fsl-edma: fixup reg offset and hw S/G
	support in big-endian model
Message-ID: <20140923103721.GQ5182@n2100.arm.linux.org.uk>
References: <1411463719-7728-1-git-send-email-jingchang.lu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411463719-7728-1-git-send-email-jingchang.lu@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 05:15:19PM +0800, Jingchang Lu wrote:
>  static u16 edma_readw(struct fsl_edma_engine *edma, void __iomem *addr)
>  {
> -	if (edma->big_endian)
> -		return ioread16be(addr);
> -	else
> +	u32 dst;

This should be unsigned long, if it needs to exist.

> +	/* swap the reg offset for these in big-endian mode */
> +	if (edma->big_endian) {
> +		dst = ((u32)addr & ~0x3) | (((u32)addr & 0x3) ^ 0x2);

This can be simplified to:

		addr = (void __iomem *)((unsigned long)addr ^ 2);

Ditto for all the other cases.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
