Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaK1Lye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:54:34 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10886 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaK1Lyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:54:31 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-82-54786274547c
Content-transfer-encoding: 8BIT
Message-id: <1417175667.18249.26.camel@AMDC1943>
Subject: Re: [PATCH v4 2/7] regulator: dt-bindings: Document the ena-gpios
 property
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 28 Nov 2014 12:54:27 +0100
In-reply-to: <20141128112116.GG7712@sirena.org.uk>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
 <1417087253-12306-3-git-send-email-k.kozlowski@samsung.com>
 <20141127183058.GB7712@sirena.org.uk> <1417165784.18249.15.camel@AMDC1943>
 <20141128112116.GG7712@sirena.org.uk>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xy7olSRUhBneWGFlsnLGe1WLqwyds
	FvOPnGO16H/8mtnibNMbdov7X48yWny70sFksenxNVaLy7vmsFnMOL+PyWLtkbvsDtweO2fd
	ZffYtKqTzePOtT1sHpuX1Hv0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxuWXa9gKPrFVTJv5
	j62BcQNrFyMHh4SAicSKV1ldjJxAppjEhXvr2UBsIYGljBJz1+eB2LwCghI/Jt9jASlnFpCX
	OHIpGyTMLKAuMWneIuYuRi6g8s+MEju3rGaEqDeQ+L7yKSuILSwQKnHq408wm03AWGLz8iVg
	80UElCWuft/LAtLMLNDMLPHvwT+wIhYBVYlfZ76CFXEKGEkcnfqVCeKgX4wSf34WQtysLNHY
	7zaBUWAWkvNmIZw3C8l5CxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKExMPXHYxLj1kd
	YhTgYFTi4Z1gWREixJpYVlyZe4hRgoNZSYTXPR4oxJuSWFmVWpQfX1Sak1p8iJGJg1OqgTHm
	6cxTderxu4wUTGdeVLiQbz3LyvFx8NFm66fvUn9YesV5VT1mDlhi9mnWWobip88STExMOBbv
	lHkT+nPts0d9tm2OuWp83nbnNlnfNvVdLtf8f5vWnba+D/a5zV5zfjOcnTPPRja36eIBv4uL
	7XYtvht4YsYpM1+Gf+0OLf3JEVu3BlsoaiuxFGckGmoxFxUnAgAxv06QZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-11-28 at 11:21 +0000, Mark Brown wrote:
> On Fri, Nov 28, 2014 at 10:09:44AM +0100, Krzysztof Kozlowski wrote:
> 
> > I understand your concerns here however I didn't want to overengineer
> > this. Is the same GPIO (on more complex PMICs) used in different
> > contexts? Like enable control and something more in the same time?
> 
> Yes, and it's often reprogrammable at runtime.

I have doubts if generalized code could support such configuration...

> 
> > Something like:
> >  struct regulator_desc desc {
> >  	.name		= "LDO1
> >  	.of_match	= of_match_ptr("LDO1"),
> >  	.regulators_node = of_match_ptr("voltage-regulators"),
> >  	.ops		= &max77686_ldo_ops,
> > +	.of_ena_gpio	= of_match_ptr("ena-gpios"),
> >  ...
> >  }
> 
> Yes, and note that this also means existing bindings can use the core
> code.

Thanks for idea,
Krzysztof

