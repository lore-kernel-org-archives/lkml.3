Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaGGLmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 07:42:35 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:35537 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaGGLmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 07:42:33 -0400
Message-ID: <53BA87A3.5020205@gmail.com>
Date: Mon, 07 Jul 2014 14:42:27 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, Gleb Natapov <gleb@kernel.org>
CC: mtosatti@redhat.com, kvm@vger.kernel.org, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kvm, mem-hotplug: Update apic access page when it
 is migrated.
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com> <1404291637-15048-5-git-send-email-tangchen@cn.fujitsu.com> <20140703135507.GM18167@minantech.com> <53B60EF1.6030307@cn.fujitsu.com> <20140704101310.GE4399@minantech.com> <53BA6DD3.9040400@cn.fujitsu.com>
In-Reply-To: <53BA6DD3.9040400@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tang,

Running some (unrelated) tests I see that KVM does not handle APIC base 
relocation correctly. When the base is changed, kvm_lapic_set_base just 
changes lapic->base_address without taking further action (i.e., 
modifying the VMCS apic address in VMX).

This patch follows KVM bad behavior by using the constant 
VMX_APIC_ACCESS_PAGE_ADDR instead of lapic->base_address.

Anyhow, I didn't see anything that would make my life (in fixing the 
lapic base issue) too difficult. Yet, feel free in making it more 
"fix-friendly".

Thanks,
Nadav

On 7/7/14, 12:52 PM, Tang Chen wrote:
> Hi Gleb,
>
> The guest hang problem has been solved.
>
> When mmu_notifier is called, I set VMCS APIC_ACCESS_ADDR to the new value
> instead of setting it to 0. And only update kvm->arch.apic_access_page in
> the next ept violation.
>
> The guest is running well now.
>
> I'll post the new patches tomorrow. ;)
>
> Thanks.
>
