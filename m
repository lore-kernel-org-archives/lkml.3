Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaF0Gr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:47:58 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:54409 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbaF0Gr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:47:56 -0400
Message-ID: <53AD1368.8020305@st.com>
Date: Fri, 27 Jun 2014 08:47:04 +0200
From: Patrice Chotard <patrice.chotard@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: pinctrl-st.c:  Cleaning up values that are never
 used
References: <1403790272-11635-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1403790272-11635-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.18]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-27_03:2014-06-26,2014-06-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard

On 06/26/2014 03:44 PM, Rickard Strandqvist wrote:
> Remove variable that are never used
>
> This was found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/pinctrl/pinctrl-st.c |    6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> index 1bd6363bc9..d3bd687 100644
> --- a/drivers/pinctrl/pinctrl-st.c
> +++ b/drivers/pinctrl/pinctrl-st.c
> @@ -1178,9 +1178,7 @@ static int st_pctl_dt_parse_groups(struct device_node *np,
>   	const __be32 *list;
>   	struct property *pp;
>   	struct st_pinconf *conf;
> -	phandle phandle;
>   	struct device_node *pins;
> -	u32 pin;
>   	int i = 0, npins = 0, nr_props;
>   
>   	pins = of_get_child_by_name(np, "st,pins");
> @@ -1218,8 +1216,8 @@ static int st_pctl_dt_parse_groups(struct device_node *np,
>   		conf = &grp->pin_conf[i];
>   
>   		/* bank & offset */
> -		phandle = be32_to_cpup(list++);
> -		pin = be32_to_cpup(list++);
> +		be32_to_cpup(list++);
> +		be32_to_cpup(list++);
>   		conf->pin = of_get_named_gpio(pins, pp->name, 0);
>   		conf->name = pp->name;
>   		grp->pins[i] = conf->pin;

Acked-by: Patrice Chotard <patrice.chotard@st.com>

Thanks
