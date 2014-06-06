Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaFFQLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:11:34 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:44308
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751693AbaFFQLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:11:32 -0400
X-WSS-ID: 0N6R8YH-08-X49-02
X-M-MSG: 
Message-ID: <5391E812.1060009@amd.com>
Date: Fri, 6 Jun 2014 11:10:58 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ata: Check and set 64-bit DMA mask for platform AHCI
 driver
References: <1400866510-3130-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140603175827.GH26210@htj.dyndns.org>
In-Reply-To: <20140603175827.GH26210@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(24454002)(189002)(199002)(51704005)(377454003)(479174003)(76176999)(80022001)(77096999)(65816999)(65806001)(33656002)(50466002)(101416001)(4396001)(15202345003)(64706001)(87266999)(50986999)(54356999)(64126003)(74662001)(81342001)(79102001)(31966008)(74502001)(47776003)(20776003)(81542001)(23756003)(86362001)(68736004)(77982001)(59896001)(83072002)(46102001)(97736001)(19580395003)(83506001)(83322001)(19580405001)(76482001)(80316001)(44976005)(99396002)(15975445006)(65956001)(85852003)(102836001)(36756003)(87936001)(84676001)(92566001)(21056001)(92726001)(61793002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB193;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 023495660C
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans/Bartlomiej,

Do you guys have any questions about this patch?

Thank you,

Suravee

On 6/3/2014 12:58 PM, Tejun Heo wrote:
> Hans, Bartlomiej, can you guys please review this patch?
>
> Thanks.
>
> On Fri, May 23, 2014 at 12:35:10PM -0500, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> The current platform AHCI drier does not set the dma_mask correctly
>> for 64-bit DMA capable AHCI controller.  This patch checks the AHCI
>> capability bit and set the dma_mask and coherent_dma_mask accordingly.
>>
>> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> ---
>>   drivers/ata/libahci_platform.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
>> index 7cb3a85..85049ef 100644
>> --- a/drivers/ata/libahci_platform.c
>> +++ b/drivers/ata/libahci_platform.c
>> @@ -368,6 +368,15 @@ int ahci_platform_init_host(struct platform_device *pdev,
>>   	ahci_init_controller(host);
>>   	ahci_print_info(host, "platform");
>>
>> +	if (hpriv->cap & HOST_CAP_64) {
>> +		if (!dev->dma_mask)
>> +			dev->dma_mask = &dev->coherent_dma_mask;
>> +
>> +		rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
>> +		if (rc)
>> +			return rc;
>> +	}
>> +
>>   	return ata_host_activate(host, irq, ahci_interrupt, IRQF_SHARED,
>>   				 &ahci_platform_sht);
>>   }
>> --
>> 1.9.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


