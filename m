Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaKFNtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:49:08 -0500
Received: from mail-by2on0143.outbound.protection.outlook.com ([207.46.100.143]:31362
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751589AbaKFNtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:49:05 -0500
X-WSS-ID: 0NEMEDL-07-N9R-02
X-M-MSG: 
Message-ID: <545B7C43.4020106@amd.com>
Date: Thu, 6 Nov 2014 15:48:51 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] iommu/amd: Use delayed mmu release notifier
References: <54418D7F.3050304@amd.com> <20141106133354.GP10744@8bytes.org>
In-Reply-To: <20141106133354.GP10744@8bytes.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(377454003)(199003)(479174003)(189002)(24454002)(52314003)(51704005)(92726001)(19580395003)(92566001)(54356999)(68736004)(50986999)(15975445006)(77156002)(101416001)(76176999)(87266999)(36756003)(50466002)(83506001)(15202345003)(19580405001)(80316001)(23746002)(62966003)(44976005)(64126003)(87936001)(65816999)(97736003)(106466001)(33656002)(46102003)(110136001)(105586002)(20776003)(4396001)(84676001)(21056001)(64706001)(59896002)(99396003)(95666004)(102836001)(120916001)(47776003)(86362001)(31966008)(65806001)(65956001)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0387D64A71
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/06/2014 03:33 PM, Joerg Roedel wrote:
> On Sat, Oct 18, 2014 at 12:43:27AM +0300, Oded Gabbay wrote:
>> 3. Later, amdkfd's mmu notifier callback (kfd_process_notifier_release()) gets
>>     called and releases more things that are related to the process.
>>     In that function, amd_iommu_unbind_pasid() is explicitly called.
>
> Can't you just register a delayed funtion in
> kfd_process_notifier_release() and call amd_iommu_unbind_pasid() from
> there?
Maybe, I need to think about that. Anyway, I'm still not convinced, please see 
next question.

 >>I really hate to make that part of the IOMMUv2 driver API,
What do you mean ? I don't see I change anything in the API. All the changes are 
internal to amd_iommu_unbind_pasid(). I don't think *anyone* calling to 
amd_iommu_unbind_pasid() will care or will notice the slight change in timing of 
releasing the pasid_state object (instead of immediate release, it is released 
after the iteration on the mmu_notifier list has finished)

> especially since it is going to be turned into a generic IOMMU-API
> extension.
>
> And especially since all these hacks could be avoided if the KFD driver
> would just turn down everything on closing the file descriptor.
>
>
> 	Joerg
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
