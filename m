Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaIPS1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:27:11 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34893 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaIPS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:27:08 -0400
MIME-Version: 1.0
In-Reply-To: <1410872360-27029-2-git-send-email-k.kozlowski@samsung.com>
References: <1410872360-27029-1-git-send-email-k.kozlowski@samsung.com>
	<1410872360-27029-2-git-send-email-k.kozlowski@samsung.com>
Date: Tue, 16 Sep 2014 20:27:06 +0200
Message-ID: <CAPDyKFqg1uyMxvHvpajdHxDZ3C_GQOZb4fgVN9xWY8V6stDkLQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] PM / Runtime: Add getter for quering the IRQ safe option
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 September 2014 14:59, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> Add a simple getter pm_runtime_is_irq_safe() for quering whether runtime
> PM IRQ safe was set or not.
>
> Various bus drivers implementing runtime PM may use choose to suspend
> differently based on IRQ safeness status of child driver (e.g. do not
> unprepare the clock if IRQ safe is not set).
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
>  Documentation/power/runtime_pm.txt | 4 ++++
>  include/linux/pm_runtime.h         | 6 ++++++
>  2 files changed, 10 insertions(+)
>
> diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
> index f32ce5419573..397b81593142 100644
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
>         ACCESS_ONCE(dev->power.last_busy) = jiffies;
>  }
>
> +static inline bool pm_runtime_is_irq_safe(struct device *dev)
> +{
> +       return dev->power.irq_safe;
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
> --
> 1.9.1
>
