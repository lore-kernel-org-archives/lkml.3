Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3DLJdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:33:53 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:53250 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733Ab3DLJdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:33:51 -0400
Message-ID: <5167D4E3.5020504@stericsson.com>
Date: Fri, 12 Apr 2013 11:33:23 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT][PATCH] regulator: ab8500: Fix voltage_mask for AB8505_LDO_AUDIO
References: <1365752005.15003.1.camel@phoenix>
In-Reply-To: <1365752005.15003.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 09:33 AM, Axel Lin wrote:
> The voltage_mask and voltage_shift settings of AB8505_LDO_AUDIO are not matched.
> It looks like a typo in the voltage_mask settings.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Lee and Bengt,
> I don't have the datasheet. Can you confirm if this fix is correct?
>
> Thanks,
> Axel
Yes it is correct. The voltage bits are in 0x70. Thank you!

Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
>   drivers/regulator/ab8500.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
> index ea182d3..b81ff04 100644
> --- a/drivers/regulator/ab8500.c
> +++ b/drivers/regulator/ab8500.c
> @@ -1130,7 +1130,7 @@ static struct ab8500_regulator_info
>   		.update_val		= 0x02,
>   		.voltage_bank		= 0x01,
>   		.voltage_reg		= 0x57,
> -		.voltage_mask		= 0x7,
> +		.voltage_mask		= 0x70,
>   		.voltage_shift		= 4,
>   	},
>   	[AB8505_LDO_ANAMIC1] = {

