Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaFWJqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:46:16 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:56221 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaFWJqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:46:01 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Beniamino Galvani <b.galvani@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, "Heiko Stuebner" <heiko@sntech.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 2/5] regulator: act8865: set correct number of
 regulators in pdata
Thread-Topic: [PATCH 2/5] regulator: act8865: set correct number of
 regulators in pdata
Thread-Index: AQHPji9lYp3WBs2nPUmK65spLELmxJt+c2qw
Date: Mon, 23 Jun 2014 09:45:51 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436419D1B5CB1@penmbx01>
References: <1403451105-31929-1-git-send-email-b.galvani@gmail.com>
 <1403451105-31929-3-git-send-email-b.galvani@gmail.com>
In-Reply-To: <1403451105-31929-3-git-send-email-b.galvani@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Beniamino Galvani [mailto:b.galvani@gmail.com]
> Sent: Sunday, June 22, 2014 11:32 PM
> To: Liam Girdwood; Mark Brown
> Cc: Yang, Wenyou; Rob Herring; Pawel Moll; Mark Rutland; Ian Campbell;
> Kumar Gala; Heiko Stuebner; devicetree@vger.kernel.org; linux-
> doc@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; Beniamino Galvani
> Subject: [PATCH 2/5] regulator: act8865: set correct number of
> regulators in pdata
> 
> When platform data is populated from DT all the regulators are
> instantiated and the value of num_regulators should be the number of
> all available regulators rather than the number of matched ones.
> 
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> ---
>  drivers/regulator/act8865-regulator.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/act8865-regulator.c
> b/drivers/regulator/act8865-regulator.c
> index fe2c038..b03a0e8 100644
> --- a/drivers/regulator/act8865-regulator.c
> +++ b/drivers/regulator/act8865-regulator.c
> @@ -230,7 +230,7 @@ static int act8865_pdata_from_dt(struct device *dev,
>  	if (!pdata->regulators)
>  		return -ENOMEM;
> 
> -	pdata->num_regulators = matched;
> +	pdata->num_regulators = ARRAY_SIZE(act8865_matches);
>  	regulator = pdata->regulators;
> 
>  	for (i = 0; i < ARRAY_SIZE(act8865_matches); i++) {
> --
> 1.7.10.4


Tested on at91-sama5d3_xplained with ACT8865

Tested-by Wenyou.Yang <wenyou.yang@atmel.com>

Best Regards,
Wenyou Yang

