Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaIXJjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:39:43 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40608 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751716AbaIXJjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:39:40 -0400
Date: Wed, 24 Sep 2014 10:39:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jingchang Lu <jingchang.lu@freescale.com>
Cc: vinod.koul@intel.com, arnd@arndb.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2] dmaengine: fsl-edma: fixup reg offset and hw S/G
	support in big-endian model
Message-ID: <20140924093926.GT5182@n2100.arm.linux.org.uk>
References: <1411542727-11026-1-git-send-email-jingchang.lu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411542727-11026-1-git-send-email-jingchang.lu@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:12:07PM +0800, Jingchang Lu wrote:
>  static void edma_writeb(struct fsl_edma_engine *edma, u8 val, void __iomem *addr)
>  {
> -	iowrite8(val, addr);
> +	/* swap the reg offset for these in big-endian mode */
> +	if (edma->big_endian)
> +		iowrite8(val, (void __iomem *)((u32)addr ^ 0x3));

NAK.  /Not/ u32.  unsigned long.  Run this through sparse, and sparse
will complain with u32 here.  Just because the driver is currently used
on a 32-bit arch is no reason to be sloppy about this.

In fact, running this through sparse (make ... C=1) or even C=2 might
well be a good idea to check whether there's any other silly mistakes.

Note that Documentation/SubmitChecklist calls for checks with sparse.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
