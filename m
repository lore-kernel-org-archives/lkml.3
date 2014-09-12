Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaILDfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:35:24 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:14256 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751295AbaILDfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:35:23 -0400
X-IronPort-AV: E=Sophos;i="5.04,509,1406563200"; 
   d="scan'208";a="35851253"
Message-ID: <54126A4D.4010903@cn.fujitsu.com>
Date: Fri, 12 Sep 2014 11:36:45 +0800
From: tangchen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
CC: <mtosatti@redhat.com>, <nadav.amit@gmail.com>, <jan.kiszka@web.de>,
        <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v5 4/7] kvm, mem-hotplug: Reload L1' apic access page
 on migration in vcpu_enter_guest().
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com> <1410413886-32213-5-git-send-email-tangchen@cn.fujitsu.com> <541169AD.6060908@redhat.com> <20140911101200.GF25317@minantech.com> <54117DB4.307@redhat.com> <20140911113051.GG25317@minantech.com> <54119E01.9000908@redhat.com> <20140911135956.GC26540@minantech.com> <5411AC82.4080005@redhat.com> <20140911142121.GD26540@minantech.com> <5411B084.7030800@redhat.com>
In-Reply-To: <5411B084.7030800@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,

On 09/11/2014 10:24 PM, Paolo Bonzini wrote:
> Il 11/09/2014 16:21, Gleb Natapov ha scritto:
>> As far as I can tell the if that is needed there is:
>>
>> if (!is_guest_mode() || !(vmcs12->secondary_vm_exec_control & ECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
>>      write(PIC_ACCESS_ADDR)
>>
>> In other words if L2 shares L1 apic access page then reload, otherwise do nothing.
> What if the page being swapped out is L1's APIC access page?  We don't
> run prepare_vmcs12 in that case because it's an L2->L0->L2 entry, so we
> need to "do something".

Are you talking about the case that L1 and L2 have different apic pages ?
I think I didn't deal with this situation in this patch set.

Sorry I didn't say it clearly. Here, I assume L1 and L2 share the same 
apic page.
If we are in L2, and the page is migrated, we updated L2's vmcs by 
making vcpu
request. And of course, we should also update L1's vmcs. This is done by 
patch 5.
We make vcpu request again in nested_vmx_exit().

Thanks.
