Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3DKGoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 02:44:23 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:58863 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083Ab3DKGoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 02:44:22 -0400
Message-ID: <51665BB9.6030101@stericsson.com>
Date: Thu, 11 Apr 2013 08:44:09 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regulator: ab8500: Unregister ab8500-ext regulators
 in probe() failure path
References: <1365653058.17060.0.camel@phoenix> <1365653143.17060.2.camel@phoenix>
In-Reply-To: <1365653143.17060.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 06:05 AM, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Looks good to me.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
>   drivers/regulator/ab8500.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index c200f8b..ea182d3 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -3172,8 +3172,11 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
>   	for (i = 0; i < abx500_regulator.info_size; i++) {
>   		err = ab8500_regulator_register(pdev, &pdata->regulator[i],
>   						i, NULL);
> -		if (err < 0)
> +		if (err < 0) {
> +			if (!is_ab8505(ab8500))
> +				ab8500_ext_regulator_exit(pdev);
>   			return err;
> +		}
>   	}
>   
>   	return 0;

