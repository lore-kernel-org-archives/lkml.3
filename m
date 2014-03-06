Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaCFRp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:45:59 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:49513 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbaCFRp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:45:56 -0500
Message-ID: <5318B453.9060804@mm-sol.com>
Date: Thu, 06 Mar 2014 19:45:55 +0200
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v10 1/3] mmc: sdhci-msm: Qualcomm SDHCI binding documentation
References: <1393961226-25618-1-git-send-email-gdjakov@mm-sol.com>	<1393961226-25618-2-git-send-email-gdjakov@mm-sol.com> <CAL_JsqKJ5Jn4wb8xtqrc09kkP4dzUA6qDEkK396RW+4qFNVf+Q@mail.gmail.com>
In-Reply-To: <CAL_JsqKJ5Jn4wb8xtqrc09kkP4dzUA6qDEkK396RW+4qFNVf+Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 08:56 AM, Rob Herring wrote:
> On Tue, Mar 4, 2014 at 1:27 PM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
[..]
>> +Required properties:
>> +- compatible: Should contain "qcom,sdhci-msm-v4".
>> +- reg: Base address and length of the register set listed in reg-names.
>> +- reg-names: Should contain the following:
>> +       "hc_mem"   - Host controller register map
>> +       "core_mem" - SD Core register map
>
> reg-names should not be required and the order specified by the binding.
>

Ok, Rob! Thanks!

>> +- interrupts: Should contain an interrupt-specifiers for the interrupts listed in interrupt-names.
>> +- interrupt-names: Should contain the following:
>> +       "hc_irq"     - Host controller interrupt
>> +       "pwr_irq"    - PMIC interrupt
>
> Same for interrupt-names.
>

Ok.

>> +- vdd-supply: Phandle to the regulator for the vdd (core voltage) supply.
>> +- vdd-io-supply: Phandle to the regulator for the vdd-io (i/o voltage) supply.
>> +- pinctrl-names: Should contain only one value - "default".
>> +- pinctrl-0: Should specify pin control groups used for this controller.
>> +- clocks: A list of phandle + clock-specifier pairs for the clocks listed in clock-names.
>> +- clock-names: Should contain the following:
>> +       "iface" - Main peripheral bus clock (PCLK/HCLK - AHB Bus clock) (required)
>> +       "core"  - SDC MMC clock (MCLK) (required)
>> +       "bus"   - SDCC bus voter clock (optional)
>> +
>> +Example:
>> +
>> +       sdhc_1: sdhci@f9824900 {
>> +               compatible = "qcom,sdhci-msm-v4";
>> +               reg = <0xf9824900 0x11c>, <0xf9824000 0x800>;
>
> Are there cases where these are really in a different 4KB range? If
> not, this should just be 1 range.
>

Thanks for your suggestion. This sounds reasonable, but in this case,
I think that it might be better leaving the memory regions separated as 
it will help avoiding code duplication. I am using the generic 
sdhci_pltfm_init(), which assumes that the first resource is the HC 
iomem and configures the host. If I merge them, the HC address will be 
offset and this might require duplicating some of the init code.
Is it acceptable to leave it this way?

BR,
Georgi
