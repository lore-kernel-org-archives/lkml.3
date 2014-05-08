Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbaEHQcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:32:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:25549 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849AbaEHQcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:32:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1012,1389772800"; 
   d="scan'208";a="508487192"
Message-ID: <536BB11D.3090602@intel.com>
Date: Fri, 09 May 2014 00:30:21 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Jiang, Dave" <dave.jiang@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "Lin, Wei W" <wei.w.lin@intel.com>
Subject: Re: [PATCH] DCA: fix over-warning in ioat3_dca_init
References: <1399542166-42985-1-git-send-email-jet.chen@intel.com>	 <536B9CF6.9000907@intel.com> <536BA2A3.50506@intel.com>	 <536BA96F.1030203@intel.com> <1399565636.122877.3.camel@djiang5-desk1.amr.corp.intel.com>
In-Reply-To: <1399565636.122877.3.camel@djiang5-desk1.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 12:13 AM, Jiang, Dave wrote:
> On Thu, 2014-05-08 at 08:57 -0700, Alexander Duyck wrote:
>> On 05/08/2014 08:28 AM, Jet Chen wrote:
>>> I agree with your option that it is a real BIOS bug and it puts pressure on the BIOS guys to get this fixed. However, this warning message interferes with our kernel booting tests and kernel performance tests. We have to disable CONFIG_INTEL_IOATDMA in kconfig until this issue gets fixed. Before that, code of CONFIG_INTEL_IOATDMA will not be validated in our testing system :(.
>>> Hope this issue could get fixed soon.
>>>
>>> Thanks,
>>> Jet
>>>
>>
>> First I would recommend updating your BIOS.  If the updated BIOS also
>> has the issue I would recommend taking this feedback to whoever provided
>> the BIOS for your platform so that they can implement the fix.
>>
>> If I am not mistaken some BIOSes have the option to disable DCA and/or
>> IOATDMA.  You might want to check yours to see if you can just disable
>> DCA on your platform until the issue can be resolved.
> 
> Disabling DCA is the preferred option. IOATDMA is functional without
> DCA.
> 
> Jet,
> What exactly are you attempting to test with IOATDMA? The only two
> consumers of this DMA driver I know of are MDRAID and NTB. But support
> for XOR/PQ ops on Xeon platforms have been removed due to various
> reasons recently so it really is just NTB at the moment in the latest
> kernels. 

We are running LKP to test kernel boot and performance. More information you can find at https://01.org/lkp/
This issue shows up in our boot testing with certain kconfig and impacts many of our test machines. It is difficult to update BIOS for all test boxes. Besides, we still not make sure every test box model have a workable version of BIOS. We will consider disabling DCA as your suggestion.

Thanks,
Jet

> 
>> Thanks,
>>
>> Alex
>>
