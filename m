Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbbAROdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:33:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:31246 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbbAROdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:33:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,421,1418112000"; 
   d="scan'208";a="652833736"
Date: Sun, 18 Jan 2015 20:02:26 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: dmaengine@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] dma: coh901318: fix function return types build warnings
Message-ID: <20150118143226.GQ15411@intel.com>
References: <2760189.hGZZQd3ELS@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2760189.hGZZQd3ELS@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 10:17:03PM +0100, Arnd Bergmann wrote:
> A recent patch that removed coh901318_control() replaced it
> with a number of pointers to existing functions, but those
> unfortunately have the wrong return  type and need to be
> changed to return an 'int' with an error value rather than
> a 'void' to avoid these build warnings:
> 
> drivers/dma/coh901318.c:2697:32: warning: assignment from incompatible pointer type
>   base->dma_slave.device_config = coh901318_dma_set_runtimeconfig;
>                                 ^
> drivers/dma/coh901318.c:2698:31: warning: assignment from incompatible pointer type
>   base->dma_slave.device_pause = coh901318_pause;
>                                ^
> drivers/dma/coh901318.c:2699:32: warning: assignment from incompatible pointer type
>   base->dma_slave.device_resume = coh901318_resume
> 
> The coh901318_base_init function has the correct return type
> already, but needs to be marked 'static' to avoid a sparse
> warning about a missing declaration.
> 
Please use the right subsystem name

Applied now

Thanks
-- 
~Vinod

