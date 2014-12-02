Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaLBONA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:13:00 -0500
Received: from mail-bn1on0135.outbound.protection.outlook.com ([157.56.110.135]:31753
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752732AbaLBOM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:12:58 -0500
X-WSS-ID: 0NFYKT9-08-GGS-02
X-M-MSG: 
From: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "liviu.dudau@arm.com" <liviu.dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>
Subject: Re: [PATCH 1/2] arm64: amd-seattle: Fix dma-ranges property
Thread-Topic: [PATCH 1/2] arm64: amd-seattle: Fix dma-ranges property
Thread-Index: AQHQDRlz8l1lZUc4yk25HJxMacgGw5x7EHYAgAISmAA=
Date: Tue, 2 Dec 2014 14:12:48 +0000
Message-ID: <D0A3B11F.AAC8%suravee.suthikulpanit@amd.com>
In-Reply-To: <2316008.jChdsJ8v0y@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.0.121105
x-originating-ip: [10.177.96.15]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <FD554535415E9943B23A9D2424C95BD6@amd.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(199003)(189002)(479174003)(51914003)(24454002)(164054003)(99396003)(105586002)(120916001)(87936001)(2656002)(77096004)(95666004)(83506001)(106116001)(106466001)(68736005)(44976005)(19580405001)(97736003)(84676001)(19580395003)(107046002)(92566001)(86362001)(92726001)(46102003)(101416001)(54356999)(50986999)(62966003)(21056001)(50466002)(31966008)(4396001)(23756003)(20776003)(47776003)(77156002)(64706001)(53416004)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Forefront-PRVS: 0413C9F1ED
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB072;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 12/1/14, 20:33, "Arnd Bergmann" <arnd@arndb.de> wrote:

>On Sunday 30 November 2014 21:46:39 suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> 
>> AMD Seattle should support 40-bit DMA.
>> 
>> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> 
>
>The change looks good, but two things about the patch description:
>
>- You should be a little more verbose, especially after we had discussed
>  this to some detail on IRC, explain why you use the specific values.

Would you minding adding the following detail in the commit message?

- BEGIN -
AMD Seattle supports 40-bit DMA, which includes two ranges:
    1. GICv2m MSI register frame at 0xe0080000
    2. DRAM range [0x8000000000 to 0xffffffffff]

Since the current parsing logic handles only single range, this patch
specifies the range from zero to 0x10000000000 to cover the whole
40-bit range.

However, it expects DMA allocation/mapping logic to check the specified
DMA range against the reported DRAM range, which starts from
0x8000000000 in this case.
- END -

>
>- You should configure git-send-email to know your full email address
>  including the name. Right now it gets sent from
>  "suravee.suthikulpanit@amd.com" instead of "Suravee Suthikulpanit
>  <Suravee.Suthikulpanit@amd.com>", and that causes the extra From
>  line at the start of the mail, besides looking a bit strange.

Thanks for the pointer. I didn¹t notice that. I¹ll fix that for the future.

Suravee
>
>Thanks,
>
>	Arnd

