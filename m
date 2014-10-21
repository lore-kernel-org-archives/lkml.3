Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaJUAPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 20:15:34 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:51590 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaJUAPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 20:15:33 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 216.239.45.75
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <7d41e4a5d7f599a13296f4eb7c3b9ff3>
X-DNS-TYPE: 0
Message-ID: <5445A599.9090203@rock-chips.com>
Date: Mon, 20 Oct 2014 17:15:21 -0700
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>
CC: Sonny Rao <sonnyrao@chromium.org>, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pinctrl: rockchip: Set wake_enabled
References: <1413847670-12245-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1413847670-12245-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by: Chris Zhong <zyw@rock-chips.com>

On 10/20/2014 04:27 PM, Doug Anderson wrote:
> The rockchip pinctrl driver uses irq_gc_set_wake() but doesn't setup
> the .wake_enabled member.  That means that we can never actually use a
> pin for wakeup.  When "irq_set_irq_wake()" tries to call through it
> will always get a failure from set_irq_wake_real() and will then set
> wake_depth to 0.  Assuming you can resume you'll later get an error
> message about "Unbalanced IRQ x wake disable".
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>   drivers/pinctrl/pinctrl-rockchip.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
> index 016f457..230d8f3 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.c
> +++ b/drivers/pinctrl/pinctrl-rockchip.c
> @@ -1563,6 +1563,7 @@ static int rockchip_interrupts_register(struct platform_device *pdev,
>   		gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
>   		gc->chip_types[0].chip.irq_set_wake = irq_gc_set_wake;
>   		gc->chip_types[0].chip.irq_set_type = rockchip_irq_set_type;
> +		gc->wake_enabled = IRQ_MSK(bank->nr_pins);
>   
>   		irq_set_handler_data(bank->irq, bank);
>   		irq_set_chained_handler(bank->irq, rockchip_irq_demux);

