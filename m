Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbaKEQp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:45:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:10907 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbaKEQp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:45:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,320,1413270000"; 
   d="scan'208";a="602859854"
Date: Wed, 5 Nov 2014 22:16:01 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
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
Subject: Re: [PATCH v9 3/4] dma: pl330: add Power Management support
Message-ID: <20141105164601.GQ1870@intel.com>
References: <1415105570-7871-1-git-send-email-k.kozlowski@samsung.com>
 <1415105570-7871-4-git-send-email-k.kozlowski@samsung.com>
 <20141105140116.GN1870@intel.com>
 <1415197299.30831.10.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415197299.30831.10.camel@AMDC1943>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 03:21:39PM +0100, Krzysztof Kozlowski wrote:
> > > +static int __maybe_unused pl330_resume(struct device *dev)
> > > +{
> > > +	struct amba_device *pcdev = to_amba_device(dev);
> > > +
> > > +	amba_pclk_prepare(pcdev);
> > > +
> > > +	/*
> > > +	 * TODO: Idea for future. The device should not be woken up after
> > > +	 * system resume if it is not needed. It could stay runtime suspended
> > > +	 * waiting for DMA requests. However for safe suspend and resume we
> > > +	 * forcibly resume the device here.
> > > +	 */
> > > +	return pm_runtime_force_resume(dev);
> > > +}
> > > +
> > > +static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);
> > IIUC this sets .suspend and .resume, aren't you trying to add runtime
> > support as well?
> > Did you want UNIVERSAL_DEV_PM_OPS() ?
> 
> The runtime suspend and resume callbacks are provided by amba/bus.c.
Can you add that as comment in this driver please.

rest looks fine

-- 
~Vinod

