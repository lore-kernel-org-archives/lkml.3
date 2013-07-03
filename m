Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab3GCLxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:53:30 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:36891 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3GCLx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:53:29 -0400
MIME-Version: 1.0
In-Reply-To: <1372072858-6559-5-git-send-email-yadi.brar@samsung.com>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
	<1372072858-6559-5-git-send-email-yadi.brar@samsung.com>
Date: Wed, 3 Jul 2013 17:23:28 +0530
Message-ID: <CAK9yfHyo7Qd_BQzEmViNJmLfd2bUk9dd8ud7GGrRxRkHm+UPXg@mail.gmail.com>
Subject: Re: [PATCH 4/4] regulator: s2mps11: Add device tree support
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, yadi.brar01@gmail.com, sbkim73@samsung.com,
        broonie@kernel.org, lgirdwood@gmail.com, sameo@linux.intel.com,
        rob.herring@calxeda.com, grant.likely@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void s2mps11_pmic_set_buck_ramp(struct regulator_init_data *init_data,
> +                                       struct s2mps11_info *s2mps11, int id)
> +{
> +       unsigned int ramp_rate;
> +
> +       if (!init_data)
> +               return;
> +
> +       ramp_rate = init_data->constraints.ramp_delay;
> +
> +       switch (id) {
> +       case S2MPS11_BUCK2:
> +               s2mps11->ramp_delay2 = ramp_rate;
> +               break;
> +       case S2MPS11_BUCK3:
> +       case S2MPS11_BUCK4:
> +               if (ramp_rate > s2mps11->ramp_delay34)
> +                       s2mps11->ramp_delay34 = ramp_rate;
> +               break;
> +       case S2MPS11_BUCK5:
> +               s2mps11->ramp_delay5 = ramp_rate;
> +               break;
> +       case S2MPS11_BUCK1:
> +       case S2MPS11_BUCK6:
> +               if (ramp_rate > s2mps11->ramp_delay16)
> +                       s2mps11->ramp_delay16 = ramp_rate;
> +               break;
> +       case S2MPS11_BUCK7:
> +       case S2MPS11_BUCK8:
> +       case S2MPS11_BUCK10:
> +               if (ramp_rate > s2mps11->ramp_delay7810)
> +                       s2mps11->ramp_delay7810 = ramp_rate;
> +               break;
> +       case S2MPS11_BUCK9:
> +               s2mps11->ramp_delay9 = ramp_rate;

How about adding a 'break' here for completeness.

[snip]

>  static int s2mps11_pmic_probe(struct platform_device *pdev)
>  {
>         struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
>         struct sec_platform_data *pdata = dev_get_platdata(iodev->dev);
> +       struct of_regulator_match rdata[S2MPS11_REGULATOR_MAX];
> +       struct device_node *reg_np = NULL;
>         struct regulator_config config = { };
>         struct s2mps11_info *s2mps11;
> -       int i, ret;
> +       int i, id, ret;
>         unsigned char ramp_enable, ramp_reg = 0;
>
> -       if (!pdata) {
> -               dev_err(pdev->dev.parent, "Platform data not supplied\n");
> -               return -ENODEV;
> -       }
> -
>         s2mps11 = devm_kzalloc(&pdev->dev, sizeof(struct s2mps11_info),

sizeof(*s2mps11) is preferred.

-- 
With warm regards,
Sachin
