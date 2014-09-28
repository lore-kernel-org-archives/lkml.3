Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaI1Vv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 17:51:57 -0400
Received: from [157.56.111.136] ([157.56.111.136]:39388 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753397AbaI1Vvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 17:51:55 -0400
X-WSS-ID: 0NCMSPU-08-PXH-02
X-M-MSG: 
Message-ID: <542882E3.2050908@amd.com>
Date: Sun, 28 Sep 2014 16:51:31 -0500
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ata: ahci_platform: Add ACPI support for AMD Seattle
 SATA controller
References: <1410295035-14471-1-git-send-email-suravee.suthikulpanit@amd.com>
 <CAOesGMh_Ku-pReg5LHVFvRM0-s_zEO4rgAvaD5rv-eTfPD71Yw@mail.gmail.com>
In-Reply-To: <CAOesGMh_Ku-pReg5LHVFvRM0-s_zEO4rgAvaD5rv-eTfPD71Yw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(428002)(199003)(51704005)(189002)(377454003)(24454002)(479174003)(77982003)(90102001)(107046002)(86362001)(50466002)(74662003)(81542003)(92726001)(20776003)(64706001)(47776003)(74502003)(68736004)(46102003)(79102003)(99396003)(65806001)(59896002)(95666004)(80022003)(97736003)(85852003)(110136001)(31966008)(54356999)(50986999)(76176999)(99136001)(101416001)(85306004)(102836001)(19580405001)(4396001)(10300001)(87266999)(84676001)(87936001)(23676002)(76482002)(81342003)(83072002)(65956001)(105586002)(83322001)(92566001)(64126003)(21056001)(19580395003)(83506001)(36756003)(65816999)(44976005)(33656002)(120916001)(80316001)(106466001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp02.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Forefront-PRVS: 03484C0ABF
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/11/2014 03:17 PM, Olof Johansson wrote:
> On Tue, Sep 9, 2014 at 1:37 PM,  <suravee.suthikulpanit@amd.com> wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> This patch adds ACPI support for non-PCI SATA contoller in ahci_platform driver.
>> It adds ACPI matching table in ahci_platform to support AMD Seattle SATA controller
>> with following ASL structure in DSDT:
>>
>>      Device (SATA0)
>>      {
>>        Name(_HID, "AMDI0600")    // Seattle AHSATA
>>        Name (_CCA, 1)            // Cache-coherent controller
>>        Name (_CRS, ResourceTemplate ()
>>        {
>>          Memory32Fixed (ReadWrite, 0xE0300000, 0x00010000)
>>          Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive,,,) { 387 }
>>        })
>>      }
>>
>> Since ATA driver should not require PCI support for ATA_ACPI,
>> this patch also removes dependency in the driver/ata/Kconfig.
>>
>> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> ---
>>   drivers/ata/Kconfig         |  2 +-
>>   drivers/ata/ahci_platform.c | 13 +++++++++++++
>>   2 files changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
>> index e1b9278..f2e6c9e 100644
>> --- a/drivers/ata/Kconfig
>> +++ b/drivers/ata/Kconfig
>> @@ -48,7 +48,7 @@ config ATA_VERBOSE_ERROR
>>
>>   config ATA_ACPI
>>          bool "ATA ACPI Support"
>> -       depends on ACPI && PCI
>> +       depends on ACPI
>>          default y
>>          help
>>            This option adds support for ATA-related ACPI objects.
>> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
>> index f61ddb9..3499bab 100644
>> --- a/drivers/ata/ahci_platform.c
>> +++ b/drivers/ata/ahci_platform.c
>> @@ -20,6 +20,9 @@
>>   #include <linux/platform_device.h>
>>   #include <linux/libata.h>
>>   #include <linux/ahci_platform.h>
>> +#ifdef CONFIG_ATA_ACPI
>> +#include <linux/acpi.h>
>> +#endif
>>   #include "ahci.h"
>>
>>   static const struct ata_port_info ahci_port_info = {
>> @@ -87,6 +90,13 @@ static const struct of_device_id ahci_of_match[] = {
>>   };
>>   MODULE_DEVICE_TABLE(of, ahci_of_match);
>>
>> +#ifdef CONFIG_ATA_ACPI
>> +static const struct acpi_device_id ahci_acpi_match[] = {
>> +       { "AMDI0600", 0 }, /* AMD Seattle AHCI */
>> +       { },
>> +};
>> +#endif
>> +
>>   static struct platform_driver ahci_driver = {
>>          .probe = ahci_probe,
>>          .remove = ata_platform_remove_one,
>> @@ -94,6 +104,9 @@ static struct platform_driver ahci_driver = {
>>                  .name = "ahci",
>>                  .owner = THIS_MODULE,
>>                  .of_match_table = ahci_of_match,
>> +#ifdef CONFIG_ATA_ACPI
>> +               .acpi_match_table = ACPI_PTR(ahci_acpi_match),
>> +#endif
>
> The whole point of having ACPI_PTR() is to avoid having ifdefs like
> these. The structure member is always there, so there's no need to
> have it conditionally compiled out.
>
> Come to think of it, the match table should be under CONFIG_ACPI
> instead -- why do a separate config option just for this?
>
>
> -Olof
>

Good point. Thanks.  I will make change to this, and send out the next 
one soon.

Suravee
