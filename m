Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3JCMAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:00:05 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:51410 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab3JCMAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:00:03 -0400
Date: Thu, 3 Oct 2013 12:59:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Correct handling of device tree gpio
 defaults
Message-ID: <20131003115958.GQ9048@lee--X1>
References: <1380796936-1174-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380796936-1174-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Oct 2013, Charles Keepax wrote:

> The intention is that all out of range values should cause the chips
> default settings to be used and a value of zero should be treated
> literally. Currently all out of range values will hit the second if and
> be treated as a literal zero. This patch adds an else to fix this issue.

Code looks good. I'm not sure I understand the commit message within
the current context.

> Reported-by: Heather Lomond <heather.lomond@wolfsonmicro.com>
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 5ac3aa4..e13355b 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -540,7 +540,7 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
>  		for (i = 0; i < ARRAY_SIZE(arizona->pdata.gpio_defaults); i++) {
>  			if (arizona->pdata.gpio_defaults[i] > 0xffff)
>  				arizona->pdata.gpio_defaults[i] = 0;
> -			if (arizona->pdata.gpio_defaults[i] == 0)
> +			else if (arizona->pdata.gpio_defaults[i] == 0)
>  				arizona->pdata.gpio_defaults[i] = 0x10000;
>  		}
>  	} else {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
