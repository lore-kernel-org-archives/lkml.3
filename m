Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaILPOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:14:11 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53175 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751653AbaILPOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:14:10 -0400
Date: Fri, 12 Sep 2014 16:13:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RFC PATCH v2 1/2] amba: Allow AMBA drivers to use their own
	runtime PM
Message-ID: <20140912151352.GK12361@n2100.arm.linux.org.uk>
References: <1410533779-3310-1-git-send-email-k.kozlowski@samsung.com> <1410533779-3310-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410533779-3310-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 04:56:18PM +0200, Krzysztof Kozlowski wrote:
> The AMBA bus driver defines runtime Power Management functions which
> disable and unprepare AMBA bus clock. This is problematic for runtime PM
> because unpreparing a clock might sleep so it is not interrupt safe.
> 
> However some drivers may want to implement runtime PM functions in
> interrupt-safe way (see pm_runtime_irq_safe()). If such driver
> implements its own runtime PM functions then assume it will handle the
> runtime PM completely and it will replace our clock handling.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Actually, I'd rather just revert 5303c0f46c8708fff4148ebcc491f78710356952
which is clearly the wrong thing to do when we have non-IRQ safe runtime
PM.

What we /could/ do instead is to check whether irq_safe is set after
probe, record that, and then select whether to use the prepare/unprepare
methods based on that.  (Drivers should never dynamically change this.)

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
