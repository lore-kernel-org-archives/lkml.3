Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab3DWRcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:32:33 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43907 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab3DWRcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:32:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAEDV+gKEf5-uau8WxxuMk0+p0N5ba2AMKj8-O6kbZv1OiWDVpQ@mail.gmail.com>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
	<1366734653-488286-5-git-send-email-arnd@arndb.de>
	<CAEDV+gKEf5-uau8WxxuMk0+p0N5ba2AMKj8-O6kbZv1OiWDVpQ@mail.gmail.com>
Date: Tue, 23 Apr 2013 10:32:31 -0700
X-Google-Sender-Auth: IFrU87tiVXUHYFyfdd8in4ZVbsI
Message-ID: <CAEDV+gKsdEKzbq3f-hSBK7bFdFRvuqYfcfU9Rs27hpyykxjoPw@mail.gmail.com>
Subject: Re: [PATCH 04/21] ARM: kvm: define KVM_ARM_MAX_VCPUS unconditionally
From: Christoffer Dall <cdall@cs.columbia.edu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 10:29 AM, Christoffer Dall
<cdall@cs.columbia.edu> wrote:
> On Tue, Apr 23, 2013 at 9:30 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> The CONFIG_KVM_ARM_MAX_VCPUS symbol is needed in order to build the
>> kernel/context_tracking.c code, which includes the vgic data structures
>> implictly through the kvm headers. Definining the symbol to zero
>> on builds without KVM resolves this build error:
>>
>> In file included from include/linux/kvm_host.h:33:0,
>>                  from kernel/context_tracking.c:18:
>> arch/arm/include/asm/kvm_host.h:28:23: warning: "CONFIG_KVM_ARM_MAX_VCPUS" is not defined [-Wundef]
>>  #define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
>>                        ^
>> arch/arm/include/asm/kvm_vgic.h:34:24: note: in expansion of macro 'KVM_MAX_VCPUS'
>>  #define VGIC_MAX_CPUS  KVM_MAX_VCPUS
>>                         ^
>> arch/arm/include/asm/kvm_vgic.h:38:6: note: in expansion of macro 'VGIC_MAX_CPUS'
>>  #if (VGIC_MAX_CPUS > 8)
>>       ^
>> In file included from arch/arm/include/asm/kvm_host.h:41:0,
>>                  from include/linux/kvm_host.h:33,
>>                  from kernel/context_tracking.c:18:
>> arch/arm/include/asm/kvm_vgic.h:59:11: error: 'CONFIG_KVM_ARM_MAX_VCPUS' undeclared here (not in a function)
>>   } percpu[VGIC_MAX_CPUS];
>>            ^
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <cdall@cs.columbia.edu>
>> Cc: Will Deacon <will.deacon@arm.com>
>> ---
>>  arch/arm/kvm/Kconfig | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
>> index 49dd64e..370e1a8 100644
>> --- a/arch/arm/kvm/Kconfig
>> +++ b/arch/arm/kvm/Kconfig
>> @@ -41,9 +41,9 @@ config KVM_ARM_HOST
>>           Provides host support for ARM processors.
>>
>>  config KVM_ARM_MAX_VCPUS
>> -       int "Number maximum supported virtual CPUs per VM"
>> -       depends on KVM_ARM_HOST
>> -       default 4
>> +       int "Number maximum supported virtual CPUs per VM" if KVM_ARM_HOST
>> +       default 4 if KVM_ARM_HOST
>> +       default 0
>>         help
>>           Static number of max supported virtual CPUs per VM.
>>
>> --
>> 1.8.1.2
>>
>
> Acked-by: Christoffer Dall <cdall@cs.columbia.edu>

actually let me just pull that into my tree. thanks.
