Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbaJBOvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:51:50 -0400
Received: from mail-bn1bn0108.outbound.protection.outlook.com ([157.56.110.108]:48726
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752294AbaJBOvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:51:48 -0400
X-Greylist: delayed 1041 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Oct 2014 10:51:48 EDT
X-WSS-ID: 0NCTMEX-08-XUB-02
X-M-MSG: 
Message-ID: <542D5EB8.7080602@amd.com>
Date: Thu, 2 Oct 2014 09:18:32 -0500
From: Joel Schopp <joel.schopp@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>,
        Marti Raudsepp <marti@juffo.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Add ACS support for AMD A88X southbridge devices
References: <1412255137-28954-1-git-send-email-marti@juffo.org>
 <1412257639.7360.247.camel@ul30vt.home>
In-Reply-To: <1412257639.7360.247.camel@ul30vt.home>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(479174003)(377454003)(377424004)(24454002)(199003)(164054003)(51704005)(189002)(23676002)(59896002)(4396001)(85306004)(105586002)(83506001)(76482002)(95666004)(50466002)(120916001)(99396003)(36756003)(15975445006)(44976005)(46102003)(19580405001)(80022003)(80316001)(19580395003)(68736004)(10300001)(20776003)(47776003)(64706001)(64126003)(31966008)(86362001)(65806001)(33656002)(87936001)(54356999)(65956001)(50986999)(101416001)(21056001)(85852003)(102836001)(97736003)(92566001)(106466001)(65816999)(84676001)(76176999)(87266999)(107046002)(92726001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB194;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-Forefront-PRVS: 03524FBD26
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Joel.Schopp@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/02/2014 08:47 AM, Alex Williamson wrote:
> On Thu, 2014-10-02 at 16:05 +0300, Marti Raudsepp wrote:
>> AMD has confirmed that peer-to-peer between two southbridge functions
>> does not occur.
>>
>> Joel Schopp at https://bugzilla.kernel.org/show_bug.cgi?id=81841#c15
>>>      +-14.4-[01]----05.0  Dialogic Corporation PRI
>>> The legacy PCI should be isolated from the other devices identified.
>>> Not sure what is going on here.
>>>
>>>      +-14.5  Advanced Micro Devices, Inc. [AMD] FCH USB OHCI Controller
>>> This OHCI Controller should also be isolated from the other devices.
>> Signed-off-by: Marti Raudsepp <marti@juffo.org>
> The bugzilla comments aren't quite as decisive as I'd like to see for a
> quirk, so I think we should probably get an ACK from Joel before
> including this.  Thanks,

My apologies for not being as clear as I could have been in the 
bugzilla.  These are isolated.  Acked-by is below.

>
> Alex
>
>> ---
>>   drivers/pci/quirks.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>> index 80c2d01..ce43316 100644
>> --- a/drivers/pci/quirks.c
>> +++ b/drivers/pci/quirks.c
>> @@ -3582,6 +3582,11 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
>>    * 1002:439d SB7x0/SB8x0/SB9x0 LPC host controller
>>    * 1002:4384 SBx00 PCI to PCI Bridge
>>    * 1002:4399 SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
>> + *
>> + * https://bugzilla.kernel.org/show_bug.cgi?id=81841#c15
>> + *
>> + * 1022:780f [AMD] FCH PCI Bridge
>> + * 1022:7809 [AMD] FCH USB OHCI Controller
>>    */
>>   static int pci_quirk_amd_sb_acs(struct pci_dev *dev, u16 acs_flags)
>>   {
>> @@ -3675,6 +3680,8 @@ static const struct pci_dev_acs_enabled {
>>   	{ PCI_VENDOR_ID_ATI, 0x439d, pci_quirk_amd_sb_acs },
>>   	{ PCI_VENDOR_ID_ATI, 0x4384, pci_quirk_amd_sb_acs },
>>   	{ PCI_VENDOR_ID_ATI, 0x4399, pci_quirk_amd_sb_acs },
>> +	{ PCI_VENDOR_ID_AMD, 0x780f, pci_quirk_amd_sb_acs },
>> +	{ PCI_VENDOR_ID_AMD, 0x7809, pci_quirk_amd_sb_acs },
>>   	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_quirk_intel_pch_acs },
>>   	{ 0 }
>>   };

Acked-by: Joel Schopp <joel.schopp@amd.com>
