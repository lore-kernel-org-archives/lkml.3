Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab3BGAI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:08:58 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49831 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab3BGAI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:08:56 -0500
Message-ID: <5112F096.7020001@wwwdotorg.org>
Date: Wed, 06 Feb 2013 17:08:54 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 03/14] mfd: ab8500: ensure new AB8500 pinctrl driver is
 probed correctly
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com> <1360093715-6348-4-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1360093715-6348-4-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 12:48 PM, Linus Walleij wrote:
> From: Lee Jones <lee.jones@linaro.org>
> 
> The old, BROKEN AB8500 GPIO driver has been revamped as a shiny
> new pinctrl driver and has been renamed as such. So, if we would
> like to make use of it, we need to register it via its new name.

> diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c

>  static struct mfd_cell ab8500_devs[] = {
>  	{
> -		.name = "ab8500-gpio",
> +		.name = "pinctrl-ab8500",
>  		.of_compatible = "stericsson,ab8500-gpio",
>  	},

I assume that the GPIO/pinctrl driver has already been renamed in some
unrelated patch, so this patch is just fixing it so it works again?

If I'm not understanding correctly, doesn't this patch break "git
bisect", since it's only renaming it in the MFD core and not in the
driver that this expects to instantiate?

