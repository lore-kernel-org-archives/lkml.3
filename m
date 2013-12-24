Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab3LXALN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:11:13 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59078 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab3LXALL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:11:11 -0500
Message-ID: <52B8D0F3.5060508@ti.com>
Date: Mon, 23 Dec 2013 18:10:27 -0600
From: "Anna, Suman" <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <florian.vaussard@epfl.ch>, Joerg Roedel <joro@8bytes.org>,
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
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <1387284818-28739-6-git-send-email-florian.vaussard@epfl.ch> <52B88B1A.40506@ti.com> <52B8AC55.70205@epfl.ch>
In-Reply-To: <52B8AC55.70205@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On 12/23/2013 03:34 PM, Florian Vaussard wrote:
> Hi Suman,
>
> On 12/23/2013 08:12 PM, Anna, Suman wrote:
>> Hi Florian,
>>
>> On 12/17/2013 06:53 AM, Florian Vaussard wrote:
>>> Add missing information required to probe the iommu for the camera
>>> subsystem.
>>>
>>> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
>>> ---
>>>    arch/arm/boot/dts/omap3.dtsi | 4 +++-
>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
>>> index daabf99..610d084 100644
>>> --- a/arch/arm/boot/dts/omap3.dtsi
>>> +++ b/arch/arm/boot/dts/omap3.dtsi
>>> @@ -371,11 +371,13 @@
>>>                dma-names = "tx", "rx";
>>>            };
>>>
>>> -        mmu_isp: mmu@480bd400 {
>>> +        mmu_isp: mmu_isp@480bd400 {
>>
>> Any reason for switching the name to mmu_isp?
>>
>
> The name of the hwmod is "mmu_isp". This was not working otherwise,
> but I cannot tell you for sure why without getting back at my office.

Ok, did a bit of digging, this is due to the name tie-in for iommu arch 
data (look at the omap3_camera_init in mach-omap2/devices.c), and the 
obj->name assignment of of->name. This is another thing that needs to be 
looked into since it would be preferable to move away from the name 
based lookup towards using a phandle approach by the iommu consumer drivers.

regards
Suman

