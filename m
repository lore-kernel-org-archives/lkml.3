Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab3GaATr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:19:47 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:56627 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142Ab3GaATp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:19:45 -0400
MIME-Version: 1.0
In-Reply-To: <1375201355-26906-1-git-send-email-gdjakov@mm-sol.com>
References: <1375201355-26906-1-git-send-email-gdjakov@mm-sol.com>
Date: Tue, 30 Jul 2013 16:19:44 -0800
Message-ID: <CAJAp7OgOT82G=W8RpDvaogskUmAN26CWq4gKUs45RwOeU8pXvQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-msm: Add support for MSM chipsets
From: Bjorn Andersson <bjorn@kryo.se>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Asutosh Das <asutoshd@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Sahitya Tummala <stummala@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 8:22 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
> This platform driver adds the support of Secure Digital Host
> Controller Interface compliant controller in MSM chipsets.
>
> [snip]
> +
> +       sdhc_1: qcom,sdhc@f9824900 {
> +               compatible = "qcom,sdhci-msm";
> +                       reg = <0xf9824900 0x11c>, <0xf9824000 0x800>;
> +                       reg-names = "hc_mem", "core_mem";
> +                       interrupts = <0 123 0>, <0 138 0>;
> +                       interrupt-names = "hc_irq", "pwr_irq";
> +
> +               vdd-supply = <&pm8941_l21>;
> +               vdd-io-supply = <&pm8941_l13>;
> +               qcom,vdd-voltage-level = <2950000 2950000>;
> +               qcom,vdd-current-level = <9000 800000>;
> +
> +               qcom,vdd-io-always-on;
> +               qcom,vdd-io-lpm-sup;
> +               qcom,vdd-io-voltage-level = <1800000 2950000>;
> +               qcom,vdd-io-current-level = <6 22000>;
> +
> +               bus-width = <4>;
> +               non-removable;
> +               qcom,bus-speed-mode = "HS200_1p8v", "DDR_1p8v";
> +
> +               gpios = <&msmgpio 40 0>, /* CLK */
> +                       <&msmgpio 39 0>, /* CMD */
> +                       <&msmgpio 38 0>, /* DATA0 */
> +                       <&msmgpio 37 0>, /* DATA1 */
> +                       <&msmgpio 36 0>, /* DATA2 */
> +                       <&msmgpio 35 0>; /* DATA3 */
> +               qcom,gpio-names = "CLK", "CMD", "DAT0", "DAT1", "DAT2", "DAT3";

I believe these gpio references (and in the rest of the patch) should
be replaced by pinctrl. As far as I can see it provides what you want
and gives you configurability and potential sleep states of those pins
nicely integrated.

Regards,
Bjorn
