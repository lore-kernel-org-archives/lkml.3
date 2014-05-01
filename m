Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaEAShw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:37:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53430 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750788AbaEAShu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:37:50 -0400
Date: Thu, 1 May 2014 20:37:43 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/3] mtd: nand: add randomizer support
Message-ID: <20140501183743.GA17618@kwain>
References: <1398906592-24677-1-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398906592-24677-1-git-send-email-b.brezillon.dev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Thu, May 01, 2014 at 03:09:49AM +0200, Boris BREZILLON wrote:
> Hello,
> 
> This series is a proposal to add support for randomizers (either software
> or hardware) to NAND flash controller drivers.

Thanks for providing this! I'll need these features soon and I'm happy
to see them coming into the nand controller framework.


Antoine

> The last patch is the sunxi HW randomizer implementation and is just given
> as an example (it won't apply on the MTD tree, because it depends on other
> stuff not yet posted on the MTD ML, but if you want a full overview of the
> NAND Flash controller driver you can take a look at this series [2]).
> 
> I can also provide a software implementation based on LFSR (Left Feedback
> Shift Register) algorithm, thought I haven't tested it yet, hence why it's
> not part of this series. Let me know if you're interested in this
> implementation.
> 
> This series depends on the "per-partition ECC" series [1], because I need
> the randomizer seed to be different depending on the partition (for the
> same reason I needed ECC config to be different for each partition: the
> bootrom config might not fit the NAND chip requirements).
> 
> I'd like to have feedback from both MTD maintainers and driver
> developers who might need to implement (or use) a randomizer in their
> system, so feel free to comment on this series.
> 
> Best Regards,
> 
> Boris
> 
> [1] https://lkml.org/lkml/2014/2/12/627
> [2] https://groups.google.com/forum/#!msg/linux-sunxi/s3lBb01I0Js/z2NoCFJ83g4J 
> 
> 
> Boris BREZILLON (3):
>   mtd: nand: introduce a randomizer layer in the NAND framework
>   of: mtd: add NAND randomizer mode retrieval
>   mtd: nand: add sunxi randomizer support
> 
>  drivers/mtd/nand/nand_base.c  | 278 ++++++++++++++++++-----
>  drivers/mtd/nand/sunxi_nand.c | 507 +++++++++++++++++++++++++++++++++++++++++-
>  drivers/of/of_mtd.c           |  35 +++
>  include/linux/mtd/nand.h      |  98 ++++++++
>  include/linux/of_mtd.h        |   6 +
>  5 files changed, 858 insertions(+), 66 deletions(-)
> 
> -- 
> 1.8.3.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
