Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaCDRGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:06:42 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:20786
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820AbaCDRGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:06:41 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z579ehzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
X-WSS-ID: 0N1X8UZ-07-JE5-02
X-M-MSG: 
Message-ID: <5316081A.9020008@amd.com>
Date: Tue, 4 Mar 2014 11:06:34 -0600
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jay Cornwall <jay.cornwall@amd.com>, "Naru, Kim" <Kim.Naru@amd.com>
Subject: Re: [PATCH 1/1] iommu/amd: Fix PASID format in INVALIDATE_IOTLB_PAGES
 command
References: <1393451371-17894-1-git-send-email-suravee.suthikulpanit@amd.com> <20140304141251.GB2799@8bytes.org> <5316051E.2030004@amd.com>
In-Reply-To: <5316051E.2030004@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/2014 10:53 AM, Suravee Suthikulpanit wrote:
> On 3/4/2014 8:12 AM, Joerg Roedel wrote:
>> On Wed, Feb 26, 2014 at 03:49:31PM -0600,
>> suravee.suthikulpanit@amd.com wrote:
>>> From: Jay Cornwall <jay.cornwall@amd.com>
>>>
>>> This patch corrects the PASID format in the INVALIDATE_IOTLB_PAGES
>>> command, which was caused by incorrect information in
>>> the AMD IOMMU Architectural Specification v2.01 document.
>>>
>>>      Incorrect format:
>>>           cmd->data[0][16:23] = PASID[7:0]
>>>           cmd->data[1][16:27] = PASID[19:8]
>>>
>>>       Correct format:
>>>           cmd->data[0][16:23] = PASID[15:8]
>>>           cmd->data[1][16:23] = PASID[7:0]
>>>
>>> However, this does not affect the IOMMUv2 hardware implementation,
>>> and has been corrected since version 2.02 of the specification
>>> (available through AMD NDA).
>>>
>>> Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
>>> Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>
>> Applied, thanks.
>>
>> Does this mean that PASIDs are only 16 bits wide now from the former 20
>> bits?
>>
>>
>>
>
> Thank you Joerg. The specification also state that this command format
> does not support the maximum size of the PASID field. However, other
> commands seem to still support 20-bit PASID.
>
> Suravee

Actually, just thinking about this again, even though we don't have 
systems with 20-bit PASID yet (only up-to 16-bit), but for future proof, 
we should add another logic to make sure that this logic won't try to 
use the 20-bit PASID with this version of the command.  I'll send out 
another patch soon.

Suravee

