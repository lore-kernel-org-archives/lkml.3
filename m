Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3KUO1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:27:22 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20508 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3KUO1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:27:17 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-d1-528e1843e7e6
Message-id: <1385044033.748.29.camel@AMDC1943>
Subject: Re: [PATCH v2 4/5] regulator: max14577: Add regulator driver for Maxim
 14577
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Thu, 21 Nov 2013 15:27:13 +0100
In-reply-to: <3987325.g4jkYp0g0H@amdc1032>
References: <1384956732-19526-1-git-send-email-k.kozlowski@samsung.com>
 <1384956732-19526-5-git-send-email-k.kozlowski@samsung.com>
 <3176793.htnYthLYeH@amdc1032> <3987325.g4jkYp0g0H@amdc1032>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t/xa7rOEn1BBiePS1oc3KppsXHGelaL
	qQ+fsFlc//Kc1WL+kXOsFhNXTma2OPBnB6PFuVcrGS3ONr1ht7j/9SijxbcrHUwWmx5fY7VY
	2LaExeLyrjlsFmuP3GW3uN24gs1iwvS1LBaHVxxgslj3cjqLxeluVotXB9tYHEQ91sxbw+ix
	4PMVdo8J/Z8YPXbOusvusXL5FzaPzSu0PDat6mTzeLV6JqvHnWt72DzmnQz02Lyk3qNvyypG
	j8+b5Dw2zg0N4IvisklJzcksSy3St0vgypg7awtzwTH2it2PbrE2MP5g7WLk5JAQMJE40wBj
	i0lcuLeerYuRi0NIYCmjxILNR1kgnM+MEts3LmAEqeIV0JO4eeIMmC0sEC7xZ+saFhCbTcBY
	YvPyJWwgtoiAhcTaFW/B4swCP1gl+l45djFycLAIqEr8eCEHYnIKaEkcPSsCMf4wo8SS7ZvZ
	IcrVJSbNW8QMcZCSxO72Tqi4vMTmNW+ZIU4QlPgx+R7LBEaBWUhaZiEpm4WkbAEj8ypG0dTS
	5ILipPRcI73ixNzi0rx0veT83E2MkPj9uoNx6TGrQ4wCHIxKPLwPnvYECbEmlhVX5h5ilOBg
	VhLhFRLtCxLiTUmsrEotyo8vKs1JLT7EyMTBKdXAqPY9JilLh3nt7FUiflK7ui/qsIkZfF9R
	t6sv1oF/hZNPfdDnpSxFpS0BrIFysTLyvo3+OZuPcD26YP8hf1b8E3NG3zKxD5NtpeaWVF3O
	bIoxUu07/Ho78wamXdWtH5c+uRXXN5V5zbwZ7Cdf13x/I1wpsGoX73u15BcWb2tXTZ1ZxMjL
	/SVXiaU4I9FQi7moOBEANpsxFL0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-20 at 18:58 +0100, Bartlomiej Zolnierkiewicz wrote:
> Err..
> 
> > I'm missing something obvious "info" is redundant and can be removed
> > altogether.
> > 
> > Best regards,
> > --
> > Bartlomiej Zolnierkiewicz
> > Samsung R&D Institute Poland
> > Samsung Electronics
> > 
> > > +	for (i = 0; i < pdata->num_regulators; i++) {
> > > +		int id = pdata->regulators[i].id;
> > > +
> > > +		config.init_data = pdata->regulators[i].initdata;
> > > +		config.of_node = pdata->regulators[i].of_node;
> > > +
> > > +		info->regulators[i] = devm_regulator_register(&pdev->dev,
> > > +				&supported_regulators[id], &config);
> > > +		if (IS_ERR(info->regulators[i])) {
> 
> This code actually reads from "info" but it can be fixed trivially
> to not require "info".

You're right, it can be removed. The info was a left-over from 3.10
where there isn't devm_regulator_register(). Thanks for review.


Best regards,
Krzysztof

