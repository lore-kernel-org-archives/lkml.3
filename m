Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaGHBn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:43:26 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:9625 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751077AbaGHBnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 21:43:25 -0400
X-IronPort-AV: E=Sophos;i="5.00,853,1396972800"; 
   d="scan'208";a="32967854"
Message-ID: <53BB4CF3.2010908@cn.fujitsu.com>
Date: Tue, 8 Jul 2014 09:44:19 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: Gleb Natapov <gleb@kernel.org>, <mtosatti@redhat.com>,
        <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] kvm, mem-hotplug: Update apic access page when it
 is migrated.
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com> <1404291637-15048-5-git-send-email-tangchen@cn.fujitsu.com> <20140703135507.GM18167@minantech.com> <53B60EF1.6030307@cn.fujitsu.com> <20140704101310.GE4399@minantech.com> <53BA6DD3.9040400@cn.fujitsu.com> <53BA87A3.5020205@gmail.com> <20140707115446.GP18167@minantech.com> <53BA8E2F.9000200@gmail.com>
In-Reply-To: <53BA8E2F.9000200@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nadav,

Thanks for the reply, please see below.

On 07/07/2014 08:10 PM, Nadav Amit wrote:
> On 7/7/14, 2:54 PM, Gleb Natapov wrote:
>> On Mon, Jul 07, 2014 at 02:42:27PM +0300, Nadav Amit wrote:
>>> Tang,
>>>
>>> Running some (unrelated) tests I see that KVM does not handle APIC base
>>> relocation correctly. When the base is changed, kvm_lapic_set_base just
>>> changes lapic->base_address without taking further action (i.e.,
>>> modifying
>>> the VMCS apic address in VMX).
>>>
>>> This patch follows KVM bad behavior by using the constant
>>> VMX_APIC_ACCESS_PAGE_ADDR instead of lapic->base_address.
>> There is no OS out there that relocates APIC base (in fact it was not
>> always
>> relocatable on real HW), so there is not point in complicating the
>> code to support
>> it. In fact current APIC_ACCESS_ADDR handling relies on the fact that
>> all vcpus
>> has apic mapped at the same address.
>>
>>>
>>> Anyhow, I didn't see anything that would make my life (in fixing the
>>> lapic
>>> base issue) too difficult. Yet, feel free in making it more
>>> "fix-friendly".
>>>
>> Why would you want to fix it?
>>
> If there is no general need, I will not send a fix. However, I think the
> very least a warning message should be appear if the guest relocates the
> APIC base.

Maybe I didn't understand you question correctly. If I'm wrong, please 
tell me.

This patch does not relocate APIC base in guest, but in host. Host migrates
the apic page to somewhere else, and KVM updates ept pagetable to track it.
In guest, apic base address (gpa) doesn't change.

Is this lapic->base_address a hpa ?

Is there anywhere I need to update in my patch ?

Thanks.

