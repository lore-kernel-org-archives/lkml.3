Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaDOOn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:43:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbaDOOn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:43:56 -0400
Message-ID: <1397573032.2471.0.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH] gpio: ich: set regs and reglen for i3100 and ich6
 chipset
From: Eric Paris <eparis@redhat.com>
To: Vincent Donnefort <vdonnefort@gmail.com>
Cc: linux-kernel@vger.kernel.org, ptyser@xes-inc.com, linus.walleij@linaro.org,
        gnurou@gmail.com, linux-gpio@vger.kernel.org
Date: Tue, 15 Apr 2014 10:43:52 -0400
In-Reply-To: <1397564503-5175-1-git-send-email-vincent.donnefort@seagate.com>
References: <20140415084056.GA26578@ks3318809.kimsufi.com>
	 <1397564503-5175-1-git-send-email-vincent.donnefort@seagate.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 14:21 +0200, Vincent Donnefort wrote:
> From: Vincent Donnefort <vdonnefort@gmail.com>
> 
> This patch fixes kernel NULL pointer BUG introduced by the following commit:
> b667cf488aa9476b0ab64acd91f2a96f188cfd21
> gpio: ich: Add support for multiple register addresses.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>

Things seem much happier now!  Thank you sir!

Tested-by: Eric Paris <eparis@redhat.com>

> 
> diff --git a/drivers/gpio/gpio-ich.c b/drivers/gpio/gpio-ich.c
> index e73c675..7030422 100644
> --- a/drivers/gpio/gpio-ich.c
> +++ b/drivers/gpio/gpio-ich.c
> @@ -305,6 +305,8 @@ static struct ichx_desc ich6_desc = {
>  
>  	.ngpio = 50,
>  	.have_blink = true,
> +	.regs = ichx_regs,
> +	.reglen = ichx_reglen,
>  };
>  
>  /* Intel 3100 */
> @@ -324,6 +326,8 @@ static struct ichx_desc i3100_desc = {
>  	.uses_gpe0 = true,
>  
>  	.ngpio = 50,
> +	.regs = ichx_regs,
> +	.reglen = ichx_reglen,
>  };
>  
>  /* ICH7 and ICH8-based */


