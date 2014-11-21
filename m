Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbaKUOkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:40:22 -0500
Received: from mail-by2on0136.outbound.protection.outlook.com ([207.46.100.136]:53760
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751368AbaKUOkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:40:21 -0500
X-WSS-ID: 0NFE8R2-08-PQW-02
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
Thread-Index: AQHP8rRCMFb7H3BqM0WQXXItWQqGg5xrg/GAgACR7QA=
Date: Fri, 21 Nov 2014 14:40:14 +0000
Message-ID: <D0955C2B.9B22%suravee.suthikulpanit@amd.com>
In-Reply-To: <546F36D3.4090008@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.0.121105
x-originating-ip: [10.177.96.15]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <55ADEE3CAC29A149A8139ABD1BA37604@amd.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(189002)(479174003)(199003)(24454002)(164054003)(68736004)(50466002)(97756001)(92566001)(101416001)(21056001)(46406003)(84676001)(54356999)(50986999)(87936001)(83506001)(19580395003)(44976005)(31966008)(19580405001)(23726002)(62966003)(105586002)(64706001)(77156002)(106466001)(95666004)(106116001)(46102003)(97736003)(2656002)(120916001)(47776003)(77096003)(99396003)(53416004)(36756003)(107046002)(92726001)(20776003)(86362001)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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



On 11/21/14, 19:57, "Marc Zyngier" <marc.zyngier@arm.com> wrote:

>>+	gic: interrupt-controller@e1101000 {
>>+		compatible = "arm,gic-400", "arm,cortex-a15-gic";
>>+		interrupt-controller;
>>+		#interrupt-cells = <3>;
>>+		#address-cells = <2>;
>>+		#size-cells = <2>;
>>+		reg = <0x0 0xe1110000 0 0x1000>,
>>+		      <0x0 0xe112f000 0 0x2000>,
>>+		      <0x0 0xe1140000 0 0x10000>,
>>+		      <0x0 0xe1160000 0 0x10000>;
>>+		interrupts = <1 8 0xf04>;
>
>Are you sure about this one? ARM systems usually have this wired on PPI9
>(interrupt 25)...
>
>Thanks,
>
>	M.

I think you might be right. GIC-400 TRM says that this is should be 25,
and used 
for virtual maintenance interrupts. How can I verify this in Linux? KVM?

Thanks,

Suravee

