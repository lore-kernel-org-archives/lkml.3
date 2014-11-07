Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaKGUWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 15:22:23 -0500
Received: from mail-bn1bon0117.outbound.protection.outlook.com ([157.56.111.117]:22880
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751285AbaKGUWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 15:22:22 -0500
X-WSS-ID: 0NEOR95-07-TKD-02
X-M-MSG: 
Message-ID: <545D29F6.1000200@amd.com>
Date: Fri, 7 Nov 2014 22:22:14 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] iommu/amd: Use delayed mmu release notifier
References: <54418D7F.3050304@amd.com> <20141106133354.GP10744@8bytes.org>
In-Reply-To: <20141106133354.GP10744@8bytes.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(51704005)(24454002)(479174003)(377454003)(189002)(36756003)(59896002)(46102003)(15202345003)(92566001)(62966003)(102836001)(107046002)(33656002)(101416001)(80316001)(19580405001)(120916001)(68736004)(19580395003)(64706001)(23676002)(64126003)(77156002)(50466002)(65806001)(83506001)(20776003)(4396001)(86362001)(105586002)(110136001)(50986999)(65956001)(84676001)(44976005)(15975445006)(92726001)(54356999)(21056001)(65816999)(47776003)(31966008)(87936001)(99396003)(97736003)(106466001)(76176999)(87266999)(95666004);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03883BD916
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/06/2014 03:33 PM, Joerg Roedel wrote:
> On Sat, Oct 18, 2014 at 12:43:27AM +0300, Oded Gabbay wrote:
>> 3. Later, amdkfd's mmu notifier callback (kfd_process_notifier_release()) gets
>>    called and releases more things that are related to the process.
>>    In that function, amd_iommu_unbind_pasid() is explicitly called.
> 
> Can't you just register a delayed funtion in
> kfd_process_notifier_release() and call amd_iommu_unbind_pasid() from
> there? 
OK, I implemented that and I don't need to change the IOMMUv2 code anymore.
So, I think we can conclude this discussion at this point :)

	Oded

I really hate to make that part of the IOMMUv2 driver API,
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
