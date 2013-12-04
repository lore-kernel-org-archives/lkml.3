Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab3LDMv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:51:27 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:33895 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184Ab3LDMvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:51:25 -0500
Message-ID: <529F24F7.40309@schinagl.nl>
Date: Wed, 04 Dec 2013 13:49:59 +0100
From: Oliver Schinagl <oliver@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "tj@kernel.org" <tj@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dev@linux-sunxi.org" <dev@linux-sunxi.org>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "ijc@hellion.org.uk" <ijc@hellion.org.uk>,
        "hdegoede@redhat.com" <hdegoede@redhat.com>,
        "oliver+list@schinagl.nl" <oliver+list@schinagl.nl>
Subject: Re: [PATCH 2/3] ARM: sunxi: Add an ahci-platform compatible AHCI
 driver for the Allwinner SUNXi series of SoCs
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl> <1386159055-10264-3-git-send-email-oliver@schinagl.nl> <20131204122602.GN16025@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131204122602.GN16025@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04-12-13 13:26, Mark Rutland wrote:
> On Wed, Dec 04, 2013 at 12:10:54PM +0000, oliver@schinagl.nl wrote:
>> From: Oliver Schinagl <oliver@schinagl.nl>
>>
>> This patch adds support for the sunxi series of SoC's by allwinner. It
>> plugs into the ahci-platform framework.
>>
>> Note: Currently it uses a somewhat hackish approach that probably needs
>> a lot more work, but does the same as the IMX SoC's.
>>
>> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
>> ---
>>   .../devicetree/bindings/ata/ahci-sunxi.txt         |  24 ++
>>   drivers/ata/Kconfig                                |   9 +
>>   drivers/ata/Makefile                               |   1 +
>>   drivers/ata/ahci_platform.c                        |  12 +
>>   drivers/ata/ahci_sunxi.c                           | 305 +++++++++++++++++++++
>>   5 files changed, 351 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/ata/ahci-sunxi.txt
>>   create mode 100644 drivers/ata/ahci_sunxi.c
>>
>> diff --git a/Documentation/devicetree/bindings/ata/ahci-sunxi.txt b/Documentation/devicetree/bindings/ata/ahci-sunxi.txt
>> new file mode 100644
>> index 0000000..0792fa5
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/ata/ahci-sunxi.txt
>> @@ -0,0 +1,24 @@
>> +Allwinner SUNXI AHCI SATA Controller
>> +
>> +SATA nodes are defined to describe on-chip Serial ATA controllers.
>> +Each SATA controller should have its own node.
>> +
>> +Required properties:
>> +- compatible   : compatible list, contains "allwinner,sun4i-a10-ahci"
> - compatible: Should contain "allwinner,sun4i-a10-ahci"
>
>> +- reg          : <registers mapping>
> - reg: The offset and length of the MMIO registers.
>
>> +- interrupts   : <interrupt mapping for AHCI IRQ>
> - interrupts: An interrupt-specifier for the ACHI interrupt
>
>> +- clocks       : clocks for ACHI
>> +- clock-names  : clock names for AHCI
> Please _define_ the set of clock-names you expect. This binding is
> meaningless without it. If you require clock-names, define the clocks
> property in terms of it.
I copied ahci_platform.txt and filled in the missing bits, I will 
improve all the above. Appologies!
>
> Thanks,
> Mark.

