Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaIXL57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:57:59 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:57290 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaIXL55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:57:57 -0400
Date: Wed, 24 Sep 2014 12:57:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "mfd: wm5102: Manually apply register patch"
Message-ID: <20140924115752.GM19999@lee--X1>
References: <1411551431-13045-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411551431-13045-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Charles Keepax wrote:

> This reverts commit d9d03496f6f904a3588bdb8b215853bc4e50132c.
> 
> It seems this commit was applied twice, once through ASoC and once
> through MFD:
> 
> commit 4c9bb8bc352a14c9613c77bc3f1e9038cd086b9b
> mfd: wm5102: Manually apply register patch
> 
> commit d9d03496f6f904a3588bdb8b215853bc4e50132c
> mfd: wm5102: Manually apply register patch
> 
> This has lead to a small piece of duplicate code. It is harmless hence
> how it has gone unoticed for so long. This patch reverts one of the two
> commits removing the unneeded code.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |   12 ------------
>  1 files changed, 0 insertions(+), 12 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 4afb232..72b3202 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -393,18 +393,6 @@ static int arizona_runtime_resume(struct device *dev)
>  		break;
>  	}
>  
> -	switch (arizona->type) {
> -	case WM5102:
> -		ret = wm5102_patch(arizona);
> -		if (ret != 0) {
> -			dev_err(arizona->dev, "Failed to apply patch: %d\n",
> -				ret);
> -			goto err;
> -		}
> -	default:
> -		break;
> -	}
> -
>  	ret = regcache_sync(arizona->regmap);
>  	if (ret != 0) {
>  		dev_err(arizona->dev, "Failed to restore register cache\n");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
