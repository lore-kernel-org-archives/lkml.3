Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3KFQzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:55:21 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47757 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3KFQzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:55:18 -0500
Message-ID: <527A7333.9090409@wwwdotorg.org>
Date: Wed, 06 Nov 2013 09:49:55 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>, kernel@pengutronix.de,
        linux@arm.linux.org.uk, a.zummo@towertech.it, airlied@linux.ie
CC: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>,
        =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
Subject: Re: [PATCH] drm/tegra: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
References: <1383724435-15380-1-git-send-email-duanj.fnst@cn.fujitsu.com>
In-Reply-To: <1383724435-15380-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 12:53 AM, Duan Jiong wrote:
> This patch fixes coccinelle error regarding usage of IS_ERR and
> PTR_ERR instead of PTR_ERR_OR_ZERO.

> diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c

> @@ -199,10 +199,7 @@ int tegra_bo_dumb_create(struct drm_file *file, struct drm_device *drm,
>  
>  	bo = tegra_bo_create_with_handle(file, drm, args->size, 0,
>  					 &args->handle);
> -	if (IS_ERR(bo))
> -		return PTR_ERR(bo);
> -
> -	return 0;
> +	return PTR_ERR_OR_ZERO(bo);
>  }

I suppose that's fine, although I wonder if it'll cause churn should we
ever need to add code to the tail end of the function.

BTW, why were all the similar patches that had nothing to do with Tegra
sent to the linux-tegra@ mailing list? You also didn't CC the
maintainers of drivers/gpu/drm/tegra/ on this patch. Plus this patch has
nothing to do with the rtc-linux@ mailing list.
