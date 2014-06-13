Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaFMMpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 08:45:34 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:45335
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750784AbaFMMpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 08:45:32 -0400
X-WSS-ID: 0N73Y3L-08-SUS-02
X-M-MSG: 
Message-ID: <539AF258.1080202@amd.com>
Date: Fri, 13 Jun 2014 07:45:12 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, <tj@kernel.org>,
        <b.zolnierkie@samsung.com>
CC: <hdegoede@redhat.com>, <lho@apm.com>, <tphan@apm.com>, <stripathi@apm.com>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ahci: Check and set 64-bit DMA mask for platform
 AHCI driver
References: <1402594824-4151-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1402594824-4151-2-git-send-email-suravee.suthikulpanit@amd.com>
 <5399E7AD.8030901@cogentembedded.com>
In-Reply-To: <5399E7AD.8030901@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(189002)(24454002)(199002)(479174003)(51704005)(377454003)(101416001)(65816999)(77096999)(64706001)(97736001)(31966008)(65806001)(65956001)(83322001)(46102001)(74502001)(74662001)(80022001)(86362001)(50466002)(99396002)(102836001)(54356999)(50986999)(92726001)(87266999)(92566001)(76176999)(2201001)(33656002)(81542001)(81342001)(87936001)(76482001)(77982001)(20776003)(4396001)(83072002)(83506001)(21056001)(68736004)(44976005)(23756003)(79102001)(36756003)(59896001)(47776003)(85852003)(105586001)(61793002);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0201MB0825;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0241D5F98C
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/2014 12:47 PM, Sergei Shtylyov wrote:
>> diff --git a/drivers/ata/libahci_platform.c
>> b/drivers/ata/libahci_platform.c
>> index 3a5b4ed..a958a2b 100644
>> --- a/drivers/ata/libahci_platform.c
>> +++ b/drivers/ata/libahci_platform.c
>> @@ -364,6 +364,19 @@ int ahci_platform_init_host(struct
>> platform_device *pdev,
>>               ap->ops = &ata_dummy_port_ops;
>>       }
>>
>> +    if (hpriv->cap & HOST_CAP_64) {
>> +        rc = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
>> +        if (rc) {
>> +            rc = dma_coerce_mask_and_coherent(dev,
>> +                              DMA_BIT_MASK(32));
>> +            if (rc) {
>> +                dev_err(dev, "Failed to enable 64-bit DMA.\n");
>
>     Not 32-bit?
Actually, I intended to say 64 since this is supposed to be setting up 
64-bit DMA mask. Or we could just say failed to set up DMA mask.

Suravee

