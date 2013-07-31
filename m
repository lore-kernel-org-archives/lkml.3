Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab3GaLXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:23:37 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:40712 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756147Ab3GaLXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:23:36 -0400
Message-ID: <51F8F10F.4040403@st.com>
Date: Wed, 31 Jul 2013 12:12:15 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH 2/2] pinctrl: st: Staticize local symbols
References: <1375071776-29037-1-git-send-email-sachin.kamat@linaro.org> <1375071776-29037-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1375071776-29037-2-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/13 05:22, Sachin Kamat wrote:
> Symbols used only in this file are made static.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-st.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> index 6246d7a..2a10a31 100644
> --- a/drivers/pinctrl/pinctrl-st.c
> +++ b/drivers/pinctrl/pinctrl-st.c
> @@ -288,8 +288,8 @@ struct st_pinctrl {
>  
>  /* SOC specific data */
>  /* STiH415 data */
> -unsigned int stih415_input_delays[] = {0, 500, 1000, 1500};
> -unsigned int stih415_output_delays[] = {0, 1000, 2000, 3000};
> +static unsigned int stih415_input_delays[] = {0, 500, 1000, 1500};
> +static unsigned int stih415_output_delays[] = {0, 1000, 2000, 3000};
>  
>  #define STIH415_PCTRL_COMMON_DATA				\
>  	.rt_style	= st_retime_style_packed,		\
> @@ -324,7 +324,7 @@ static const struct st_pctl_data  stih415_right_data = {
>  };
>  
>  /* STiH416 data */
> -unsigned int stih416_delays[] = {0, 300, 500, 750, 1000, 1250, 1500,
> +static unsigned int stih416_delays[] = {0, 300, 500, 750, 1000, 1250, 1500,
>  			1750, 2000, 2250, 2500, 2750, 3000, 3250 };
>  
>  static const struct st_pctl_data  stih416_data = {
> @@ -811,7 +811,7 @@ static int st_pmx_get_funcs_count(struct pinctrl_dev *pctldev)
>  	return info->nfunctions;
>  }
>  
> -const char *st_pmx_get_fname(struct pinctrl_dev *pctldev,
> +static const char *st_pmx_get_fname(struct pinctrl_dev *pctldev,
>  	unsigned selector)
>  {
>  	struct st_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> 
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

