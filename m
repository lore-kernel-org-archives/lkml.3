Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab3DBHPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:15:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54308 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab3DBHP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:15:27 -0400
Message-ID: <515A8589.4090200@ti.com>
Date: Tue, 2 Apr 2013 09:15:21 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.4
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] pwm: twl: Add .owner to struct pwm_ops
References: <1364699642.7876.1.camel@phoenix> <1364699825.7876.5.camel@phoenix>
In-Reply-To: <1364699825.7876.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2013 05:17 AM, Axel Lin wrote:
> Add missing .owner of struct pwm_ops. This prevents the module from being
> removed from underneath its users.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> ---
>  drivers/pwm/pwm-twl.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pwm/pwm-twl.c b/drivers/pwm/pwm-twl.c
> index bf3fda2..ee7fa5d 100644
> --- a/drivers/pwm/pwm-twl.c
> +++ b/drivers/pwm/pwm-twl.c
> @@ -287,12 +287,14 @@ static const struct pwm_ops twl4030_pwm_ops = {
>  	.disable = twl4030_pwm_disable,
>  	.request = twl4030_pwm_request,
>  	.free = twl4030_pwm_free,
> +	.owner = THIS_MODULE,
>  };
>  
>  static const struct pwm_ops twl6030_pwm_ops = {
>  	.config = twl_pwm_config,
>  	.enable = twl6030_pwm_enable,
>  	.disable = twl6030_pwm_disable,
> +	.owner = THIS_MODULE,
>  };
>  
>  static int twl_pwm_probe(struct platform_device *pdev)
> 


-- 
Péter
