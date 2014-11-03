Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaKCSC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:02:27 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:34370 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbaKCSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:02:23 -0500
Date: Mon, 3 Nov 2014 18:02:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 06/11] wm8350-core: Fix probable mask then right shift
 defect
Message-ID: <20141103180218.GB13359@x1>
References: <cover.1414387334.git.joe@perches.com>
 <9151d02031748dbc1637c1cc9110214617d9bcf1.1414387334.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9151d02031748dbc1637c1cc9110214617d9bcf1.1414387334.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2014, Joe Perches wrote:

> Precedence of & and >> is not the same and is not left to right.
> shift has higher precedence and should be done after the mask.
> 
> Add parentheses around the mask.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/mfd/wm8350-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied with Charles' Ack.

> diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> index 4ab527f..f5124a8 100644
> --- a/drivers/mfd/wm8350-core.c
> +++ b/drivers/mfd/wm8350-core.c
> @@ -308,7 +308,7 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
>  		goto err;
>  	}
>  
> -	mode = id2 & WM8350_CONF_STS_MASK >> 10;
> +	mode = (id2 & WM8350_CONF_STS_MASK) >> 10;
>  	cust_id = id2 & WM8350_CUST_ID_MASK;
>  	chip_rev = (id2 & WM8350_CHIP_REV_MASK) >> 12;
>  	dev_info(wm8350->dev,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
