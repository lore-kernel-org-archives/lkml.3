Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431AbaFQOyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:54:43 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:44082 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104AbaFQOyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:54:41 -0400
Date: Tue, 17 Jun 2014 15:54:20 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: arizona: Destroy regulators after the other MFD
 cells
Message-ID: <20140617145420.GH29841@lee--X1>
References: <1401699704-17902-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1401699704-17902-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401699704-17902-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2014, Charles Keepax wrote:

> Several of the cells depend on the regulators provided by the
> arizona-micsupp and arizona-ldo1 cells. As such use the new remove_level
> feature of the MFD core to ensure the regulators are destroyed after all
> the other cells.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |   20 ++++++++++++++++----
>  1 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 51c0110..76248bc 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -570,7 +570,10 @@ static inline int arizona_of_get_core_pdata(struct arizona *arizona)
>  #endif
>  
>  static const struct mfd_cell early_devs[] = {
> -	{ .name = "arizona-ldo1" },
> +	{
> +		.name = "arizona-ldo1",
> +		.remove_level = 1,
> +	},
>  };

Not keen on this approach at all.

+1 for the new reverse-probe-helpers.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
