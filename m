Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857Ab3BZN7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 08:59:24 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14779 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3BZN7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 08:59:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 26 Feb 2013 05:58:33 -0800
Message-ID: <512CBF75.9000103@nvidia.com>
Date: Tue, 26 Feb 2013 19:28:13 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Ian Lartey <ian@slimlogic.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH] gpio: palmas: add in GPIO support for palmas charger
References: <1361884868-27783-1-git-send-email-ian@slimlogic.co.uk>
In-Reply-To: <1361884868-27783-1-git-send-email-ian@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2013 06:51 PM, Ian Lartey wrote:
> this patch depenfs on [PATCH] mfd: palmas: is_palmas_charger needed by multiple drivers
>
> Palmas charger has 16 GPIOs
> add palmas_gpio_[read|write|update] api to take account
> second bank of GPIOs
>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> ---

>   
> +	/* palmas charger has 16 gpios */
> +	if (is_palmas_charger(palmas->product_id))
> +		palmas_gpio->gpio_chip.ngpio = 16;
> +
what happen if it is not palma charger?
palmas_gpio->gpio_chip.ngpio = 8; is missing or it will overwrite somewhere.

