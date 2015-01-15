Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbbAOVdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:33:21 -0500
Received: from mail-bn1bon0134.outbound.protection.outlook.com ([157.56.111.134]:46496
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932157AbbAOVdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:33:18 -0500
X-WSS-ID: 0NI8MJD-07-6E2-02
X-M-MSG: 
Message-ID: <54B8320C.5090201@amd.com>
Date: Thu, 15 Jan 2015 15:33:00 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Olof Johansson" <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, <Charles.Garcia-Tobin@arm.com>,
        <phoenix.liyi@huawei.com>, Timur Tabi <timur@codeaurora.org>,
        <wangyijing@huawei.com>, <linux-acpi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(479174004)(377454003)(24454002)(199003)(164054003)(51704005)(189002)(36756003)(92566002)(76176999)(87266999)(54356999)(23746002)(1720100001)(46102003)(65956001)(65806001)(120886001)(86362001)(83506001)(77096005)(97736003)(15975445007)(68736005)(101416001)(33656002)(59896002)(2950100001)(19580405001)(19580395003)(106466001)(50466002)(87936001)(50986999)(65816999)(77156002)(47776003)(62966003)(64706001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB195;
X-Forefront-PRVS: 0457F11EAF
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2015 21:33:15.0270
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/2015 9:04 AM, Hanjun Guo wrote:
> Hi,
>
> This is the v7 of ACPI core patches for ARM64 based on ACPI 5.1
>
> updates from v6:
>    - Rebased on top of 3.19-rc4, add Mack Salter's patch to use
>      the early_ioremap after paging_init() for ACPI table mappings;
>
>    - Two patches about converting apic_id to phys_id to make it arch
>      agnostic were already merged into RC4 by Rafael.
>
>    - Split patch "Parse FADT table to get PSCI flags for PSCI init"
>      into two as Lorenzo's suggestion, also fix typo and lack of __init
>      for psci_0_2_set_functions() which is spotted by Lorenzo.
>
>    - Add Tested-by from Yijing Wang.
>
> previous version is here:
> v6: https://lkml.org/lkml/2015/1/4/40
>
> 1. Why we need ACPI on ARM64?
>
>    - Grant already posted a blog about this, and stated clearly
>      why we need ACPI on ARM64:
>
>      http://www.secretlab.ca/archives/151
>
>
> 2. What we need to do before the arm64 ACPI core patches
>     could be merged into the kernel?
>
>    - Al Stone posted a TODO list and updates v2 for the
>      progress we made:
>      http://www.spinics.net/lists/arm-kernel/msg390069.html
>
>    - so from the progress we can see that we already finished
>      most of the items, and _OSI we got a plan to fix it, RFC
>      patch is on the way.
>
>
> This patch set was tested on FVP by Fuwei, and booted ok as expected.
> (No functional change since last version)
>
> Thanks
> Hanjun
>

The V7 patch series has also been re-tested on AMD Seattle server 
platform along with the "Introduce ACPI support for ahci_platform 
driver" patch series here (https://lkml.org/lkml/2015/1/5/662).

Tested-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Thanks,

Suravee

