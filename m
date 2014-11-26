Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaKZLah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 06:30:37 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39591 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaKZLaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:30:35 -0500
Message-ID: <5475B9D4.30103@arm.com>
Date: Wed, 26 Nov 2014 11:30:28 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: Re: [PATCH v11 2/2] irqchip: gicv2m: Add DT bindings for GICv2m
References: <1416941243-7181-1-git-send-email-marc.zyngier@arm.com> <1416941243-7181-3-git-send-email-marc.zyngier@arm.com> <20141126111246.GB4340@leverpostej>
In-Reply-To: <20141126111246.GB4340@leverpostej>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/14 11:12, Mark Rutland wrote:
> On Tue, Nov 25, 2014 at 06:47:23PM +0000, Marc Zyngier wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> Update the GIC DT bindings to support GICv2m.
>>
>> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> [maz: split DT patch from main driver, updated changelog]
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  Documentation/devicetree/bindings/arm/gic.txt | 53 +++++++++++++++++++++++++++
>>  1 file changed, 53 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
>> index c7d2fa1..375147e 100644
>> --- a/Documentation/devicetree/bindings/arm/gic.txt
>> +++ b/Documentation/devicetree/bindings/arm/gic.txt
>> @@ -96,3 +96,56 @@ Example:
>>  		      <0x2c006000 0x2000>;
>>  		interrupts = <1 9 0xf04>;
>>  	};
>> +
>> +
>> +* GICv2m extension for MSI/MSI-x support (Optional)
>> +
>> +Certain revisions of GIC-400 supports MSI/MSI-x via V2M register frame(s).
>> +This is enabled by specifying v2m sub-node(s).
>> +
>> +Required properties:
>> +
>> +- compatible	    : The value here should contain "arm,gic-v2m-frame".
>> +
>> +- msi-controller    : Identifies the node as an MSI controller.
>> +
>> +- reg		    : GICv2m MSI interface register base and size
> 
> It would be worth having a note that ranges, #address-cells, and
> #size-cells are necessary in the GIC node to map this.

Makes sense. I'll queue a separate patch for this.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
