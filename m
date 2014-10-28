Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbaJ1Ik7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:40:59 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53241 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaJ1Ikz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:40:55 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-dc-544f56945a30
Message-id: <1414485650.24949.10.camel@AMDC1943>
Subject: Re: [PATCH 2/8] regulator: max77686: Remove support for board files
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Tue, 28 Oct 2014 09:40:50 +0100
In-reply-to: <20141028003709.GL18557@sirena.org.uk>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
 <1414422226-10948-3-git-send-email-k.kozlowski@samsung.com>
 <20141028003709.GL18557@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t/xq7pTwvxDDHrmm1tsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6w6F1wlc3ibNMbdov7X48yWny70sFksenxNVaLy7vmsFnM
	OL+PyeL2ZV6LtUfusluc7mZ1EPBoae5h8/j7/DqLx99VL5g9ds66y+6xaVUnm8eda3vYPOad
	DPTYvKTeo2/LKkaPz5vkAriiuGxSUnMyy1KL9O0SuDJ2XO5mKjjCU/Fn0n3GBsZvnF2MnBwS
	AiYSF9Y8ZIOwxSQu3FsPZHNxCAksZZRY/3E1I0hCSOAzo8TqaTIgNq+AgcSWff+ZQWxhAR+J
	5RPPgzWzCRhLbF6+BMwWEVCWuPp9LwvIIGaBBywS+xevZQdJsAioSiy+dhbM5gRqWH/gLCvE
	tnWMElcuTgFLMAuoS0yatwhoAwfQScoSjf1uEIsFJX5MvscCUSIvsXnNW+YJjAKzkHTMQlI2
	C0nZAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghkfZlB+PiY1aHGAU4GJV4eHdM8w0R
	Yk0sK67MPcQowcGsJMK7XMU/RIg3JbGyKrUoP76oNCe1+BAjEwenVAPj3OcSa0Un89geDbp4
	+cIzyz8SXf0/J96Z967/9seni45rnWU98KXh5+lN1cqzrx8pW/F6ivmSZdM48+OO94eV8z9s
	cwnV9hc0t796QG52F7ts7NybDK3753od5Jy//YjRIX+nRYkhBo/euCktzT9h4v7wN0uIRfCL
	4AWCfuLxx11jTlhs1N4xWYmlOCPRUIu5qDgRAKuvzySSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-10-28 at 00:37 +0000, Mark Brown wrote:
> On Mon, Oct 27, 2014 at 04:03:40PM +0100, Krzysztof Kozlowski wrote:
> > The driver is used only on Exynos4 based boards with DTS support.
> > Convert the driver to DTS-only version.
> 
> This doesn't seem like a particularly persuasive reason honestly and if
> you're going to mess around with this stuff please fix it properly...
> 
> >  struct max77686_data {
> > +	struct max77686_regulator_data *regulators;
> > +	int num_regulators;
> > +
> 
> ...the only reason for this array and the specification of the number of
> regulators is to make platform data easier to do...
> 
> > -	pdata->num_regulators = ARRAY_SIZE(regulators);
> > +	max77686->num_regulators = ARRAY_SIZE(regulators);
> 
> ...and indeed we wind up with a constant here anyway.  At the very least
> it'd be better to pull the parsing into the registration, right now we
> have the code still laid out for platform data so it's hard to see it as
> a win in cleanup terms.  If we're not translating into platform data we
> shouldn't need to keep this stuff around outside of the probe function.
> 
> What would be even better would be to convert to use the standard DT
> parsing with regulators_node and of_match specified in the descriptor
> and then delete most of this code entirely.

You're right, there's a lot to clean in this driver.

The only caveat is that I can't test the max77802 regulator so I
refrained from doing intrusive changes to it. I'll try to clean up both
drivers and make max77802 as RFT.

Best regards,
Krzysztof


