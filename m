Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaKYUj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:39:57 -0500
Received: from mail-bl2on0124.outbound.protection.outlook.com ([65.55.169.124]:7632
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750726AbaKYUjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:39:55 -0500
X-WSS-ID: 0NFM428-08-V0I-02
X-M-MSG: 
From: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "liviu.dudau@arm.com" <liviu.dudau@arm.com>,
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
Thread-Index: AQHQCDDPK3mlC9v6xEOEmK8G5GOQ9ZxxkWoAgAEEeQA=
Date: Tue, 25 Nov 2014 20:39:45 +0000
Message-ID: <D09AF278.A61D%suravee.suthikulpanit@amd.com>
In-Reply-To: <2285363.CoMWhviz1f@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.0.121105
x-originating-ip: [10.177.96.12]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <266F8E5B654D9B48B2376FE09941D16B@amd.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(164054003)(189002)(24454002)(479174003)(199003)(51704005)(99396003)(21056001)(31966008)(23726002)(87936001)(2656002)(84676001)(105586002)(106116001)(107046002)(106466001)(46406003)(110136001)(95666004)(36756003)(53416004)(77096003)(62966003)(77156002)(83506001)(46102003)(120916001)(47776003)(97736003)(20776003)(64706001)(50986999)(54356999)(86362001)(50466002)(101416001)(97756001)(44976005)(19580405001)(68736004)(92726001)(92566001)(4396001)(19580395003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Forefront-PRVS: 040655413E
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/25/14, 18:57, "Arnd Bergmann" <arnd@arndb.de> wrote:

>On Monday 24 November 2014 15:51:17 suravee.suthikulpanit@amd.com wrote:
>> 
>> +	gic: interrupt-controller@e1101000 {
>> +		compatible = "arm,gic-400", "arm,cortex-a15-gic";
>> +		interrupt-controller;
>> +		#interrupt-cells = <3>;
>> +		#address-cells = <2>;
>> +		#size-cells = <2>;
>> +		reg = <0x0 0xe1110000 0 0x1000>,
>> +		      <0x0 0xe112f000 0 0x2000>,
>> +		      <0x0 0xe1140000 0 0x10000>,
>> +		      <0x0 0xe1160000 0 0x10000>;
>> +		interrupts = <1 9 0xf04>;
>> +		ranges;
>> +		v2m0: v2m@e1180000 {
>> +			compatible = "arm,gic-v2m-frame";
>> +			msi-controller;
>> +			arm,msi-base-spi = <64>;
>> +			arm,msi-num-spis = <256>;
>> +			reg = <0x0 0xe1180000 0 0x1000>;
>> +		};
>> +	};
>
>
>Having an empty ranges property in the gic seems strange, especially
>since the registers of the v2m seem to directly follow the gic's own
>registers. Could you limit the ranges to only the registers that
>are in the gic or its child devices itself?
>
>	Arnd

Yes, I can change it to ranges = <0 0 0 0xe1100000 0 0x100000> to limit
the range to just the GIC address range.

Thanks,

Suravee

