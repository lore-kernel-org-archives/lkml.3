Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbaKMBOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:14:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60546 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752926AbaKMBOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:14:02 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v11 1/6] PM / Runtime: Add getter for querying the IRQ safe option
Date: Thu, 13 Nov 2014 02:34:57 +0100
Message-ID: <3087810.nyWZ4cyKAA@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415802748-30530-2-git-send-email-k.kozlowski@samsung.com>
References: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com> <1415802748-30530-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 12, 2014 03:32:23 PM Krzysztof Kozlowski wrote:
> Add a simple getter pm_runtime_is_irq_safe() for querying whether runtime
> PM IRQ safe was set or not.
> 
> Various bus drivers implementing runtime PM may use choose to suspend
> differently based on IRQ safeness status of child driver (e.g. do not
> unprepare the clock if IRQ safe is not set).
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

I'm fine with this one, please feel free to add my ACK if that needs to go
through a different tree.

> ---
>  Documentation/power/runtime_pm.txt | 4 ++++
>  include/linux/pm_runtime.h         | 6 ++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
> index 0e5ea26b255a..44fe1d28a163 100644
> --- a/Documentation/power/runtime_pm.txt
> +++ b/Documentation/power/runtime_pm.txt
> @@ -468,6 +468,10 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
>      - set the power.irq_safe flag for the device, causing the runtime-PM
>        callbacks to be invoked with interrupts off
>  
> +  bool pm_runtime_is_irq_safe(struct device *dev);
> +    - return true if power.irq_safe flag was set for the device, causing
> +      the runtime-PM callbacks to be invoked with interrupts off
> +
>    void pm_runtime_mark_last_busy(struct device *dev);
>      - set the power.last_busy field to the current time
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
>  #else /* !CONFIG_PM_RUNTIME */
>  
>  static inline int __pm_runtime_idle(struct device *dev, int rpmflags)
> @@ -167,6 +172,7 @@ static inline bool pm_runtime_enabled(struct device *dev) { return false; }
>  
>  static inline void pm_runtime_no_callbacks(struct device *dev) {}
>  static inline void pm_runtime_irq_safe(struct device *dev) {}
> +static inline bool pm_runtime_is_irq_safe(struct device *dev) { return false; }
>  
>  static inline bool pm_runtime_callbacks_present(struct device *dev) { return false; }
>  static inline void pm_runtime_mark_last_busy(struct device *dev) {}
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
