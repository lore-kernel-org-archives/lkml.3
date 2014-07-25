Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbaGYNSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:18:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:27009 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbaGYNSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:18:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,731,1400050800"; 
   d="scan'208";a="567170518"
Date: Fri, 25 Jul 2014 18:42:17 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Arnd Bergmann <arnd@arndb.de>, andriy.shevchenko@intel.com,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH v11 0/2] Add support for the Allwinner A31 DMA
 Controller
Message-ID: <20140725131217.GS8181@intel.com>
References: <1405626376-471-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405626376-471-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 09:46:14PM +0200, Maxime Ripard wrote:
> Hi,
> 
> This patchset adds support for the DMA controller found in the
> Allwinner A31 and A23 SoCs.
> 
> This has been tested using the newly introduced SPI driver on an A31
> EVK. Support for DMA-driven SPI transfers will be the subject of
> another patch serie.
> 
> This has been around for around 5 monthes now, and didn't get any
> review but nitpicks for three versions, so I feel like it could be
> merged quite quickly.
I have applied this now.

Can you please send follow patches for these:
- don't recall if I pointed earlier, but can we use direct conversion for
  calculating convert_burst() and convert_buswidth(), latter one at least
  seem doable
- don't use devm_request_irq(). You have irq enabled and you have killed
  tasklet. This is too racy. You need to ensure no irqs can be generated before killing
  tasklets.
- use synchronize_irq() before killing tasklet

Thanks

-- 
