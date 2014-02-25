Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaBYO1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:27:52 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:50007 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbaBYO1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:27:48 -0500
Date: Tue, 25 Feb 2014 14:27:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, gregkh@linuxfoundation.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 4/4] mfd: arizona: Use new regmap features for manual
 register patch
Message-ID: <20140225142743.GD9195@lee--X1>
References: <1393335952-28490-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1393335952-28490-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393335952-28490-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014, Charles Keepax wrote:

> On the wm5102 the register patches are applied manually, rather than by
> the regmap core. This application is wrapped in calls to
> regcache_cache_bypass. However, this is dangerous as other threads may
> be accessing the hardware at the same time as the pm_runtime operations
> and if they do so during the period whilst cache_bypass is enabled those
> writes will miss the cache when they shouldn't.
> 
> Apply the register patch using the new regmap_multi_reg_write_bypassed
> function to avoid this problem. Also remove the call to
> regcache_cache_bypass from the hardware patch application as it is
> unneeded there and creates a similar window for writes to miss the
> cache.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c  |    4 ----
>  drivers/mfd/wm5102-tables.c |   21 ++++-----------------
>  2 files changed, 4 insertions(+), 21 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
