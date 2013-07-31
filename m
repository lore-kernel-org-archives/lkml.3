Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099Ab3GaPNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:13:32 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:40950 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab3GaPNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:13:30 -0400
Message-ID: <51F929BE.1050505@mm-sol.com>
Date: Wed, 31 Jul 2013 18:14:06 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: linux-mmc@vger.kernel.org, cjb@laptop.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Asutosh Das <asutoshd@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Sahitya Tummala <stummala@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] mmc: sdhci-msm: Add support for MSM chipsets
References: <1375201355-26906-1-git-send-email-gdjakov@mm-sol.com> <CAJAp7OgOT82G=W8RpDvaogskUmAN26CWq4gKUs45RwOeU8pXvQ@mail.gmail.com>
In-Reply-To: <CAJAp7OgOT82G=W8RpDvaogskUmAN26CWq4gKUs45RwOeU8pXvQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 03:19 AM, Bjorn Andersson wrote:
> On Tue, Jul 30, 2013 at 8:22 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
>> This platform driver adds the support of Secure Digital Host
>> Controller Interface compliant controller in MSM chipsets.
>>
>> [snip]
>> +
>> +       sdhc_1: qcom,sdhc@f9824900 {
>> +               compatible = "qcom,sdhci-msm";
>> +                       reg = <0xf9824900 0x11c>, <0xf9824000 0x800>;
>> +                       reg-names = "hc_mem", "core_mem";
>> +                       interrupts = <0 123 0>, <0 138 0>;
>> +                       interrupt-names = "hc_irq", "pwr_irq";
>> +
>> +               vdd-supply = <&pm8941_l21>;
>> +               vdd-io-supply = <&pm8941_l13>;
>> +               qcom,vdd-voltage-level = <2950000 2950000>;
>> +               qcom,vdd-current-level = <9000 800000>;
>> +
>> +               qcom,vdd-io-always-on;
>> +               qcom,vdd-io-lpm-sup;
>> +               qcom,vdd-io-voltage-level = <1800000 2950000>;
>> +               qcom,vdd-io-current-level = <6 22000>;
>> +
>> +               bus-width = <4>;
>> +               non-removable;
>> +               qcom,bus-speed-mode = "HS200_1p8v", "DDR_1p8v";
>> +
>> +               gpios = <&msmgpio 40 0>, /* CLK */
>> +                       <&msmgpio 39 0>, /* CMD */
>> +                       <&msmgpio 38 0>, /* DATA0 */
>> +                       <&msmgpio 37 0>, /* DATA1 */
>> +                       <&msmgpio 36 0>, /* DATA2 */
>> +                       <&msmgpio 35 0>; /* DATA3 */
>> +               qcom,gpio-names = "CLK", "CMD", "DAT0", "DAT1", "DAT2", "DAT3";
>
> I believe these gpio references (and in the rest of the patch) should
> be replaced by pinctrl. As far as I can see it provides what you want
> and gives you configurability and potential sleep states of those pins
> nicely integrated.
>

Thanks! I'll make it use the pinctrl driver that is coming too.

BR,
Georgi
