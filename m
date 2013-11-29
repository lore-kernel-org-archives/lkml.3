Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3K2TGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 14:06:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50637 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3K2TGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 14:06:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v7] gpio: Add MOXA ART GPIO driver
Date: Fri, 29 Nov 2013 20:06:31 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-gpio@vger.kernel.org, grant.likely@linaro.org,
        linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
References: <1385651945-22355-1-git-send-email-jonas.jensen@gmail.com> <1385723494-8033-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1385723494-8033-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201311292006.31661.arnd@arndb.de>
X-Provags-ID: V02:K0:yh5mFYcqvO6sIdYgmvQoTqzkKkOEK0OkB1HozSsKLnm
 sdDYT5fX/yAh+80toSdnnQK4+Wj0Z/huSbNZa/Jz4NufJyljiu
 B2/LPLDYXR5gwwS7F/oD7MIKQhheIuCPV8AlYlSnHCCTIJUNLh
 jlN3YVGDgpztMp3t4AIbazLVabFzPFX4YNjEXLjB4jxOBcHQ4L
 vvPbEK9Obt53MVIkh6C5DAJqlXMw9i4vz10I6KZs4juxBkVfeK
 7KKn9AxHKVwrOEHrjUNh9FhFgaebShpcbI0jfkGt63Kf8yNNlI
 KsjenHMRwJtxevBhuaDQWgSyp7AHQQDDSrh7jxUDa9oBlwbOr/
 +vxylxvYF8nLG7/DYwUs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 November 2013, Jonas Jensen wrote:
> Add GPIO driver for MOXA ART SoCs.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

One more comment, no need to resend for another review if this is the only
thing you want to change:

> +struct moxart_gpio_chip {
> +	struct gpio_chip gpio;
> +	void __iomem *moxart_gpio_base;
> +};

If you rename 'moxart_gpio_base' to 'base'

> +static int moxart_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct moxart_gpio_chip *gc = to_moxart_gpio(chip);
> +	u32 ret = readl(gc->moxart_gpio_base + GPIO_PIN_DIRECTION);
> +
> +	if (ret & BIT(offset))
> +		return !!(readl(gc->moxart_gpio_base + GPIO_DATA_OUT) &
> +			  BIT(offset));
> +	else
> +		return !!(readl(gc->moxart_gpio_base + GPIO_DATA_IN) &
> +			  BIT(offset));
> +}

These will fit in one line with no loss of readability.

	Arnd
