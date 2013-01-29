Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3A2GKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 01:10:06 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:26712 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab3A2GKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 01:10:02 -0500
Message-ID: <51076787.1020201@huawei.com>
Date: Tue, 29 Jan 2013 14:09:11 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jon Mason <jdmason@kudzu.us>
CC: Rob Landley <rob@landley.net>, Bjorn Helgaas <bhelgaas@google.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Andrew Murray <andrew.murray@arm.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>
Subject: Re: [PATCH v3] PCI: Document PCIE BUS MPS parameters
References: <1359106615-17544-1-git-send-email-wangyijing@huawei.com> <CAPoiz9zw-pVNGZC7Ox+Kf+=RNHJRCY5hoLejbrmWmjvHtUEihg@mail.gmail.com>
In-Reply-To: <CAPoiz9zw-pVNGZC7Ox+Kf+=RNHJRCY5hoLejbrmWmjvHtUEihg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/29 13:00, Jon Mason wrote:
> On Fri, Jan 25, 2013 at 2:36 AM, Yijing Wang <wangyijing@huawei.com> wrote:
>> v0->v1: Update MPS parameters as non-arch and add MRRS
>>                 description into pcie_bus_perf parameter suggested
>>                 by Andrew Murray.
>> v1->v2: Update some semantic problems and add MPS and MRRS
>>                 explanation suggested by Joe Lawrence and Randy Dunlap.
>> v2->v3: Update some semantic problems and the description
>>                 of pcie_bus_safe and pcie_bus_peer2peer suggested
>>                 by Bjorn Helgaas.
>>
>> Document PCIE BUS MPS parameters pcie_bus_tune_off, pcie_bus_safe,
>> pcie_bus_peer2peer, pcie_bus_perf into Documentation/kernel-parameters.txt.
>> These parameters were introduced by Jon Mason <mason@myri.com> at
>> commit 5f39e6705 and commit b03e7495a8.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  Documentation/kernel-parameters.txt |   13 +++++++++++++
>>  1 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 363e348..2997df2 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -2227,6 +2227,19 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>                                 This sorting is done to get a device
>>                                 order compatible with older (<= 2.4) kernels.
>>                 nobfsort        Don't sort PCI devices into breadth-first order.
>> +               pcie_bus_tune_off       Disable PCIe MPS (Max Payload Size)
>> +                               tuning and use the BIOS-configured MPS defaults.
>> +               pcie_bus_safe   Use the smallest supported MPS of any device
>> +                               below a root complex.
> 
> This isn't correct.  It should be something like "The largest MPS
> common to all devices below the root complex".

Hi Jon,
   Thanks for your review and comment!
What about "Set every device's MPS to the largest MPSS (Max Payload Size Support)
common to all devices below the root complex" ?

> 
>> +               pcie_bus_perf   Configure device MPS to the largest
>> +                               allowable MPS based on its parent bus. Also set
>> +                               MRRS (Max Read Request Size) to the largest supported
>> +                               value (no larger than the MPS that the device or bus
>> +                               can support) for best performance.
>> +               pcie_bus_peer2peer      Set every device's MPS to 128B, which
>> +                               every device is guaranteed to support. This
>> +                               configuration allows peer-to-peer DMA between any pair
>> +                               of devices possibly at the cost of reduced performance.
>>                 cbiosize=nn[KMG]        The fixed amount of bus space which is
>>                                 reserved for the CardBus bridge's IO window.
>>                                 The default value is 256 bytes.
>> --
>> 1.7.1
>>
>>
> 
> .
> 


-- 
Thanks!
Yijing

