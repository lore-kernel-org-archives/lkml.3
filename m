Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaGVIbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:31:55 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37890 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaGVIbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:31:53 -0400
Message-ID: <53CE2126.9000804@gmail.com>
Date: Tue, 22 Jul 2014 14:00:30 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 5/5] gpio: move gpio_ensure_requested() into legacy C
 file
References: <1406013463-19218-1-git-send-email-acourbot@nvidia.com> <1406013463-19218-6-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1406013463-19218-6-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 12:47 PM, Alexandre Courbot wrote:

(...)

> +	if (WARN(test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0,
> +			"autorequest GPIO-%d\n", desc_to_gpio(desc))) {
> +		if (!try_module_get(chip->owner)) {
> +			gpiod_err(desc, "%s: module can't be gotten\n",
> +					__func__);

Should match open parenthesis '('

	gpiod_err(desc, "%s: module can't be gotten\n",
		  __func__);

> +			clear_bit(FLAG_REQUESTED, &desc->flags);
> +			/* lose */
> +			err = -EIO;
> +			goto end;
> +		}
> +		desc->label = "[auto]";
> +		/* caller must chip->request() w/o spinlock */
> +		if (chip->request)
> +			request = true;
> +	}
> +
> +end:
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +
> +	if (request) {
> +		might_sleep_if(chip->can_sleep);
> +		err = chip->request(chip, gpio_chip_hwgpio(desc));
> +
> +		if (err < 0) {
> +			gpiod_dbg(desc, "%s: chip request fail, %d\n",
> +					__func__, err);

Dto..

(...)


-- 
Regards,
Varka Bhadram.

