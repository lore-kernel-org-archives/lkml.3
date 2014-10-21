Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaJUIFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:05:50 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:61704 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbaJUIFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:05:30 -0400
MIME-Version: 1.0
In-Reply-To: <1413795888-18559-3-git-send-email-k.kozlowski@samsung.com>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com>
	<1413795888-18559-3-git-send-email-k.kozlowski@samsung.com>
Date: Tue, 21 Oct 2014 10:05:27 +0200
Message-ID: <CAPDyKFqZ9mwgCFaHctdhWPW018ir6Y8rEhAN_Euz3EFUPkuwWA@mail.gmail.com>
Subject: Re: [PATCH v8 2/5] amba: Add helpers for (un)preparing AMBA clock
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 October 2014 11:04, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> Add amba_pclk_prepare() and amba_pclk_unprepare() inline functions for
> handling the AMBA bus clock by device drivers.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

> ---
>  include/linux/amba/bus.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
> index c324f5700d1a..ac02f9bd63dc 100644
> --- a/include/linux/amba/bus.h
> +++ b/include/linux/amba/bus.h
> @@ -97,6 +97,16 @@ void amba_release_regions(struct amba_device *);
>  #define amba_pclk_disable(d)   \
>         do { if (!IS_ERR((d)->pclk)) clk_disable((d)->pclk); } while (0)
>
> +static inline int amba_pclk_prepare(struct amba_device *dev)
> +{
> +       return clk_prepare(dev->pclk);
> +}
> +
> +static inline void amba_pclk_unprepare(struct amba_device *dev)
> +{
> +       clk_unprepare(dev->pclk);
> +}
> +
>  /* Some drivers don't use the struct amba_device */
>  #define AMBA_CONFIG_BITS(a) (((a) >> 24) & 0xff)
>  #define AMBA_REV_BITS(a) (((a) >> 20) & 0x0f)
> --
> 1.9.1
>
