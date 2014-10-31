Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbaJaJPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:15:08 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61369 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbaJaJPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:15:01 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-62-54535311c600
Message-id: <1414746895.6797.3.camel@AMDC1943>
Subject: Re: [PATCH v8 1/5] PM / Runtime: Add getter for querying the IRQ safe
 option
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 31 Oct 2014 10:14:55 +0100
In-reply-to: <1413795888-18559-2-git-send-email-k.kozlowski@samsung.com>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
 <1413795888-18559-2-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t/xy7qCwcEhBg9nWFhsnLGe1eLJgXZG
	i+lTLzBarJ76l9XibNMbdoslk+ezWsyaspfJYmHbEhaLy7vmsFl87j3CaHH7Mq/F2iN32S3e
	vYywuHvqKJvFmdOXWC0m/L7AZnF8bbjFy779LA5CHi3NPWwei/e8ZPK4c20PkNU3mdVjyZtD
	rB5brrazeMy++4PRo2/LKkaPFau/s3t83iTnsffzb5YA7igum5TUnMyy1CJ9uwSujGmNDewF
	zaIVr/7tZWpgnCfYxcjJISFgIjHtxT5WCFtM4sK99WxdjFwcQgJLGSVOLJ8C5XxmlPj+9yRY
	Fa+AnsShSU1MILawQLjE/WVbwOJsAsYSm5cvYQOxRQSyJeYdXcYK0swssJ9F4uib/exdjBwc
	LAKqEnenp4DUcAp4SCxa9JcdYkEro8SpZffYQRLMAuoSk+YtYgaplxBQlmjsd4PYKyjxY/I9
	FogSeYnNa94yT2AUmIWkYxaSsllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECInF
	rzsYlx6zOsQowMGoxMOr8SUoRIg1say4MvcQowQHs5IIr4h7cIgQb0piZVVqUX58UWlOavEh
	RiYOTqkGRnfL9zPWtk7W6uCemLcz+BNXvihD2+uzJR1KafLyrfFiRy3lzRXnP9i5uGFr3sre
	M55xh0u+ah3WmNB+SYpX6NKP+B09ZrXHbaZ1Tz0ZweLE/Nkp4UefdmxA8N41qSK6iy4JzLkt
	U//ecUJ8yzdJcemT/w6sKn4grfN4e/6F/xJBRqettc6eUmIpzkg01GIuKk4EAKuNRbmjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-10-20 at 11:04 +0200, Krzysztof Kozlowski wrote:
> Add a simple getter pm_runtime_is_irq_safe() for querying whether runtime
> PM IRQ safe was set or not.
> 
> Various bus drivers implementing runtime PM may use choose to suspend
> differently based on IRQ safeness status of child driver (e.g. do not
> unprepare the clock if IRQ safe is not set).
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Rafael, Len, Pavel,

Is proposed API ok? Do you have any comments?

I'll upload whole patchset to Russell's patch tracking system. However
an ack from PM maintainer is probably needed.

Best regards,
Krzysztof


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

