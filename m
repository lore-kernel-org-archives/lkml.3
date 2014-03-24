Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaCXTgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:36:21 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:50772 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754277AbaCXTgR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:36:17 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z579ehz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh109h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh1155h)
X-WSS-ID: 0N2YH0D-07-6HO-02
X-M-MSG: 
From: "Cornwall, Jay" <Jay.Cornwall@amd.com>
To: Joerg Roedel <joro@8bytes.org>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Naru, Kim" <Kim.Naru@amd.com>
Subject: RE: [PATCH V2] iommu/amd: Fix logic to determine and checking max
 PASID
Thread-Topic: [PATCH V2] iommu/amd: Fix logic to determine and checking max
 PASID
Thread-Index: AQHPR3h4vdvUyOrXM0OjsM2WwutzqprwnP0g
Date: Mon, 24 Mar 2014 19:33:50 +0000
Message-ID: <99CB3FADB756624A867BE9481439561C334AC1BF@satlexdag03.amd.com>
References: <1394067258-5968-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140324154806.GB2775@8bytes.org>
In-Reply-To: <20140324154806.GB2775@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:

>On Wed, Mar 05, 2014 at 06:54:18PM -0600, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> 
>> In reality, the spec can only support 16-bit PASID since 
>> INVALIDATE_IOTLB_PAGES and COMPLETE_PPR_REQUEST commands only allow 
>> 16-bit PASID. So, we updated the PASID_MASK accordingly and invoke 
>>BUG_ON if the hardware is reporting PASmax more than 16-bit.
>> 
>>Besides, max PASID is defined as ((2^(PASmax+1)) - 1). The current 
>> does not determine this correctly.
>> 
>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> Tested-by: Jay Cornwall <Jay.Cornwall@amd.com>
> 
> Applied, thanks.
> 
> Btw, is there any publicly available driver/way/whatever for me to test the AMD IOMMUv2 code paths?

We are testing on a kernel development branch which enables ATS translation from shaders on the Kaveri APU. See drivers/gpu/hsa/radeon at http://cgit.freedesktop.org/~gabbayo/linux/ for the kernel driver.

Testing requires some setup in user mode to construct a PM4 command stream and CIK assembly, similar to the DRM/Mesa UMD implementation. Even then, it is not possible to observe translations directly. Our testing is limited to indirect observations; e.g. modifying VA:PA mappings and ensuring shader loads/stores reflect expected results.

I don't know of a way to exercise the IOMMUv2 code paths without an IOTLB client.

