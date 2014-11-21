Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbaKUQ0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:26:05 -0500
Received: from mail-bn1bon0134.outbound.protection.outlook.com ([157.56.111.134]:7712
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758726AbaKUQ0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:26:03 -0500
X-WSS-ID: 0NFEDN8-07-2EK-02
X-M-MSG: 
From: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To: Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
CC: Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Schopp, Joel" <Joel.Schopp@amd.com>
Subject: Re: [PATCH V3] arm64: amd-seattle: Adding device tree for AMD
 Seattle platform
Thread-Topic: [PATCH V3] arm64: amd-seattle: Adding device tree for AMD
 Seattle platform
Thread-Index: AQHP8rRCMFb7H3BqM0WQXXItWQqGg5xrg/GAgACR7QD//4z4gIAAkIkA
Date: Fri, 21 Nov 2014 16:25:55 +0000
Message-ID: <D09577B0.9B9B%suravee.suthikulpanit@amd.com>
In-Reply-To: <546F50BD.8070501@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.0.121105
x-originating-ip: [10.177.96.15]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <688F8A7271F148489A786B4E1A11D8CA@amd.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(479174003)(199003)(24454002)(189002)(164054003)(31966008)(105586002)(64706001)(106116001)(20776003)(47776003)(23756003)(99396003)(95666004)(101416001)(36756003)(87936001)(86362001)(21056001)(2656002)(68736004)(19580405001)(19580395003)(4396001)(106466001)(44976005)(120916001)(50466002)(84676001)(83506001)(92726001)(77096003)(46102003)(50986999)(62966003)(53416004)(97736003)(107046002)(54356999)(92566001)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Forefront-PRVS: 0402872DA1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/21/14, 21:48, "Marc Zyngier" <marc.zyngier@arm.com> wrote:

>On 21/11/14 14:40, Suthikulpanit, Suravee wrote:
>> 
>> 
>> On 11/21/14, 19:57, "Marc Zyngier" <marc.zyngier@arm.com> wrote:
>> 
>>>> +	gic: interrupt-controller@e1101000 {
>>>> +		compatible = "arm,gic-400", "arm,cortex-a15-gic";
>>>> +		interrupt-controller;
>>>> +		#interrupt-cells = <3>;
>>>> +		#address-cells = <2>;
>>>> +		#size-cells = <2>;
>>>> +		reg = <0x0 0xe1110000 0 0x1000>,
>>>> +		      <0x0 0xe112f000 0 0x2000>,
>>>> +		      <0x0 0xe1140000 0 0x10000>,
>>>> +		      <0x0 0xe1160000 0 0x10000>;
>>>> +		interrupts = <1 8 0xf04>;
>>>
>>> Are you sure about this one? ARM systems usually have this wired on
>>>PPI9
>>> (interrupt 25)...
>>>
>>> Thanks,
>>>
>>> 	M.
>> 
>> I think you might be right. GIC-400 TRM says that this is should be
>> 25, and used for virtual maintenance interrupts. How can I verify
>> this in Linux? KVM?
>
>KVM is one way, but you'll never see the interrupt firing (we kill the
>interrupt while in HYP, before the kernel gets a chance to see it).
>
>If you effectively have GIC400 on this system, then I know for sure this
>is interrupt 25.

I¹ll make the change. Thanks for clarification.

Suravee
>
>Thanks,
>
>	M.
>-- 
>Jazz is not dead. It just smells funny...

