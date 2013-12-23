Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab3LWVhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:37:09 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:39633 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812Ab3LWVhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:37:06 -0500
Message-ID: <52B8A26A.3000905@epfl.ch>
Date: Mon, 23 Dec 2013 21:51:54 +0100
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
Subject: Re: [PATCH 0/7] Fix omap-iommu probe and convert to DT for 3.14
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch> <52B8866D.9060100@ti.com>
In-Reply-To: <52B8866D.9060100@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On 12/23/2013 07:52 PM, Anna, Suman wrote:
> Hi Florian,
>
> On 12/17/2013 06:53 AM, Florian Vaussard wrote:
>> OMAP2+ is heading towards a full device tree boot for 3.14. Currently,
>> the iommu used by the OMAP3 camera subsystem is not yet converted. It
>> cannot be probed as necessary data are only passed through device tree.
>>
>> Patches 1 and 2 are small fixes for problems encountered while developing
>> this series.
>>
>> Patches 3 to 5 add the device tree logic to omap-iommu, and complete
>> iommu
>> data in omap3.dtsi. Patches 6 and 7 remove unused iommu hwmod data and
>> platform code from OMAP2+.
>
> This is a good starting patch series for the OMAP iommu DT conversion,
> but it only handles OMAP3 ISP MMU. The OMAP3 ISP MMU is not the only MMU
> handled by the OMAP iommu driver. There is also an OMAP3 IVA MMU and
> MMUs associated with DSP and IPU in OMAP4/OMAP5. The conversion is
> simpler just with the OMAP3 ISP MMU, as it doesn't have any reset lines
> associated with it. But all the other MMUs would require
> asserting/deasserting the resets (performed currently through the pdata
> function pointers). Your patch series removes that functionality
> completely, and if this were to go into 3.14, this has to be handled
> through some pdata quirks until all the resets in hwmod data are
> converted to a reset driver.
>

Indeed, this patchset currently addresses only the OMAP ISP IOMMU.
For the OMAP3 IVA, the current implementation looks completely
different (inside drivers/staging/tidspbridge/). And to the best of
my knowledge, the current omap-iommu driver can handle only one
instance. By calling

bus_set_iommu(&platform_bus_type, &omap_iommu_ops);

the driver register the iommu on the platform bus (which is maybe
not the best choice). This call will fill the struct iommu_ops of
the bus_type, but if an iommu is already present, it will fail
and return EBUSY. Thus only one iommu can be set on the same bus.

But for the OMAP4 and OMAP5, I understand your concern. If a reset
is needed for these IPs, then a solution must be found. pdata-quirks
can be a temporary solution for 3.14. Otherwise a proper reset
controller should be devised from the current PRM module. Even if
I already looked at the reset core, I do not know the amount of work
necessary for this solution. And I do not have the hardware to
test the solution. But I can have a look after the XMAS break.

> I have provided some more comments directly in the respective patches.
>

And I will answer inline. Thank you very much!

Regards,

Florian
