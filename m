Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbaGDAQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 20:16:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44594 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaGDAQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 20:16:05 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53B5F201.5070804@jp.fujitsu.com>
Date: Fri, 4 Jul 2014 09:14:57 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <toshi.kani@hp.com>, <imammedo@redhat.com>,
        <huawei.libin@huawei.com>, <paul.gortmaker@windriver.com>,
        <linux-kernel@vger.kernel.org>, <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86,cpu-hotplug: clear llc_shared_mask at CPU hotplug
References: <53B3A991.2070502@jp.fujitsu.com> <20140702113253.GD1318@pd.tnic> <53B4E1A4.2050502@jp.fujitsu.com> <20140703095135.GA21776@pd.tnic>
In-Reply-To: <20140703095135.GA21776@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/03 18:51), Borislav Petkov wrote:
> On Thu, Jul 03, 2014 at 01:52:52PM +0900, Yasuaki Ishimatsu wrote:
>> I think that the reason to apply CPU number to ACPI ID is that CPU is
>> used for the application without considering physical CPU. So even if
>> CPU number is changed, it is no matter.
>
> I don't think I understand what you're saying here...
>
>> Thus the readded cores is numbered to unused CPU number.
>
> Well, maybe we should use some method to number cores in a stable manner
> so that they don't get new numbers when they reappear.
>
>> I think the mask has 2 meanings as follows:
>>    - representing CPUs that share same CPU cache.
>
> ... that share the last level cache.
>
>>    - representing onlined CPUs
>
> no, for that we have cpu_online_mask.
>

>> So even if we keep their old numbers, we should clear the mask when
>> offlinig CPU.
>
> No, cpu_online_mask is for onlined cores. I think the mask which shows
> which cores share a last level cache should not be changed *IF* the core
> numbers remain stable, that is.

If so, why following maps are cleared by CPU offline?
   - cpu_sigling_map
   - cpu_core_map

I think the masks are used by cpumask_weight(). So they must be cleared
at CPU offline. And currently llc_shared_map is not used by cpumask_weight().
So even if we don't clear the mask, there is no problem. But llc_shared_map
will be used by cpumask_weight(). In this case, some problem will occur and
we will spent time the investigation of the problem.

So even if we keep CPU number, the mask should be cleared at CPU offline.

Thanks,
Yasuaki Ishimatsu


