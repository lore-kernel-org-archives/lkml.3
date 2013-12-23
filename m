Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab3LWVha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:37:30 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:52702 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758026Ab3LWVhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:37:19 -0500
Message-ID: <52B8AC55.70205@epfl.ch>
Date: Mon, 23 Dec 2013 22:34:13 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Anna, Suman" <s-anna@ti.com>, Joerg Roedel <joro@8bytes.org>,
        Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/7] ARM: dts: Complete data for isp iommu
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <1387284818-28739-6-git-send-email-florian.vaussard@epfl.ch> <52B88B1A.40506@ti.com>
In-Reply-To: <52B88B1A.40506@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On 12/23/2013 08:12 PM, Anna, Suman wrote:
> Hi Florian,
> 
> On 12/17/2013 06:53 AM, Florian Vaussard wrote:
>> Add missing information required to probe the iommu for the camera
>> subsystem.
>>
>> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
>> ---
>>   arch/arm/boot/dts/omap3.dtsi | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
>> index daabf99..610d084 100644
>> --- a/arch/arm/boot/dts/omap3.dtsi
>> +++ b/arch/arm/boot/dts/omap3.dtsi
>> @@ -371,11 +371,13 @@
>>               dma-names = "tx", "rx";
>>           };
>>
>> -        mmu_isp: mmu@480bd400 {
>> +        mmu_isp: mmu_isp@480bd400 {
> 
> Any reason for switching the name to mmu_isp?
> 

The name of the hwmod is "mmu_isp". This was not working otherwise,
but I cannot tell you for sure why without getting back at my office.

>>               compatible = "ti,omap3-mmu-isp";
>>               ti,hwmods = "mmu_isp";
>>               reg = <0x480bd400 0x80>;
>>               interrupts = <8>;
> 
> As I was testing the series, I found that this interrupt number is
> wrong. The interrupt number should be 24, you can fix it in this patch.
> I will post couple of patches to correct the interrupt numbers for
> couple of other occurrences.
> 

Really? Oh yes, this is CAM_IRQ0, thus M_IRQ_24. Nice catch.

Regards,

Florian
