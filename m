Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbaFZMEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:04:49 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:41312 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757576AbaFZMEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:04:47 -0400
Message-ID: <53AC0C22.9010108@st.com>
Date: Thu, 26 Jun 2014 14:03:46 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
Cc: Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: pinctrl-st.c:  Cleaning up if unsigned is less
 than zero
References: <1403782369-10201-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1403782369-10201-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-26_04:2014-06-26,2014-06-26,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard,

On 06/26/2014 01:32 PM, Rickard Strandqvist wrote:
> Remove checking if a unsigned is less than zero
> 
> This was found using a static code analysis program called
> cppcheck.
> 
> Signed-off-by: Rickard Strandqvist
> <rickard_strandqvist@spectrumdigital.se>

You can add my:
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks,
Maxime
> --- drivers/pinctrl/pinctrl-st.c |    2 +- 1 file changed, 1
> insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-st.c
> b/drivers/pinctrl/pinctrl-st.c index 1bd6363bc9..f4ee1b1 100644 ---
> a/drivers/pinctrl/pinctrl-st.c +++ b/drivers/pinctrl/pinctrl-st.c 
> @@ -1256,7 +1256,7 @@ static int st_pctl_parse_functions(struct
> device_node *np, func = &info->functions[index]; func->name =
> np->name; func->ngroups = of_get_child_count(np); -	if
> (func->ngroups <= 0) { +	if (func->ngroups == 0) { 
> dev_err(info->dev, "No groups defined\n"); return -EINVAL; }
> 
