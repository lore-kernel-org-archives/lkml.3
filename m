Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924Ab3DBHPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:15:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38883 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab3DBHPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:15:17 -0400
Message-ID: <515A8580.4020001@ti.com>
Date: Tue, 2 Apr 2013 09:15:12 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.4
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] pwm: twl-led: Add .owner to struct pwm_ops
References: <1364699642.7876.1.camel@phoenix> <1364699774.7876.4.camel@phoenix>
In-Reply-To: <1364699774.7876.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2013 05:16 AM, Axel Lin wrote:
> Add missing .owner of struct pwm_ops. This prevents the module from being
> removed from underneath its users.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> ---
>  drivers/pwm/pwm-twl-led.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pwm/pwm-twl-led.c b/drivers/pwm/pwm-twl-led.c
> index 83e25d4..f912e87 100644
> --- a/drivers/pwm/pwm-twl-led.c
> +++ b/drivers/pwm/pwm-twl-led.c
> @@ -271,6 +271,7 @@ static const struct pwm_ops twl4030_pwmled_ops = {
>  	.enable = twl4030_pwmled_enable,
>  	.disable = twl4030_pwmled_disable,
>  	.config = twl4030_pwmled_config,
> +	.owner = THIS_MODULE,
>  };
>  
>  static const struct pwm_ops twl6030_pwmled_ops = {
> @@ -279,6 +280,7 @@ static const struct pwm_ops twl6030_pwmled_ops = {
>  	.config = twl6030_pwmled_config,
>  	.request = twl6030_pwmled_request,
>  	.free = twl6030_pwmled_free,
> +	.owner = THIS_MODULE,
>  };
>  
>  static int twl_pwmled_probe(struct platform_device *pdev)
> 


-- 
Péter
