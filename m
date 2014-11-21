Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbaKUBMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:12:54 -0500
Received: from mail-bn1on0115.outbound.protection.outlook.com ([157.56.110.115]:35190
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756487AbaKUBMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:12:52 -0500
X-WSS-ID: 0NFD7D8-08-UKG-02
X-M-MSG: 
From: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Schopp, Joel" <Joel.Schopp@amd.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "liviu.dudau@arm.com" <liviu.dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] arm64: amd-seattle: Adding device tree for AMD
 Seattle platform
Thread-Topic: [PATCH V3] arm64: amd-seattle: Adding device tree for AMD
 Seattle platform
Thread-Index: AQHP8rRCMFb7H3BqM0WQXXItWQqGg5xe2KIAgAOPZQA=
Date: Fri, 21 Nov 2014 01:12:45 +0000
Message-ID: <5468032C.8020505@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.0.121105
x-originating-ip: [10.177.96.15]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <A2FAE8279354114F90AA6E9780584835@amd.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(189002)(479174003)(199003)(24454002)(164054003)(65816999)(68736004)(101416001)(50466002)(92566001)(21056001)(23756003)(87266999)(50986999)(84676001)(54356999)(19580395003)(80316001)(44976005)(31966008)(83506001)(87936001)(33656002)(19580405001)(59896002)(53416004)(77096003)(62966003)(64706001)(105586002)(77156002)(106466001)(95666004)(106116001)(46102003)(97736003)(2656002)(120916001)(47776003)(92726001)(99396003)(36756003)(107046002)(4396001)(86362001)(20776003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Forefront-PRVS: 0402872DA1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/14 18:29, Arnd Bergmann wrote:
> On Tuesday 28 October 2014 08:36:54 suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> Initial revision of device tree for AMD Seattle platform
>
> Sorry for not looking at this earlier in enough detail.
>
>> +	dma0: dma@0500000 {
>> +		compatible = "arm,pl330", "arm,primecell";
>> +		reg = <0 0x0500000 0 0x1000>;
>> +		interrupts =
>> +			<0 368 4>,
>> +			<0 369 4>,
>> +			<0 370 4>,
>> +			<0 371 4>,
>> +			<0 372 4>,
>> +			<0 373 4>,
>> +			<0 374 4>,
>> +			<0 375 4>;
>> +		clocks = <&dmaclk_500mhz>;
>> +		clock-names = "apb_pclk";
>> +		#dma-cells = <1>;
>> +	};
>
> Is this device cache-coherent?
>
> Does it support larger than 32-bit DMA addresses?

The pl330 is only 32-bit DMA addressable, and need to be used with
the smmu (not yet included here) before it can be used in the system.
Therefore, it should be cache coherent by the virtue of the SMMU.

I¹ll remove this until the SMMU stuff is tested and ready.

>
>> +	sata0: sata@00300000 {
>> +		compatible = "snps,dwc-ahci";
>> +		reg = <0 0x300000 0 0x800>;
>> +		interrupts = <0 355 4>;
>> +		clocks = <&sataclk_333mhz>;
>> +		clock-names = "apb_pclk";
>> +		dma-coherent;
>> +	};
>
> Same here: you list it as coherent, but not 64-bit DMA capable.
> Is that intentional?

Correct me if I am wrong, but I didn't think that we need to specify
here since the AHCI platform driver determines the DMA bitness by
checking struct ahci_host_priv.cap for HOST_CAP_64 (see
drivers/ata/libahci_platform.c).

However, based on the conversation on the IRC, I¹ll add the dma-ranges
in the motherboard level.

>
>> +	i2c@1000000 {
>> +		compatible = "snps,designware-i2c";
>> +		reg = <0 0x01000000 0 0x1000>;
>> +		interrupts = <0 357 4>;
>> +		clocks = <&uartspiclk_100mhz>;
>> +		clock-names = "apb_pclk";
>> +	};
>> +
>> +	serial0: serial@1010000 {
>> +		compatible = "arm,pl011", "arm,primecell";
>> +		reg = <0 0x1010000 0 0x1000>;
>> +		interrupts = <0 328 4>;
>> +		clocks = <&uartspiclk_100mhz>, <&uartspiclk_100mhz>;
>> +		clock-names = "uartclk", "apb_pclk";
>> +	};
>> +
>> +	ssp@1020000 {
>> +		compatible = "arm,pl022", "arm,primecell";
>> +		#gpio-cells = <2>;
>> +		reg = <0 0x1020000 0 0x1000>;
>> +		spi-controller;
>> +		interrupts = <0 330 4>;
>> +		clocks = <&uartspiclk_100mhz>;
>> +		clock-names = "apb_pclk";
>> +	};
>
> Should these three be connected to the DMA engine?

It doesn't do DMA. Only PCI devices, XGBE, and SATA do DMA.

>
>> +	ccp: ccp@00100000 {
>> +		compatible = "amd,ccp-seattle-v1a";
>> +		reg = <0 0x00100000 0 0x10000>;
>> +		interrupts = <0 3 4>;
>> +		dma-coherent;
>> +	};
>
> I see the driver hacks an 48-bit DMA mask into this one.
> Please fix the driver and add an appropriate dma-ranges property.
>

ok

>> +	/* This entry is modified by UEFI */
>
> Can you explain which parts are modified by UEFI?
>

Actually, I need to remove this comment for now. I believe it was going
to be needed for the smmu stuff to specify the stream-id of each
end-point device.

>> +	pcie0: pcie-controller{
>> +		compatible = "pci-host-ecam-generic";
>> +		#address-cells = <3>;
>> +		#size-cells = <2>;
>> +		device_type = "pci";
>> +		bus-range = <0 0xff>;
>> +		reg = <0 0xf0000000 0 0x10000000>;
>> +		dma-coherent;
>> +		msi-parent = <&v2m0>;
>
> This surely needs a dma-ranges property to allow larger than 32-bit DMA.

So, I assume this will also need dma-range handling code to be added to
the PCI generic host driver.

>
>> +		interrupts =
>> +			<0 320 4>, /* ioc_soc_serr */
>> +			<0 321 4>; /* ioc_soc_sci */
>
> The pci-host-ecam-generic binding does not allow an interrupts property.
>
> You seem to be missing an interrupt-map property.

I¹ll look into this.
>
>
>> +		ranges =
>> +			/* I/O Memory (size=64K) */
>> +			<0x01000000 0x00 0xefff0000 0x00 0xefff0000 0x00 0x00010000>,
>
> Are you able to map the I/O space to bus address zero instead in the
> firmware? This looks like a firmware bug, I/O space should not
> be identity-mapped but is normally expected to have low port numbers.

I¹ll look into this.
>
>> +			/* Non-Pref 32-bit MMIO (size=512M) */
>> +			<0x02000000 0x00 0x40000000 0x00 0x40000000 0x00 0x20000000>,
>> +
>> +			/* Non-Pref 32-bit MMIO (size=512M) */
>> +			<0x02000000 0x00 0x60000000 0x00 0x60000000 0x00 0x20000000>,
>> +
>> +			/* Non-Pref 32-bit MMIO (size=512M) */
>> +			<0x02000000 0x00 0x80000000 0x00 0x80000000 0x00 0x20000000>,
>> +
>> +			/* Non-Pref 32-bit MMIO (size=512M) */
>> +			<0x02000000 0x00 0xa0000000 0x00 0xa0000000 0x00 0x20000000>,
>
> I don't understand why you use distinct ranges here and below. These are
>all
> contiguous, so why not collapse them into one logical range.

I'll collapse them.
>
>> +	smb {
>> +		compatible = "simple-bus";
>> +		#address-cells = <2>;
>> +		#size-cells = <2>;
>> +		ranges = <0 0 0 0xE0000000 0 0x01300000>;
>> +
>> +		/include/ "amd-seattle-periph.dtsi"
>> +	};
>
> I would put the smb node into the other file and move the include
>statement to the
> top level.
>
> Please use lowercase characters for the address.

I will made the changes accordingly.

Thanks,

Suravee

>
> 	Arnd
>

