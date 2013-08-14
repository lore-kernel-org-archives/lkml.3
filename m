Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab3HNQ2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:28:35 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:62979 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352Ab3HNQ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:28:34 -0400
MIME-Version: 1.0
X-Originating-IP: [218.164.143.112]
In-Reply-To: <20130814161403.GA13601@elgon.mountain>
References: <20130814161403.GA13601@elgon.mountain>
Date: Thu, 15 Aug 2013 00:28:33 +0800
Message-ID: <CAFRkauAL9v1AHW+M4JC4uFpf+Oo3LLTb7Rp80CaOP2AWED+nTg@mail.gmail.com>
Subject: Re: [patch] regulator: 88pm800: forever loop in pm800_regulator_probe()
From: Axel Lin <axel.lin@ingics.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/15 Dan Carpenter <dan.carpenter@oracle.com>:
> This is supposed to be testing "i < ARRAY_SIZE()" instead of just
> "ARRAY_SIZE()".
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
> index 58e9b74..3459f60 100644
> --- a/drivers/regulator/88pm800.c
> +++ b/drivers/regulator/88pm800.c
> @@ -302,7 +302,7 @@ static int pm800_regulator_probe(struct platform_device *pdev)
>                 unsigned int count = 0;
>
>                 /* Check whether num_regulator is valid. */
> -               for (i = 0; ARRAY_SIZE(pdata->regulators); i++) {
> +               for (i = 0; i < ARRAY_SIZE(pdata->regulators); i++) {
>                         if (pdata->regulators[i])
>                                 count++;
>                 }
Oops. My bad. Thanks for the fix.
Reviewed-by: Axel Lin <axel.lin@ingics.com>
