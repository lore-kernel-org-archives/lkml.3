Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaFBVeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:34:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50234 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaFBVeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:34:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "Alessandro Zummo" <a.zummo@towertech.it>,
        "Andrew Morton" <akpm@linux-foundation.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <5506235.fsodQ5dNGb@phil>
Cc: "Pawel Moll" <pawel.moll@arm.com>, "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, "Rob Herring" <robh+dt@kernel.org>
References: <5506235.fsodQ5dNGb@phil>
Message-ID: <20140602213358.10062.55182@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] rtc: hym8563: add optional clock-output-names property
Date: Mon, 02 Jun 2014 14:33:58 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Heiko Stübner (2014-05-18 15:40:07)
> This enables the setting of a custom clock name for the clock provided by
> the hym8563 rtc.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Annoying nitpick: would be nice to see the example updated to use
clock-output-names. But it's not a deal breaker.

Reviewed-by: Mike Turquette <mturquette@linaro.org>

Regards,
Mike

> ---
>  Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt | 3 +++
>  drivers/rtc/rtc-hym8563.c                               | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt b/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
> index 31406fd..5c199ee 100644
> --- a/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
> +++ b/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
> @@ -9,6 +9,9 @@ Required properties:
>  - interrupts: rtc alarm/event interrupt
>  - #clock-cells: the value should be 0
>  
> +Optional properties:
> +- clock-output-names: From common clock binding
> +
>  Example:
>  
>  hym8563: hym8563@51 {
> diff --git a/drivers/rtc/rtc-hym8563.c b/drivers/rtc/rtc-hym8563.c
> index e5f13c4..6442b5b 100644
> --- a/drivers/rtc/rtc-hym8563.c
> +++ b/drivers/rtc/rtc-hym8563.c
> @@ -418,6 +418,9 @@ static struct clk *hym8563_clkout_register_clk(struct hym8563 *hym8563)
>         init.num_parents = 0;
>         hym8563->clkout_hw.init = &init;
>  
> +       /* optional override of the clockname */
> +       of_property_read_string(node, "clock-output-names", &init.name);
> +
>         /* register the clock */
>         clk = clk_register(&client->dev, &hym8563->clkout_hw);
>  
> -- 
> 1.9.0
> 
> 
