Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3AWPHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:07:35 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:21876
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225Ab3AWPHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:07:34 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h1155h)
X-WSS-ID: 0MH33C6-01-9AO-02
X-M-MSG: 
Message-ID: <50FFFCA5.1010309@amd.com>
Date: Wed, 23 Jan 2013 09:07:17 -0600
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, Borislav Petkov <bp@alien8.de>,
        <linux-kernel@vger.kernel.org>, Udo van den Heuvel <udovdh@xs4all.nl>,
        <ssg.sos.staff@mpdtxmail.amd.com>
Subject: Re: [PATCH 1/1] AMD Family15h Model10-1Fh erratum 746 Workaround
References: <1358896750-5199-1-git-send-email-suravee.suthikulpanit@amd.com> <20130123070604.GT25591@8bytes.org>
In-Reply-To: <20130123070604.GT25591@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/2013 1:06 AM, Joerg Roedel wrote:

> On Tue, Jan 22, 2013 at 05:19:10PM -0600, Suthikulpanit, Suravee wrote:
>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> @@ -1171,6 +1195,8 @@ static int iommu_init_pci(struct amd_iommu *iommu)
>>   		for (i = 0; i < 0x83; i++)
>>   			iommu->stored_l2[i] = iommu_read_l2(iommu, i);
>>   	}
>> +	
>> +	amd_iommu_apply_erratum_746(iommu);
> This will also be applied to RD890 IOMMUs, right? This workaround should
> be limited to Trinity IOMMUs.

Inside the function, it checks the family and model number.  Only Trinitiy is affected.

Suravee


