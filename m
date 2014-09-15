Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaIOO51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:57:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50143 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752740AbaIOO5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:57:25 -0400
Date: Mon, 15 Sep 2014 10:57:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
cc: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>, <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v3 1/4] PM / Runtime: Add getter for quering the IRQ safe
 option
In-Reply-To: <1410776033-22156-2-git-send-email-k.kozlowski@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1409151056170.1360-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2014, Krzysztof Kozlowski wrote:

> Add a simple getter pm_runtime_is_irq_safe() for quering whether runtime
> PM IRQ safe was set or not.
> 
> Various bus drivers implementing runtime PM may use choose to suspend
> differently based on IRQ safeness status of child driver (e.g. do not
> unprepare the clock if IRQ safe is not set).
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  include/linux/pm_runtime.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
> index 367f49b9a1c9..44d74f0f182e 100644
> --- a/include/linux/pm_runtime.h
> +++ b/include/linux/pm_runtime.h
> @@ -128,6 +128,11 @@ static inline void pm_runtime_mark_last_busy(struct device *dev)
>  	ACCESS_ONCE(dev->power.last_busy) = jiffies;
>  }
>  
> +static inline bool pm_runtime_is_irq_safe(struct device *dev)
> +{
> +	return dev->power.irq_safe;
> +}
> +

If you add something to the runtime PM API, you must update the 
documentation file (Documentation/power/runtime_pm.txt) 
correspondingly.

Alan Stern

