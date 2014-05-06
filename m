Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaEFT12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:27:28 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:26318
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753995AbaEFT10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:27:26 -0400
X-WSS-ID: 0N563D7-07-CRC-02
X-M-MSG: 
Message-ID: <5369378C.9010902@amd.com>
Date: Tue, 6 May 2014 14:27:08 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kim.naru@amd.com>, <jay.cornwall@amd.com>
Subject: Re: [PATCH] iommu/amd: Take mmap_sem when calling get_user_pages
References: <1398724066-3730-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140506181438.GD12376@8bytes.org> <536933E9.6040404@amd.com>
In-Reply-To: <536933E9.6040404@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(479174003)(377454003)(51704005)(199002)(189002)(24454002)(85852003)(77982001)(21056001)(74662001)(74502001)(76482001)(4396001)(83072002)(46102001)(84676001)(101416001)(92566001)(81542001)(83506001)(86362001)(50986999)(81342001)(92726001)(97736001)(87936001)(36756003)(68736004)(19580405001)(47776003)(19580395003)(20776003)(87266999)(99396002)(80316001)(65816999)(64706001)(2009001)(76176999)(83322001)(80022001)(77096999)(23756003)(65806001)(31966008)(64126003)(79102001)(44976005)(54356999);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR02MB123;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0203C93D51
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/2014 2:11 PM, Suravee Suthikulanit wrote:
> On 5/6/2014 1:14 PM, Joerg Roedel wrote:
>> On Mon, Apr 28, 2014 at 05:27:46PM -0500, Suthikulpanit, Suravee wrote:
>>> From: Jay Cornwall <jay.cornwall@amd.com>
>>>
>>> get_user_pages requires caller to hold a read lock on mmap_sem.
>>
>> Right, but can't we just switch to get_user_pages_fast instead?
>>
>>
>>     Joerg
>>
>
> You're right. I think it can. Let me spin out another patch.
>
> Suravee
>

Actually, we would have to provide the pointer to task_struct for the 
corresponding PASID which is not necessary "current".  So I take it 
back. I don't think we can use _fast.

Suravee
