Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbbAGVkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:40:23 -0500
Received: from mail-by2on0113.outbound.protection.outlook.com ([207.46.100.113]:51232
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753382AbbAGVkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:40:21 -0500
X-WSS-ID: 0NHTTJ2-08-FQR-02
X-M-MSG: 
Message-ID: <54ADA7B2.8000205@amd.com>
Date: Wed, 7 Jan 2015 15:40:02 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <lenb@kernel.org>, <hdegoede@redhat.com>, <tj@kernel.org>, <arnd@arndb.de>,
        <mjg59@srcf.ucam.org>, <grant.likely@linaro.org>,
        <hanjun.guo@linaro.org>, <al.stone@linaro.org>,
        <graeme.gregory@linaro.org>, <leo.duran@amd.com>,
        <linux-ide@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-acpi@lists.linaro.org>
Subject: Re: [V2 PATCH 0/2] Introduce ACPI support for ahci_platform driver
References: <1420492275-6878-1-git-send-email-Suravee.Suthikulpanit@amd.com>
 <2457489.S2ztcy2W3i@vostro.rjw.lan>
In-Reply-To: <2457489.S2ztcy2W3i@vostro.rjw.lan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(209900001)(24454002)(41574002)(189002)(479174004)(36944003)(43544003)(199003)(377454003)(51704005)(87936001)(46102003)(99396003)(2950100001)(92566001)(110136001)(64126003)(15975445007)(84676001)(105586002)(50986999)(76176999)(54356999)(87266999)(77156002)(62966003)(31966008)(65816999)(15395725005)(20776003)(64706001)(33656002)(120916001)(36756003)(120886001)(101416001)(80316001)(19580395003)(86362001)(106466001)(83506001)(77096005)(21056001)(59896002)(19273905006)(23676002)(47776003)(4396001)(65956001)(107046002)(50466002)(19300405004)(562404015)(563064011)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR02MB203;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR02MB203;
X-Forefront-PRVS: 044968D9E1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2015 21:40:16.6871
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR02MB203
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/5/2015 5:24 PM, Rafael J. Wysocki wrote:
> On Monday, January 05, 2015 03:11:13 PM Suravee Suthikulpanit wrote:
>> This patch series introduce ACPI support for non-PCI AHCI platform driver.
>> Existing ACPI support for AHCI assumes the device controller is a PCI device.
>>
>> Also, since there is no ACPI _HID/_CID for generic AHCI controller, the driver
>> could not use them for matching devices. Therefore, this patch introduces
>> a mechanism for drivers to match devices using ACPI _CLS method.
>>
>> This patch series is rebased from and tested with:
>>
>>      http://git.linaro.org/leg/acpi/acpi.git acpi-5.1-v7
>>
>> This topic was discussed earlier here (as part of introducing support for
>> AMD Seattle SATA controller):
>>
>>      http://marc.info/?l=linux-arm-kernel&m=141083492521584&w=2
>>
>> NOTE:
>> 	* PATCH 2/2 has already been Acked-by Tejun Heo in V1. I only made
>> 	  a minor renaming of the acpi_cls to acpi_match_cls for clarity
>> 	  in V2. It probably should be routed together with the PATCH 1/2
>> 	  (once acked) since it defines the new member in the struct.
>>
>> Changes V1 (https://lkml.org/lkml/2014/12/19/345)
>> 	* Rebased to 3.19.0-rc2
>> 	* Change from acpi_cls in device_driver to acpi_match_cls (Hanjun comment)
>> 	* Change the matching logic in acpi_driver_match_device() due to the new
>> 	  special PRP0001 _HID.
>> 	* Simplify the return type of acpi_match_device_cls() to boolean.
>>
>> Changes from RFC (https://lkml.org/lkml/2014/12/17/446)
>> 	* Remove #ifdef and make non-ACPI version of the acpi_match_device_cls
>> 	  as inline. (per Arnd)
>> 	* Simplify logic to retrieve and evaluate _CLS handle. (per Hanjun)
>>
>> Suravee Suthikulpanit (2):
>>    ACPI / scan: Add support for ACPI _CLS device matching
>>    ata: ahci_platform: Add ACPI _CLS matching
>>
>>   drivers/acpi/scan.c             | 79 +++++++++++++++++++++++++++++++++++++++--
>>   drivers/ata/Kconfig             |  2 +-
>>   drivers/ata/ahci_platform.c     |  3 ++
>>   include/acpi/acnames.h          |  1 +
>>   include/linux/acpi.h            | 10 ++++++
>>   include/linux/device.h          |  1 +
>>   include/linux/mod_devicetable.h |  6 ++++
>>   7 files changed, 98 insertions(+), 4 deletions(-)
>
> I'll take care of this when I'm back from travels later this month.  Thanks!
>

Thanks Rafael.

Suravee

