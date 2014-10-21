Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaJUSQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:16:22 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47675 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaJUSQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:16:20 -0400
Message-ID: <5446A2D8.3070204@linaro.org>
Date: Tue, 21 Oct 2014 19:15:52 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v5 3/4] pinctrl: Qualcomm SPMI PMIC GPIO pin controller
 driver
References: <1412181058-29179-1-git-send-email-iivanov@mm-sol.com> <1412181058-29179-4-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1412181058-29179-4-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,

Just realized that this patch can generate compiler errors due to 3.18 
changes in pinmux_ops struct and gpiochip_remove returns void now.

Same with drivers/pinctrl/qcom/pinctrl-spmi-pmic-mpp.c



On 01/10/14 17:30, Ivan T. Ivanov wrote:
> +	.enable			= pmic_gpio_pinmux_enable,
> +};

>
> +static int pmic_gpio_remove(struct platform_device *pdev)
> +{
> +	struct pmic_gpio_state *state = platform_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = gpiochip_remove(&state->chip);
> +	if (ret < 0)
> +		return ret;


diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-pmic-gpio.c 
b/drivers/pinctrl/qcom/pinctrl-spmi-pmic-gpio.c
index 493f0d3..0d69758 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-pmic-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-pmic-gpio.c
@@ -378,7 +378,7 @@ static const struct pinmux_ops pmic_gpio_pinmux_ops = {
  	.get_functions_count	= pmic_gpio_get_functions_count,
  	.get_function_name	= pmic_gpio_get_function_name,
  	.get_function_groups	= pmic_gpio_get_function_groups,
-	.enable			= pmic_gpio_pinmux_enable,
+	.set_mux		= pmic_gpio_pinmux_enable,
  };

  static int pmic_gpio_config_get(struct pinctrl_dev *pctldev,
@@ -907,12 +907,8 @@ err_chip:
  static int pmic_gpio_remove(struct platform_device *pdev)
  {
  	struct pmic_gpio_state *state = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = gpiochip_remove(&state->chip);
-	if (ret < 0)
-		return ret;

+	gpiochip_remove(&state->chip);
  	pinctrl_unregister(state->ctrl);
  	return 0;



Thanks,
srini
