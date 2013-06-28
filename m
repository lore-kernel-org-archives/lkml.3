Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3F1KmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:42:05 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:57310 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754931Ab3F1KmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:42:03 -0400
Message-ID: <51CD6743.3050603@st.com>
Date: Fri, 28 Jun 2013 11:36:51 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: st: Fix checking return value of syscon_regmap_lookup_by_phandle()
References: <1372415628.1860.1.camel@phoenix>
In-Reply-To: <1372415628.1860.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thankyou Axel for looking at this.

There is already a patch is submitted for this.
https://lkml.org/lkml/2013/6/26/494 which I have Acked.

Thanks,
srini
On 28/06/13 11:33, Axel Lin wrote:
> syscon_regmap_lookup_by_phandle() returns ERR_PTR on error.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pinctrl/pinctrl-st.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> index 7effedf..f95c82a 100644
> --- a/drivers/pinctrl/pinctrl-st.c
> +++ b/drivers/pinctrl/pinctrl-st.c
> @@ -1299,9 +1299,9 @@ static int st_pctl_probe_dt(struct platform_device *pdev,
>  		return -ENOMEM;
>  
>  	info->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
> -	if (!info->regmap) {
> +	if (IS_ERR(info->regmap)) {
>  		dev_err(info->dev, "No syscfg phandle specified\n");
> -		return -ENOMEM;
> +		return PTR_ERR(info->regmap);
>  	}
>  	info->data = of_match_node(st_pctl_of_match, np)->data;
>  
> 

