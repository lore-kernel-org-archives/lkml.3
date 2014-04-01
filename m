Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaDAHCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:02:10 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50185 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaDAHCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:02:08 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-80-533a646dfb00
Message-id: <1396335724.8272.0.camel@AMDC1943>
Subject: Re: [PATCH 2/2] regulator: s2mps11: Don't check enable_shift before
 setting enable ramp rate
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Sachin Kamat <sachin.kamat@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 01 Apr 2014 09:02:04 +0200
In-reply-to: <1395389784.29259.2.camel@phoenix>
References: <1395389720.29259.1.camel@phoenix>
 <1395389784.29259.2.camel@phoenix>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xK7p5KVbBBitlLY7M+cpsMfXhEzaL
	b1c6mCwu75rDZnHyTy+jxcUVX5gc2Dx2zrrL7tH2s8xj06pONo871/awefRtWcXo8XmTXABb
	FJdNSmpOZllqkb5dAldGw53D7AVTuCqWfpzO1MA4j6OLkZNDQsBEYsP2H8wQtpjEhXvr2boY
	uTiEBJYySny795AJwvnMKDF3xjJ2kCpeAT2JCW9uM4HYwgLpEo93dLCB2GwCxhKbly8Bs0UE
	lCRW3b/MAtLMLLCNUeLy6rNgzSwCqhI3dxxjAbE5BfQlVtzoBhrEAbQhWGLHC2+QMLOAusSk
	eYugLlKS2N3eyQ4Rl5fYvOYtM8QNghI/Jt9jmcAoMAtJyywkZbOQlC1gZF7FKJpamlxQnJSe
	a6RXnJhbXJqXrpecn7uJERLiX3cwLj1mdYhRgINRiYfXotwyWIg1say4MvcQowQHs5II75Eo
	q2Ah3pTEyqrUovz4otKc1OJDjEwcnFINjP22ojueP5sj3aqgeHHLZUOT+dNVt4mentvQ0Fbt
	bOay+Fwd86l45w0Xd+kmnndsfm12tPqAl2l8X57gQQmlitdbrj727/Xn/6K3M02xwdL4oLzL
	S3PVtT4ya3T2Pv3DtcyLtSU6IGvqK+dQxkMmc7qqt79ZrmMXbHfTqUDsB9cX56O7Dk84rsRS
	nJFoqMVcVJwIAOcuNVFPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-21 at 16:16 +0800, Axel Lin wrote:
> Current code misses updating the register when enable_shift is 0.
> e.g. S2MPS11_BUCK9_RAMP_SHIFT and S2MPS11_BUCK6_RAMP_EN_SHIFT are 0.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/s2mps11.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

Looks good.
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


> diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
> index 68fd547..e713c16 100644
> --- a/drivers/regulator/s2mps11.c
> +++ b/drivers/regulator/s2mps11.c
> @@ -202,13 +202,11 @@ static int s2mps11_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
>  	if (!ramp_enable)
>  		goto ramp_disable;
>  
> -	if (enable_shift) {
> -		ret = regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
> -					1 << enable_shift, 1 << enable_shift);
> -		if (ret) {
> -			dev_err(&rdev->dev, "failed to enable ramp rate\n");
> -			return ret;
> -		}
> +	ret = regmap_update_bits(rdev->regmap, S2MPS11_REG_RAMP,
> +				 1 << enable_shift, 1 << enable_shift);
> +	if (ret) {
> +		dev_err(&rdev->dev, "failed to enable ramp rate\n");
> +		return ret;
>  	}
>  
>  	ramp_val = get_ramp_delay(ramp_delay);

