Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3JJLKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:10:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13506 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3JJLKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:10:50 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-f4-52568b397b6e
Message-id: <52568B3D.7020209@samsung.com>
Date: Thu, 10 Oct 2013 20:10:53 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sbkim73@samsung.com" <sbkim73@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] regulator: s5m8767: Modify parse_dt function to parse
 data related to ramp
References: <1381369296-17101-1-git-send-email-cw00.choi@samsung.com>
 <20131010102826.GG26954@e106331-lin.cambridge.arm.com>
In-reply-to: <20131010102826.GG26954@e106331-lin.cambridge.arm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWyRsSkUNeyOyzI4PgLQYupD5+wWcw/co7V
	4mzTG3aLb1c6mCwu75rDZrH0+kUmi4srvjA5sHusmbeG0WPnrLvsHptWdbJ59G1ZxejxeZNc
	AGsUl01Kak5mWWqRvl0CV8a2P8EFM4Qqml/vYGlgfMfXxcjJISFgIrFl/kMmCFtM4sK99Wxd
	jFwcQgJLGSVedK9hgynad+s9E0RiOqPE19vfoZxXjBLH589g72Lk4OAV0JLovuAA0sAioCrx
	cPphRhCbDSi8/8UNsEGiAmESK6dfYQGxeQUEJX5MvgdmiwioS/Ts+sICMpNZYBuTxJnD98Ea
	hAVSJS4cPwx2npBAncTEC8vBbE4BZ4m2VdPBbGYBHYn9rdPYIGx5ic1r3jKDDJIQuMQuMWHz
	HnaIiwQkvk0+xAJyqISArMSmA8wQn0lKHFxxg2UCo9gsJDfNQjJ2FpKxCxiZVzGKphYkFxQn
	pRcZ6hUn5haX5qXrJefnbmIExt3pf896dzDePmB9iDEZaOVEZinR5Hxg3OaVxBsamxlZmJqY
	GhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgfE6p3Gy4qy5nzv1Rd+9
	6E1+1P9yg6zcy9/uzfPyli6QmW7S+mzX3flzQ3sEp+p9yOh8KRMQE6i4+5n00kR39jS9tPlc
	D5zm2ql6/pS3LBQ9l+D0M+d4utGqa16PKkq//D771iz6RZh4kevKfJfTy3etmmJz1dsrfLlf
	+HmLlSqT2NyPCqzh2a7EUpyRaKjFXFScCABpQ+xG0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQV3L7rAgg/4uDoupD5+wWcw/co7V
	4mzTG3aLb1c6mCwu75rDZrH0+kUmi4srvjA5sHusmbeG0WPnrLvsHptWdbJ59G1ZxejxeZNc
	AGtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAd
	SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMbX+CC2YIVTS/3sHSwPiO
	r4uRk0NCwERi3633TBC2mMSFe+vZuhi5OIQEpjNKfL39nQnCecUocXz+DPYuRg4OXgEtie4L
	DiANLAKqEg+nH2YEsdmAwvtf3GADsUUFwiRWTr/CAmLzCghK/Jh8D8wWEVCX6Nn1hQVkJrPA
	NiaJM4fvgzUIC6RKXDh+GOwKIYE6iYkXloPZnALOEm2rpoPZzAI6Evtbp7FB2PISm9e8ZZ7A
	KDALyY5ZSMpmISlbwMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4qp9J7WBc2WBxiFGA
	g1GJh7eiLDRIiDWxrLgy9xCjBAezkgjvnPKwICHelMTKqtSi/Pii0pzU4kOMycAgmMgsJZqc
	D0w4eSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAKM5jyjTV
	rHjfldADR8RVE99rnpB3rPN5s/n63UKJ6LZk1TffX9f+9oxvE/Cx/sLveXB7yCZBK6Wlq+Ki
	vpo0Xt1qd+3xN8HoOR8ich6IN3xy1T++9skLu1J/gxAJla8G3yze5Ly7NG/LrQVvVQMPTz1x
	wTdeKda08+n0zoCLAh3+yTYnL18qVGIpzkg01GIuKk4EAIUVkaAuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 07:28 PM, Mark Rutland wrote:
> On Thu, Oct 10, 2013 at 02:41:35AM +0100, Chanwoo Choi wrote:
>> This patch parse 'buck[2-4]_ramp_enable and buck_ramp_delay' platform data
>> from dts file.
> 
> Why?
> 
> What do these describe? Why do we need them?

Turn on ramp control of buck2/3/4.

> 
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/regulator/s5m8767.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
>> index c24448b..cb6cdb3 100644
>> --- a/drivers/regulator/s5m8767.c
>> +++ b/drivers/regulator/s5m8767.c
>> @@ -640,6 +640,22 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
>>  		return -EINVAL;
>>  	}
>>  
>> +	if (of_get_property(pmic_np, "s5m8767,pmic-buck2-ramp-enable", NULL))
>> +		pdata->buck2_ramp_enable = true;
> 
> Please describe what this is and why we need it.

buck2/3/4_ramp_enable is used to protect the chip from the in-rush current.

> 
> For reading boolean proeprties, use of_property_read_bool.

I'll fix it.

> 
>> +
>> +	if (of_get_property(pmic_np, "s5m8767,pmic-buck3-ramp-enable", NULL))
>> +		pdata->buck3_ramp_enable = true;
>> +
>> +	if (of_get_property(pmic_np, "s5m8767,pmic-buck4-ramp-enable", NULL))
>> +		pdata->buck4_ramp_enable = true;
>> +
>> +	if (pdata->buck2_ramp_enable || pdata->buck3_ramp_enable
>> +			|| pdata->buck4_ramp_enable) {
>> +		if (of_property_read_u32(pmic_np, "s5m8767,pmic-buck-ramp-delay",
>> +				&pdata->buck_ramp_delay))
>> +			pdata->buck_ramp_delay = 0;
> 
> Why not initialise pdata->buck_ramp_delay to 0 beforehand?
> 
> That way you don't need to check the return value of
> of_property_read_u32 here.
> 
> I note that pdata->buck_ramp_delay is an int, not a u32. Please use a
> u32 temporary variable.

I'll fix it

> 
>> +	}
>> +
> 
> NAK. None of these seem to be documented in mainline's
> Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt, nor
> does documentation seem to be added here. Until there's some description
> of what these are and why they're needed, I don't think they're
> suitable.

I'll add description about this patch.


