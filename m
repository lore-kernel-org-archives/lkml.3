Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaJ0Nps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:45:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62949 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaJ0Npp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:45:45 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-02-544e4c83c01f
Message-id: <1414417537.1674.5.camel@AMDC1943>
Subject: Re: [PATCH v5 2/4] regulator: max77686: Store opmode non-shifted
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Mon, 27 Oct 2014 14:45:37 +0100
In-reply-to: <544E4A8E.3060803@collabora.co.uk>
References: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
 <1414411911-5539-3-git-send-email-k.kozlowski@samsung.com>
 <544E4A8E.3060803@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xa7rNPn4hBpN3m1lsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6w6F1wlc3ibNMbdotvVzqYLDY9vsZqcXnXHDaLGef3MVnc
	vsxrsfbIXXYHPo+W5h42j7/Pr7N4/F31gtlj56y77B6bVnWyeWxeUu/Rt2UVo8fnTXIBHFFc
	NimpOZllqUX6dglcGXun9rIXfBasOLTvL1MD4zG+LkYODgkBE4n7repdjJxAppjEhXvr2boY
	uTiEBJYyShy5cYsZJCEk8JlRYuqScBCbV0BP4vOBJnYQW1jAU+LXhPMsIDabgLHE5uVL2EBs
	EQE7iRurHzKDDGIW+Mks8ajtGAvIMhYBVYnm3fUgNZwC+hLXL/1hgVi2glHi+dxNYMuYBdQl
	Js1bxAxxnLJEY78bxF5BiR+T77FAlMhLbF7zlnkCo8AsJB2zkJTNQlK2gJF5FaNoamlyQXFS
	eq6hXnFibnFpXrpecn7uJkZIBH3Zwbj4mNUhRgEORiUe3h3TfEOEWBPLiitzDzFKcDArifA6
	/gQK8aYkVlalFuXHF5XmpBYfYmTi4JRqYCxv6q4sn7NIsCnwzpwlu9/Y79r6ZKJwiU+hiu2N
	DTE5ezVe3Y2QK2l40+mseWvWraceRxhdvvg8KIk463g041fP5pCwKt/riguaJyTzteRuDHGw
	M3cWcJ96l5nlYAxPwyOnIye9J6aol1309pzYfPVh2Qd2v9t/qqR9tgvwa+hrRz3l4j38Woml
	OCPRUIu5qDgRACZEbbh+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-10-27 at 14:37 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/27/2014 01:11 PM, Krzysztof Kozlowski wrote:
> > Introduce simple helper for calculating the shift for OPMODE field in
> > registers. This allows storing the current value of opmode in
> > non-shifted form and simplifies a little set_suspend_disable and enable
> > functions. Additionally this will allow adding support LDOs to the
> > existing set_suspend_disable function.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > ---
> >  drivers/regulator/max77686.c | 49 ++++++++++++++++++++++++++++++--------------
> >  1 file changed, 34 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
> 
> The patch looks good to me.
> 
> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 
> >  
> >  static int max77686_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
> > @@ -495,7 +513,8 @@ static int max77686_pmic_probe(struct platform_device *pdev)
> >  		config.init_data = pdata->regulators[i].initdata;
> >  		config.of_node = pdata->regulators[i].of_node;
> >  
> > -		max77686->opmode[i] = regulators[i].enable_mask;
> > +		max77686->opmode[i] = regulators[i].enable_mask >>
> > +						max77686_get_opmode_shift(i);
> 
> I don't think it has to be done in your patch but as a follow-up it would be
> good to change this to:
> 
> 		max77686->opmode[i] = MAX77686_NORMAL;
> 
> since that is really what this code is trying to do AFAIU. This just happens
> to work because the value of MAX77686_OPMODE_MASK (0x3) is also "Output ON in
> Normal Mode" but the code is not correct IMHO.

It is technically correct (and regulator core use it this way if
enable_val is not specified) but I agree that MAX77686_NORMAL would be
more readable. I have some next patches almost ready, so I'll change it
there.

> Or even better, the regulator mode should be read from the hw registers instead
> of setting always to normal. That is what the max77802 driver does for example.

This would put trust on the bootloader... I don't know if I could trust
him :)



