Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbaFZLsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:48:04 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61785 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaFZLsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:48:01 -0400
Message-ID: <53AC086B.80406@linaro.org>
Date: Thu, 26 Jun 2014 12:47:55 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>
CC: devicetree@vger.kernel.org, kernel@stlinux.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: pinctrl-st.c: Cleaning up if unsigned is less
 than zero
References: <1403782369-10201-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1403782369-10201-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 26/06/14 12:32, Rickard Strandqvist wrote:
> Remove checking if a unsigned is less than zero
>
> This was found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/pinctrl/pinctrl-st.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> index 1bd6363bc9..f4ee1b1 100644
> --- a/drivers/pinctrl/pinctrl-st.c
> +++ b/drivers/pinctrl/pinctrl-st.c
> @@ -1256,7 +1256,7 @@ static int st_pctl_parse_functions(struct device_node *np,
>   	func = &info->functions[index];
>   	func->name = np->name;
>   	func->ngroups = of_get_child_count(np);
> -	if (func->ngroups <= 0) {
> +	if (func->ngroups == 0) {

Makes sense

Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>


>   		dev_err(info->dev, "No groups defined\n");
>   		return -EINVAL;
>   	}
>
