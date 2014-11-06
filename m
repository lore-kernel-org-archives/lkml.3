Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaKFMor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:44:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:2520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaKFMop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:44:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,325,1413270000"; 
   d="scan'208";a="632598204"
Date: Thu, 6 Nov 2014 18:15:12 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v10 4/5] dmaengine: pl330: add Power Management support
Message-ID: <20141106124512.GA1870@intel.com>
References: <1415263010-7992-1-git-send-email-k.kozlowski@samsung.com>
 <1415263010-7992-5-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415263010-7992-5-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 09:36:49AM +0100, Krzysztof Kozlowski wrote:
> This patch adds both normal PM suspend/resume support and runtime PM
> support to pl330 DMA engine driver.
> 
> The runtime power management for pl330 DMA driver allows gating of AMBA
> clock (PDMA) in FSYS clock domain, when the device is not processing any
> requests. This is necessary to enter low power modes on Exynos SoCs
> (e.g. LPA on Exynos4x12 or W-AFTR on Exynos3250).
> 
> Runtime PM resuming of the device may happen in atomic context (during
> call device_issue_pending()) so pm_runtime_irq_safe() is used. This will
> lead only to disabling/enabling of the clock but this is sufficient for
> gating the clock and for reducing energy usage.
> 
> During system sleep the AMBA bus clock is also unprepared.

Acked-by: Vinod Koul <vinod.koul@intel.com>

-- 
~Vinod

