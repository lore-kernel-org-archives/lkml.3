Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab3EBHsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:48:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53313 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab3EBHsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:48:12 -0400
Date: Thu, 2 May 2013 09:47:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH/RFC 0/6] DMA: shdma: add Device Tree support
In-Reply-To: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
Message-ID: <Pine.LNX.4.64.1305020936400.17181@axis700.grange>
References: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:McebXOT07INmPBitKxPBnow+gl0w8KsalHQBUM9eo3P
 kOkUUzV5nWUxyrjT2eCu+6FRoEWQmLHPDuiUT7IY5SNBA4Vj1N
 JglOHNY35uQTA7wSMNiAmzvtNqLXlwuaIiKWl7B4+IUbgrkaQM
 h3byF82DhS8E+S2rn5v8NoA7xCtYaMqUStaJsMpbx8wSH7Zfbn
 9dwHfYR078rNxbe5kex1mjC3WVai8xGWCm9lkrKuOXilXO7D0x
 qoconQ4hus3LKg2ZGlQ4nBqd6fV53Ts0goNVDEw0NnXJGe7cuP
 Yz4E1d52/ck0Qk5Ha9MiiIVyxGJyvbPJJnJR5kjlzg1XWtaf7h
 j0gyTXioC1YptL1NLvRBeX1D4fcKa7juv2oVfpTBAVHEXtqOGO
 TOmuY6vJtHR2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris, Simon, Vinod (in alphabetical order :-) )

On Thu, 11 Apr 2013, Guennadi Liakhovetski wrote:

> This patch series adds Device Tree support to the shdma dmaengine driver 
> and illustraits its use with the kzm9g-reference board's MMCIF interface.

Formally patches in this series belong to your 3 trees: 1-3 and 7 
(documentation, sent later separately) to DMA, 4 and 6 to ARM/shmobile, 5 
to MMC. However, they can actually be safely applied in any order, as long 
as per-tree patches are kept together. Even if the DMA portion is applied 
last, the MMC driver will find DMA DT bindings in the DT, will request 
channels, but no DMA channels will be found, then the driver will fall 
back to PIO.

So, it's up to you to decide, whether to pull these patches separately via 
respective trees, or have some of them acked and push all of them via one 
tree.

Thanks
Guennadi

> Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> 
> Guennadi Liakhovetski (6):
>   DMA: shdma: (cosmetic) don't re-calculate a pointer
>   DMA: shdma: shdma_chan_filter() has to be in shdma-base.h
>   DMA: shdma: add DT support
>   ARM: shmobile: sh73a0: add support for the DMA0 controller in DT
>   mmc: sh_mmcif: add support for Device Tree DMA bindings
>   ARM: shmobile: kzm9g-reference: add DMA channels to the MMCIF DT
> 
>  arch/arm/boot/dts/sh73a0-kzm9g-reference.dts |    3 ++
>  arch/arm/boot/dts/sh73a0.dtsi                |   36 ++++++++++++++++++
>  arch/arm/mach-shmobile/setup-sh73a0.c        |    4 ++
>  drivers/dma/sh/shdma-base.c                  |   51 +++++++++++++++++++++++---
>  drivers/dma/sh/shdma.c                       |   46 ++++++++++++++++++++----
>  drivers/mmc/host/sh_mmcif.c                  |   29 +++++++++------
>  include/linux/sh_dma.h                       |    2 -
>  include/linux/shdma-base.h                   |    6 +++
>  8 files changed, 151 insertions(+), 26 deletions(-)
> 
> -- 
> 1.7.2.5
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
