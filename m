Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaKCA2I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 19:28:08 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:58426 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaKCA2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 19:28:06 -0500
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: javier.martinez@collabora.co.uk
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <4279c7952ff69e7d5dbf1c7fe5d46703>
X-DNS-TYPE: 1
Message-ID: <5456CC02.1060201@rock-chips.com>
Date: Mon, 03 Nov 2014 08:27:46 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>
CC: Heiko Stuebner <heiko@sntech.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: of: Add support for parsing microvolts
 for suspend state
References: <1414813978-32233-1-git-send-email-dianders@chromium.org> <1414813978-32233-2-git-send-email-dianders@chromium.org> <54549EA6.5060007@collabora.co.uk>
In-Reply-To: <54549EA6.5060007@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/01/2014 04:49 PM, Javier Martinez Canillas wrote:
> Hello Doug,
>
> On 11/01/2014 04:52 AM, Doug Anderson wrote:
>> Leverage all the work that was done in (40e20d6 regulator: of: Add
>> support for parsing regulator_state for suspend state) and throw in
>> the ability to set suspend microvolts from the device tree.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>   drivers/regulator/of_regulator.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
>> index f0d19fc..7fe93c5 100644
>> --- a/drivers/regulator/of_regulator.c
>> +++ b/drivers/regulator/of_regulator.c
>> @@ -107,6 +107,10 @@ static void of_get_regulation_constraints(struct device_node *np,
>>   					"regulator-off-in-suspend"))
>>   			suspend_state->disabled = true;
>>   
>> +		if (!of_property_read_u32(suspend_np,
>> +					"regulator-suspend-microvolt", &pval))
>> +			suspend_state->uV = pval;
>> +
>>   		of_node_put(suspend_np);
>>   		suspend_state = NULL;
>>   		suspend_np = NULL;
>>
> Looks good to me.
>
> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>
> Best regards,
> Javier
>
>
>
Reviewed-by: Chris Zhong <zyw@rock-chips.com>
