Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaJOHVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:21:06 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:36977 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaJOHVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:21:01 -0400
MIME-Version: 1.0
In-Reply-To: <1411566612-32277-6-git-send-email-k.kozlowski@samsung.com>
References: <1411566612-32277-1-git-send-email-k.kozlowski@samsung.com>
	<1411566612-32277-6-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 15 Oct 2014 09:21:00 +0200
Message-ID: <CAPDyKFpO_S2gF33F2u5kyro-f7HohzmF9Nugbt80UqbmSqxDRQ@mail.gmail.com>
Subject: Re: [PATCH v7 5/5] amba: Remove unused amba_pclk_enable/disable macros
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

On 24 September 2014 15:50, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> Remove the amba_pclk_enable and amba_pclk_disable macros because they
> are not used by the drivers.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
>  include/linux/amba/bus.h | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
> index fd0c0bfa1d38..275e4a346de7 100644
> --- a/include/linux/amba/bus.h
> +++ b/include/linux/amba/bus.h
> @@ -87,12 +87,6 @@ struct amba_device *amba_find_device(const char *, struct device *, unsigned int
>  int amba_request_regions(struct amba_device *, const char *);
>  void amba_release_regions(struct amba_device *);
>
> -#define amba_pclk_enable(d)    \
> -       (IS_ERR((d)->pclk) ? 0 : clk_enable((d)->pclk))
> -
> -#define amba_pclk_disable(d)   \
> -       do { if (!IS_ERR((d)->pclk)) clk_disable((d)->pclk); } while (0)
> -
>  static inline void amba_pclk_prepare(struct amba_device *dev)
>  {
>         clk_prepare(dev->pclk);
> --
> 1.9.1
>
