Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaKWIYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 03:24:37 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53362 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaKWIYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 03:24:36 -0500
Message-ID: <547199B3.1040303@gmail.com>
Date: Sun, 23 Nov 2014 16:24:19 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [CFT PATCH 0/2] KVM: support XSAVES usage in the host
References: <1416594678-13011-1-git-send-email-pbonzini@redhat.com> <DE9192FA-6A22-4AEB-88C2-AE17DA503685@gmail.com>
In-Reply-To: <DE9192FA-6A22-4AEB-88C2-AE17DA503685@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nadav,
On 11/23/14, 4:16 PM, Nadav Amit wrote:
> I’ll try to check it tomorrow (I don’t have access to the failing machine at the moment).

If the machine you mentioned support xsaves and what's machine you are 
using?

Regards,
Wanpeng Li

>
> Thanks for the quick response.
>
> Nadav
>
>> On Nov 21, 2014, at 20:31, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> The first patch ensures that XSAVES is not exposed in the guest until
>> we emulate MSR_IA32_XSS.  The second exports XSAVE data in the correct
>> format.
>>
>> I tested these on a non-XSAVES system so they should not be completely
>> broken, but I need some help.  I am not even sure which XSAVE states
>> are _not_ enabled, and thus compacted, in Linux.
>>
>> Note that these patches do not add support for XSAVES in the guest yet,
>> since MSR_IA32_XSS is not emulated.
>>
>> If they fix the bug Nadav reported, I'll add Reported-by and commit.
>>
>> Thanks,
>>
>> Paolo
>>
>> Paolo Bonzini (2):
>>   kvm: x86: mask out XSAVES
>>   KVM: x86: support XSAVES usage in the host
>>
>> arch/x86/kvm/cpuid.c | 11 ++++++++++-
>> arch/x86/kvm/x86.c   | 48 +++++++++++++++++++++++++++++++++++++++++++-----
>> 2 files changed, 53 insertions(+), 6 deletions(-)
>>
>> -- 
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

