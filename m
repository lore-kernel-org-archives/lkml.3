Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaLSSWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 13:22:09 -0500
Received: from mail-by2on0102.outbound.protection.outlook.com ([207.46.100.102]:44384
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752557AbaLSSWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 13:22:07 -0500
X-WSS-ID: 0NGUDOJ-08-FV1-02
X-M-MSG: 
Message-ID: <54946CBB.4050108@amd.com>
Date: Fri, 19 Dec 2014 12:21:47 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linaro-acpi@lists.linaro.org>
CC: <rjw@rjwysocki.net>, <lenb@kernel.org>, <hdegoede@redhat.com>,
        <tj@kernel.org>, <mjg59@srcf.ucam.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
Subject: Re: [Linaro-acpi] [RFC PATCH 2/2] ata: ahci_platform: Add ACPI _CLS
 matching
References: <1418858195-22857-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1418858195-22857-3-git-send-email-suravee.suthikulpanit@amd.com>
 <3408260.hhf4YMy6F6@wuerfel>
In-Reply-To: <3408260.hhf4YMy6F6@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(377454003)(199003)(164054003)(189002)(24454002)(479174004)(51704005)(33656002)(92566001)(97736003)(87936001)(23746002)(54356999)(76176999)(77156002)(99396003)(101416001)(80316001)(65816999)(36756003)(46102003)(50986999)(87266999)(86362001)(99136001)(65806001)(106466001)(64706001)(21056001)(105586002)(83506001)(68736005)(77096005)(65956001)(84676001)(2950100001)(107046002)(120886001)(64126003)(120916001)(4396001)(62966003)(47776003)(20776003)(59896002)(50466002)(31966008)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR02MB203;
X-Forefront-PRVS: 0430FA5CB7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2014 3:17 AM, Arnd Bergmann wrote:
> On Wednesday 17 December 2014 17:16:35 Suravee Suthikulpanit wrote:
>> +#ifdef CONFIG_ATA_ACPI
>> +#include <linux/acpi.h>
>> +#endif
>>   #include "ahci.h"
>>
>>   static const struct ata_port_info ahci_port_info = {
>> @@ -71,6 +74,10 @@ static const struct of_device_id ahci_of_match[] = {
>>   };
>>   MODULE_DEVICE_TABLE(of, ahci_of_match);
>>
>> +#ifdef CONFIG_ATA_ACPI
>> +static const struct acpi_device_cls ahci_cls = {0x01, 0x06, 0x01};
>> +#endif
>> +
>>   static struct platform_driver ahci_driver = {
>>          .probe = ahci_probe,
>>          .remove = ata_platform_remove_one,
>> @@ -78,6 +85,9 @@ static struct platform_driver ahci_driver = {
>>                  .name = "ahci",
>>                  .owner = THIS_MODULE,
>>                  .of_match_table = ahci_of_match,
>> +#ifdef CONFIG_ATA_ACPI
>> +               .acpi_cls = &ahci_cls,
>> +#endif
>>                  .pm = &ahci_pm_ops,
>>
>
> It would be better to leave out the various #ifdef here, in particular the
> one around the header file inclusion.
>
> 	Arnd
>

Right. I'll get rid of them. Also, I noticed that I should have declared 
acpi_match_device_cls() in include/linux/acpi.h as "inline" for when 
building w/o ACPI to avoid warning messages.

Thanks,

Suravee

