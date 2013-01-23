Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3AWKNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:13:33 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:65174 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3AWKN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:13:29 -0500
Message-ID: <50FFB7AE.6050304@gmail.com>
Date: Wed, 23 Jan 2013 18:13:02 +0800
From: Yijing Wang <wangyijing0307@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Murray <andrew.murray@arm.com>
CC: Yijing Wang <wangyijing@huawei.com>, Rob Landley <rob@landley.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Mason <jdmason@kudzu.us>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>
Subject: Re: [PATCH] PCI: Document PCIE BUS MPS parameters
References: <1358928096-29008-1-git-send-email-wangyijing@huawei.com> <20130123092150.GA25603@arm.com>
In-Reply-To: <20130123092150.GA25603@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013-01-23 17:21, Andrew Murray 写道:
> On Wed, Jan 23, 2013 at 08:01:36AM +0000, Yijing Wang wrote:
>> Document PCIE BUS MPS parameters pcie_bus_tune_off, pcie_bus_safe,
>> pcie_bus_peer2peer, pcie_bus_perf into Documentation/kernel-parameters.txt.
>> These parameters were introduced by Jon Mason <mason@myri.com> at
>> commit 5f39e6705 and commit b03e7495a8. Document these into 
>> kernel-parameters.txt help users to understand and use the parameters.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  Documentation/kernel-parameters.txt |   13 +++++++++++++
>>  1 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 363e348..4dfa8d2 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -2227,6 +2227,19 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>  				This sorting is done to get a device
>>  				order compatible with older (<= 2.4) kernels.
>>  		nobfsort	Don't sort PCI devices into breadth-first order.
>> +		pcie_bus_tune_off	[X86] Disable PCI-E MPS turning and using
>> +				the BIOS configured MPS defaults.
>> +		pcie_bus_safe	[X86] Use the smallest common denominator MPS
>> +				of the entire tree below a root complex for every device
>> +				on that fabric. Can avoid inconsistent mps problem caused
>> +				by hotplug.
>> +		pcie_bus_perf	[X86] Configure pcie device MPS to the largest
>> +				allowable MPS based on its parent bus.Improve performance
>> +				as much as possible.
>> +		pcie_bus_peer2peer	[X86] Make the system wide MPS the smallest
>> +				possible value (128B).This configuration could prevent it
>> +				from working by having the MPS on one root port different
>> +				than the MPS on another.
>>  		cbiosize=nn[KMG]	The fixed amount of bus space which is
>>  				reserved for the CardBus bridge's IO window.
>>  				The default value is 256 bytes.
>>
> I was searching for documentation on this the other day.
> 
> It's not just X86 that use these options, PowerPC and Tile also use them (grep
> for users of pcie_bus_configure_settings). I've also noticed a call to it from
> hotplug as well...

Hi Andrew,
   Thanks for reminder! I will update this patch right now.

> 
> In addition these options also have an effect on MRRS - I've not figured out
> what effect they have, but you can look in drivers/pci/probe.c at the
> pcie_write_mrrs function.

This is a separate issue, Andrew, can you provide the effetct problem log or detail information?
That will helps us to analyze this issue.

> 
> Andrew Murray
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

