Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaBDQ6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:58:33 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:42788 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbaBDQ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:58:30 -0500
Message-ID: <52F11C29.8080809@mm-sol.com>
Date: Tue, 04 Feb 2014 18:58:17 +0200
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christopher Covington <cov@codeaurora.org>
CC: linux-mmc@vger.kernel.org, cjb@laptop.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v8 0/3] mmc: sdhci-msm: Add support for Qualcomm chipsets
References: <1391107507-17321-1-git-send-email-gdjakov@mm-sol.com> <52F0E8C6.5090006@codeaurora.org>
In-Reply-To: <52F0E8C6.5090006@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

On 02/04/2014 03:19 PM, Christopher Covington wrote:
> Hi Georgi,
>
> On 01/30/2014 01:45 PM, Georgi Djakov wrote:
>> This patchset adds basic support of the Secure Digital Host Controller
>> Interface compliant controller found in Qualcomm chipsets.
>>
>> Tested with eMMC and various micro SD cards on APQ8074 Dragonboard.
>
> [...]
>
>>   .../devicetree/bindings/mmc/sdhci-msm.txt          |   83 ++
>>   drivers/mmc/host/Kconfig                           |   13 +
>>   drivers/mmc/host/Makefile                          |    1 +
>>   drivers/mmc/host/sdhci-msm.c                       |  938 ++++++++++++++++++++
>>   4 files changed, 1035 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-msm.txt
>>   create mode 100644 drivers/mmc/host/sdhci-msm.c
>
> You must have added entries to the Dragonboard device tree source to test
> these changes. Why not include them with this patchset? Is there a stand-alone
> patch that I've overlooked?
>

There have been recently many changes to the devicetree files and in 
order to avoid possible conflicts i have not added DT nodes yet. But 
I'll consider adding them, and maybe enable it in the defconfig too. 
Thanks for your suggestion.

To get it working, take a look at the binding example or just use the 
following:

sdhci1@f9824900 {
         compatible = "qcom,sdhci-msm";
         reg = <0xf9824900 0x11c>, <0xf9824000 0x800>;
         reg-names = "hc_mem", "core_mem";
         interrupts = <0 123 0>, <0 138 0>;
         interrupt-names = "hc_irq", "pwr_irq";
         bus-width = <8>;
         non-removable;
         clocks = <&gcc GCC_SDCC1_APPS_CLK>, <&gcc GCC_SDCC1_AHB_CLK>;
         clock-names = "core", "iface";
};

sdhci2@f98a4900 {
         compatible = "qcom,sdhci-msm";
         reg = <0xf98a4900 0x11c>, <0xf98a4000 0x800>;
         reg-names = "hc_mem", "core_mem";
         interrupts = <0 125 0>, <0 221 0>;
         interrupt-names = "hc_irq", "pwr_irq";
         bus-width = <4>;
         clocks = <&gcc GCC_SDCC2_APPS_CLK>, <&gcc GCC_SDCC2_AHB_CLK>;
         clock-names = "core", "iface";
};


Thanks,
Georgi

