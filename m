Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934580Ab3DOJM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 05:12:28 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:57715 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934370Ab3DOJM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 05:12:27 -0400
Message-ID: <516BC473.2070907@stericsson.com>
Date: Mon, 15 Apr 2013 11:12:19 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT] regulator: ab8500: Fix voltage_shift setting for
 AB8540_LDO_DMIC
References: <1366015011.13029.1.camel@phoenix>
In-Reply-To: <1366015011.13029.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 10:36 AM, Axel Lin wrote:
> The voltage_mask is 0xc0, thus we need to set voltage_shift = 6 to get correct
> selector in get_voltage_sel and set_voltage_sel.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
The patch is correct. Voltage selection is done with 0xc0.

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
> Hi Bengt,
> I don't have the datasheet. Can you confirm if this fix is correct?
>
> BTW, can you also review a couple patches for ab8500 and ab8500-ext I sent a few
> days ago? I ask this because now I have more patches that may depend on previous
> patches.
>
> Thanks,
> Axel
>
>   drivers/regulator/ab8500.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index b81ff04..0a62ef9 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -1729,6 +1729,7 @@ static struct ab8500_regulator_info
>   		.voltage_bank		= 0x03,
>   		.voltage_reg		= 0x83,
>   		.voltage_mask		= 0xc0,
> +		.voltage_shift		= 6,
>   	},
>   
>   	/*

