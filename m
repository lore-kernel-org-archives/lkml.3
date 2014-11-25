Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbaKYLrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:47:23 -0500
Received: from mail-by2on0120.outbound.protection.outlook.com ([207.46.100.120]:13131
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752680AbaKYLq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:46:58 -0500
X-WSS-ID: 0NFLFE4-07-51B-02
X-M-MSG: 
From: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To: Marc Zyngier <marc.zyngier@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "Mark Rutland" <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "Catalin Marinas" <Catalin.Marinas@arm.com>
CC: "robherring2@gmail.com" <robherring2@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Schopp, Joel" <Joel.Schopp@amd.com>
Subject: Re: [PATCH V4] arm64: amd-seattle: Adding device tree for AMD
 Seattle platform
Thread-Topic: [PATCH V4] arm64: amd-seattle: Adding device tree for AMD
 Seattle platform
Thread-Index: AQHQCDDPK3mlC9v6xEOEmK8G5GOQ9Zxxd0KAgACLggA=
Date: Tue, 25 Nov 2014 11:46:50 +0000
Message-ID: <D09A7217.A4E1%suravee.suthikulpanit@amd.com>
In-Reply-To: <547458B9.2000805@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.0.121105
x-originating-ip: [10.177.96.12]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <92EA3ECA76898F48B80E4B658612154B@amd.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(199003)(189002)(51704005)(52604005)(479174003)(44976005)(19580395003)(19580405001)(62966003)(84676001)(68736004)(50466002)(87936001)(77156002)(77096003)(95666004)(105586002)(106466001)(106116001)(21056001)(53416004)(101416001)(107046002)(83506001)(86362001)(50986999)(120916001)(47776003)(31966008)(20776003)(99396003)(36756003)(54356999)(64706001)(92726001)(92566001)(2656002)(2501002)(97736003)(4396001)(46102003)(23756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Forefront-PRVS: 040655413E
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On 11/25/14, 17:23, "Marc Zyngier" <marc.zyngier@arm.com> wrote:

>Hi Suravee,
>
>Just spotted a small issue below (looks like a recurring mistake in a
>number of DTs I've seem lately):
>
>On 24/11/14 21:51, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> 
>> Initial revision of device tree for AMD Seattle platform.
>> 
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> Signed-off-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
>> Signed-off-by: Joel Schopp <Joel.Schopp@amd.com>
>> ---
>> V4 Changes:
>>     * Remove unnecessary smb layer and move motherbord to top level
>>     * Move include dtsi to top level
>>     * Remove apb_pclk from sata0 and i2c
>>     * Fix GIC Virtual Maintanance Interrupt from PPI24 (8) to PPI25 (9)
>>     * Add 40-bit dma-ranges for motherboard (simple-bus)
>>     * Remove dma0 (pl330) entry for now since it only supports 32-bit
>>DMA.
>>       It is basically not used at the moment. It would also need SMMU
>>       to allow dma remapping to 40-bit DMA range.
>>     * Add phandle spi0 and spi1
>>     * Hook up gpio0 pin 7 with MMC Card Detection (CD) support.
>>     * Changes in pcie0 entry:
>>         - Add 40-bit dma-ranges
>>         - Remove interrupts property
>>         - Add interrupt-map/mask property
>>         - Fix PCI I/O range
>>         - Merge PCI 32-bit ranges
>>         - Merge PCI 64-bit ranges
>> 
>> NOTE: I am not add a new compatible ID for the sata0 as Rob Herring
>>       suggested since there is no need at the momement, and I am trying
>>       to avoid introducing ID unnecessarily.
>> 
>>  arch/arm64/Kconfig                          |   5 +
>>  arch/arm64/boot/dts/Makefile                |   1 +
>>  arch/arm64/boot/dts/amd-seattle-periph.dtsi | 156
>>++++++++++++++++++++++++++++
>>  arch/arm64/boot/dts/amd-seattle.dts         |  89 ++++++++++++++++
>>  4 files changed, 251 insertions(+)
>>  create mode 100644 arch/arm64/boot/dts/amd-seattle-periph.dtsi
>>  create mode 100644 arch/arm64/boot/dts/amd-seattle.dts
>> 
>
>[...]
>
>> diff --git a/arch/arm64/boot/dts/amd-seattle.dts
>>b/arch/arm64/boot/dts/amd-seattle.dts
>> new file mode 100644
>> index 0000000..d5fc482
>> --- /dev/null
>> +++ b/arch/arm64/boot/dts/amd-seattle.dts
>> @@ -0,0 +1,89 @@
>> +/*
>> + * DTS file for AMD Seattle
>> + *
>> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
>> + */
>> +
>> +/dts-v1/;
>> +

[...] 

>> +
>> +	timer {
>> +		compatible = "arm,armv8-timer";
>> +		interrupts = <1 13 0xff01>,
>> +			     <1 14 0xff01>,
>> +			     <1 11 0xff01>,
>> +			     <1 10 0xff01>;
>> +	};
>
>The Cortex-A57 TRM clearly states that these interrupts are level
>triggered.

Thanks for pointing this out. I¹ll fix this to <1 1X 0xff04> (4 for the
Active-High) then.

Suravee

>

