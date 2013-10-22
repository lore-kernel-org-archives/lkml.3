Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3JVIik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:38:40 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51380 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab3JVIii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:38:38 -0400
Date: Tue, 22 Oct 2013 09:38:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Chen <peter.chen@freescale.com>
Cc: sameo@linux.intel.com, b29396@freescale.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] mfd: syscon: return -ENXIO if CONFIG_MFD_SYSCON is
 not enabled
Message-ID: <20131022083833.GC19112@lee--X1>
References: <1382426857-31975-1-git-send-email-peter.chen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382426857-31975-1-git-send-email-peter.chen@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some platforms may not define CONFIG_MFD_SYSCON (or haven't syscon),
> it can fix build error for those platforms.
> 
> Signed-off-by: Peter Chen <peter.chen@freescale.com>
> ---
>  include/linux/mfd/syscon.h |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
> index b473577..60bf0fb 100644
> --- a/include/linux/mfd/syscon.h
> +++ b/include/linux/mfd/syscon.h
> @@ -17,10 +17,34 @@
>  
>  struct device_node;
>  
> +#if IS_ENABLED(CONFIG_MFD_SYSCON)

I'd prefer #ifdef.

>  extern struct regmap *syscon_node_to_regmap(struct device_node *np);
>  extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
>  extern struct regmap *syscon_regmap_lookup_by_pdevname(const char *s);
>  extern struct regmap *syscon_regmap_lookup_by_phandle(
>  					struct device_node *np,
>  					const char *property);
> +#else
> +static inline struct regmap *syscon_node_to_regmap(struct device_node *np)
> +{
> +	return ERR_PTR(-ENXIO);

ENOSYS?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
