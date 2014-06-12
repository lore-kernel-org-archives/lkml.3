Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaFLGgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:36:38 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:53338
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750920AbaFLGgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:36:36 -0400
X-WSS-ID: 0N71MCV-08-Z20-02
X-M-MSG: 
Message-ID: <53994A6E.9070403@amd.com>
Date: Thu, 12 Jun 2014 01:36:30 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        David Milburn <dmilburn@redhat.com>
CC: <tj@kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ata: Check and set 64-bit DMA mask for platform AHCI
 driver
References: <1400866510-3130-1-git-send-email-suravee.suthikulpanit@amd.com>
 <53977E79.2090000@redhat.com> <3571472.yt2eJCmG5L@amdc1032>
In-Reply-To: <3571472.yt2eJCmG5L@amdc1032>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(24454002)(189002)(199002)(51704005)(479174003)(377454003)(77096999)(80022001)(87266999)(81542001)(87936001)(86362001)(81342001)(65956001)(77982001)(33656002)(92726001)(83322001)(44976005)(47776003)(54356999)(83506001)(101416001)(20776003)(65816999)(21056001)(59896001)(84676001)(50986999)(102836001)(19580405001)(50466002)(74662001)(80316001)(97736001)(65806001)(23756003)(64706001)(99136001)(85852003)(76176999)(74502001)(68736004)(76482001)(4396001)(83072002)(46102001)(19580395003)(36756003)(61793002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0201MB0831;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02408926C4
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/11/2014 04:30 AM, Bartlomiej Zolnierkiewicz wrote:
>
> Hi,
>
> On Tuesday, June 10, 2014 04:54:01 PM David Milburn wrote:
>> On 05/23/2014 12:35 PM, suravee.suthikulpanit@amd.com wrote:
>>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>>
>>> The current platform AHCI drier does not set the dma_mask correctly
>>> for 64-bit DMA capable AHCI controller.  This patch checks the AHCI
>>> capability bit and set the dma_mask and coherent_dma_mask accordingly.
>>>
>>> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>> ---
>>>    drivers/ata/libahci_platform.c | 9 +++++++++
>>>    1 file changed, 9 insertions(+)
>>>
>>> diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
>>> index 7cb3a85..85049ef 100644
>>> --- a/drivers/ata/libahci_platform.c
>>> +++ b/drivers/ata/libahci_platform.c
>>> @@ -368,6 +368,15 @@ int ahci_platform_init_host(struct platform_device *pdev,
>>
>> Hi Suravee,
>>
>> Would it be better to do the following before ahci_reset_controller()?
>>
>>           /* initialize adapter */
>>           rc = ahci_configure_dma_masks(pdev, hpriv->cap & HOST_CAP_64);
>>           if (rc)
>>                  	return rc;
>
> ahci_configure_dma_masks() is currently for PCI controllers only
> so it can't be used for libahci_platform.c.
>
> When it comes to setting DMA masks before ahci_reset_controller()
> I don't think that it matters but it will make platform code more
> similar to PCI one which is a good thing.

I can move this logic before ahci_reset_controller() in V2.

Suravee


