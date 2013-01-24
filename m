Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab3AXB4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 20:56:21 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:49586 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3AXB4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 20:56:12 -0500
Message-ID: <510094A4.3040806@huawei.com>
Date: Thu, 24 Jan 2013 09:55:48 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Rob Landley <rob@landley.net>, Bjorn Helgaas <bhelgaas@google.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jon Mason <jdmason@kudzu.us>, <linux-pci@vger.kernel.org>,
        Andrew Murray <andrew.murray@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>
Subject: Re: [Update][PATCH] PCI: Document PCIE BUS MPS parameters
References: <1358944092-28884-1-git-send-email-wangyijing@huawei.com> <510074C7.6090203@infradead.org>
In-Reply-To: <510074C7.6090203@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,
   Thanks for your review and comments! please refer to inlined comments below.

On 2013/1/24 7:39, Randy Dunlap wrote:
> On 01/23/13 04:28, Yijing Wang wrote:
>> Document PCIE BUS MPS parameters pcie_bus_tune_off, pcie_bus_safe,
>> pcie_bus_peer2peer, pcie_bus_perf into Documentation/kernel-parameters.txt.
>> These parameters were introduced by Jon Mason <mason@myri.com> at
>> commit 5f39e6705 and commit b03e7495a8. Document these into
>> kernel-parameters.txt can help users to understand and use the parameters.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  Documentation/kernel-parameters.txt |   15 +++++++++++++++
>>  1 files changed, 15 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 363e348..1fb269b 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -2227,6 +2227,21 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>  				This sorting is done to get a device
>>  				order compatible with older (<= 2.4) kernels.
>>  		nobfsort	Don't sort PCI devices into breadth-first order.
>> +		pcie_bus_tune_off	Disable PCI-E MPS turning and using
>> +				the BIOS configured MPS defaults.
> 
> 				    BIOS-configured

Will update it.

> 
>> +		pcie_bus_safe	Use the smallest common denominator MPS
>> +				of the entire tree below a root complex for every device
>> +				on that fabric. Can avoid inconsistent mps problem caused
> 
> s/mps/MPS/
> i.e., use "MPS" consistently.

Will use mps consistently.

> 
>> +				by hotplug.
>> +		pcie_bus_perf	Configure pcie device MPS to the largest allowable
>> +				MPS based on its parent bus. And also set MRRS to the
> 
> "And also" is redundant.  Just say Also.

Ok.

> 
> What is (are) MRRS?

MRRS is "Max Read Request Size" and MPS is "Max Payload Size".
Need use "Max Read Request Size" instead of MRRS ?

> 
>> +				largest supported value but cannot be configured larger
>> +				than the MPS the device or the bus can support for Max
>> +				performance.
>> +		pcie_bus_peer2peer	Make the system wide MPS the smallest
> 
> 					         system-wide

Will update it.

> 
>> +				possible value (128B).This configuration could prevent it
> 
> 				                      ^ Space before "This"
> 

Thanks for reminder.

>> +				from working by having the MPS on one root port different
>> +				than the MPS on another.
>>  		cbiosize=nn[KMG]	The fixed amount of bus space which is
>>  				reserved for the CardBus bridge's IO window.
>>  				The default value is 256 bytes.
>>
> 
> 


-- 
Thanks!
Yijing

