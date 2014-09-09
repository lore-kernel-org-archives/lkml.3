Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaIIPOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:14:19 -0400
Received: from mail-bl2on0119.outbound.protection.outlook.com ([65.55.169.119]:60416
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751766AbaIIPOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:14:17 -0400
X-Greylist: delayed 1329 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 11:14:16 EDT
X-WSS-ID: 0NBN1YA-07-7F8-02
X-M-MSG: 
Message-ID: <540F10A1.2030601@amd.com>
Date: Tue, 9 Sep 2014 09:37:21 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] edac, amd64_edac: Modify usage of amd64_read_dct_pci_cfg()
References: <1409679957-3536-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <20140909114250.GA30662@nazgul.tnic>
In-Reply-To: <20140909114250.GA30662@nazgul.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019018)(6009001)(428002)(189002)(377454003)(24454002)(164054003)(199003)(479174003)(51704005)(31966008)(74662001)(74502001)(110136001)(105586002)(46102001)(65956001)(80022001)(95666004)(101416001)(4396001)(102836001)(92726001)(92566001)(79102001)(47776003)(106466001)(107046002)(77982001)(86362001)(81542001)(20776003)(85852003)(65806001)(83072002)(23676002)(64126003)(76482001)(64706001)(81342001)(65816999)(36756003)(83506001)(90102001)(87936001)(84676001)(33656002)(50466002)(76176999)(99396002)(50986999)(97736003)(21056001)(85306004)(68736004)(44976005)(54356999)(83322001)(87266999);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB036;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0329B15C8A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/9/2014 6:42 AM, Borislav Petkov wrote:
> On Tue, Sep 02, 2014 at 12:45:57PM -0500, Aravind Gopalakrishnan wrote:
>> @@ -495,15 +493,56 @@ int __amd64_read_pci_cfg_dword(struct pci_dev *pdev, int offset,
>>   			       u32 *val, const char *func);
>>   int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
>>   				u32 val, const char *func);
>> -
>> +void f15h_select_dct(struct amd64_pvt *pvt, u8 dct);
>>   #define amd64_read_pci_cfg(pdev, offset, val)	\
>>   	__amd64_read_pci_cfg_dword(pdev, offset, val, __func__)
>>   
>>   #define amd64_write_pci_cfg(pdev, offset, val)	\
>>   	__amd64_write_pci_cfg_dword(pdev, offset, val, __func__)
>>   
>> -#define amd64_read_dct_pci_cfg(pvt, offset, val) \
>> -	pvt->ops->read_dct_pci_cfg(pvt, offset, val, __func__)
>> +/*
>> + * Depending on the family, F2 DCT reads need special handling:
>> + *
>> + * K8: has a single DCT only and no address offsets >= 0x100
>> + *
>> + * F10h: each DCT has its own set of regs
>> + *	DCT0 -> F2x040..
>> + *	DCT1 -> F2x140..
>> + *
>> + * F16h: has only 1 DCT
>> + *
>> + * For all above families, we should use the 'raw' version
>> + * i.e, amd64_read_pci_cfg() function
>> + */
>> +static inline int amd64_read_dct_pci_cfg(struct amd64_pvt *pvt, u8 dct,
>> +					 int offset, u32 *val)
> Why is this function in the header since it is being used only in
> amd64_edac.c, AFAICT?
>
> This makes you export f15h_select_dct() too, for no apparent reason.
>

Hmm. Yeah, no particular reason. The earlier macro was here so I think I 
just expanded it as an inline function here..
I shall move it to amd64_edac.c and resend.

Thanks,
-Aravind.
