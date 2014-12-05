Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaLERCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:02:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49807 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbaLERB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:01:59 -0500
Date: Fri, 5 Dec 2014 17:01:56 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Zidan Wang <b50113@freescale.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        lars@metafoo.de, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH v3] ASoC: wm8960: Let wm8960 codec driver
	manage its own MCLK
Message-ID: <20141205170156.GB14516@opensource.wolfsonmicro.com>
References: <1417696879-15402-1-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417696879-15402-1-git-send-email-b50113@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 08:41:19PM +0800, Zidan Wang wrote:
> When we want to use wm8960 codec, we should enable its MCLK in machine
> driver. It's reasonable for wm8960 codec driver to manage its own MCLK to
> save power.
> 
> If platform data is not supplied, we will get MCLK from device tree and check
> the return code to handle probe deferral.
> 
> Enable runtime power management, and auto enable/disable MCLK in pm_runtime
> resume and suspend. When wm8960 codec is being used, it will triger resume()
> to enable MCLK. When codec is not being used, it will triger suspend() to
> disable MCLK.
> 
> Signed-off-by: Zidan Wang <b50113@freescale.com>
> ---
>  include/sound/wm8960.h    |  1 +
>  sound/soc/codecs/wm8960.c | 56 ++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/include/sound/wm8960.h b/include/sound/wm8960.h
> index e8ce8ee..d7e84ed 100644
> --- a/include/sound/wm8960.h
> +++ b/include/sound/wm8960.h
> @@ -16,6 +16,7 @@
>  #define WM8960_DRES_MAX  3
>  
>  struct wm8960_data {
> +	struct clk *mclk;

Is this really pdata? Would the pdata entry to locate the clock
not be a string holding the clock name that you call clk_get on,
rather than a clk pointer itself? Probably this should go in
wm8960_priv instead.

Thanks,
Charles
