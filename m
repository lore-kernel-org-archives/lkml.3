Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbaBULO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:14:26 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49297 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbaBULOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:14:25 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-64-5307350efe58
Message-id: <1392981261.19813.6.camel@AMDC1943>
Subject: Re: [PATCH] regulator: max14577: Fix invalid return value on DT parse
 success
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 21 Feb 2014 12:14:21 +0100
In-reply-to: <CAK9yfHyihSUdQFjKVZ1-c9iq4NKDWymbQKFgeBDMd-QWNYR61w@mail.gmail.com>
References: <1392909541-10285-1-git-send-email-k.kozlowski@samsung.com>
 <CAK9yfHxQOroe2JZVs8roBVGxLXMMKdtA21JVjVW7z6Ndf-mytg@mail.gmail.com>
 <1392979375.19813.3.camel@AMDC1943>
 <CAK9yfHyihSUdQFjKVZ1-c9iq4NKDWymbQKFgeBDMd-QWNYR61w@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xa7p8puzBBh29FhZTHz5hs/h2pYPJ
	4vKuOWwWJ//0MjqweOycdZfdY9OqTjaPO9f2sHl83iQXwBLFZZOSmpNZllqkb5fAlfFvxUHW
	gq3CFQu+z2JqYLzM18XIySEhYCKxtfcFM4QtJnHh3nq2LkYuDiGBpYwSRya/hHI+M0rc+H+A
	DaSKV0BfYvKNVywgtrBAhMTfe3vYQWw2AWOJzcuXgNWICGhJvOxezgRiMwvkSxxZ1wlWwyKg
	KnHq8yewGk6BYIkNO7awQiz4zShxc80HdogGdYlJ8xZBnaQksbu9EyouL7F5zVtmiCMEJX5M
	vscygVFgFpKWWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJIC/7GBcfMzq
	EKMAB6MSD2+BBFuwEGtiWXFl7iFGCQ5mJRHeg/rswUK8KYmVValF+fFFpTmpxYcYmTg4pRoY
	462lz51ZO63r+Z36ZycnT4znnGSQXmUT73Rnc41i9PN1XP8a1zJeyz22O+Cupny+sL1cku1H
	0wdyEnJBpjyGzYWlKxUMfvCU/ZF0mrN+7f91FX13opxNdhtP/veIqyQrfKq6xGYdE6u/55lm
	PLZ5qpoVH/qvQJT5aO1rsycqDEsnMM+9+ihNiaU4I9FQi7moOBEABbq+FD4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 16:25 +0530, Sachin Kamat wrote:
> On 21 February 2014 16:12, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > On Fri, 2014-02-21 at 15:54 +0530, Sachin Kamat wrote:
> >> Hi Krzysztof,
> >>
> >> On 20 February 2014 20:49, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> >> > This fixes bug introduced in 667a6b7a (regulator: max14577: Add missing
> >> > of_node_put). The DTS parsing function returned number of matched
> >> > regulators as success status which then was compared against 0 in probe.
> >> >
> >> > Result was a probe fail after successful parsing the DTS:
> >> > max14577-regulator: probe of max14577-regulator failed with error 2
> >> >
> >> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> >> > ---
> >> >  drivers/regulator/max14577.c |    4 +++-
> >> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
> >> > index 186df8785a91..6ba11a8dd23d 100644
> >> > --- a/drivers/regulator/max14577.c
> >> > +++ b/drivers/regulator/max14577.c
> >> > @@ -168,11 +168,13 @@ static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev)
> >> >                         MAX14577_REG_MAX);
> >> >         if (ret < 0) {
> >> >                 dev_err(&pdev->dev, "Error parsing regulator init data: %d\n", ret);
> >> > +               of_node_put(np);
> >> > +               return ret;
> >> >         }
> >> >
> >> >         of_node_put(np);
> >> >
> >> > -       return ret;
> >> > +       return 0;
> >> >  }
> >>
> >> Instead of so many changes here, you could simply make the following change
> >> in the max14577_regulator_probe function.
> >>
> >> ret = max14577_regulator_dt_parse_pdata(pdev);
> >> if (ret < 0)
> >>         return ret;
> >
> > That still wouldn't be sufficient because later in probe() the 'ret' is
> > not reassigned (if devm_regulator_register succeeds) and it is directly
> > returned at the probe() end. So still the number of matched regulators
> > would be returned as probe result.
> 
> Ah, you are right. In that case how about the following:
> 
> -  if (ret < 0) {
> + if (ret < 0)
>       dev_err(&pdev->dev, "Error parsing regulator init data: %d\n", ret);
> -  }
> + else
> +      ret = 0;
> 
> I am just trying to see if we can avoid any code duplication.

Looks good. Thanks for idea, I'll send v2.

Best regards,
Krzysztof

