Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaHMIMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:12:03 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:61155 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaHMIL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:11:57 -0400
Message-ID: <53EB1EE0.20002@gmail.com>
Date: Wed, 13 Aug 2014 16:16:32 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Salter <msalter@redhat.com>,
        "a-jacquiot@ti.com" <a-jacquiot@ti.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-c6x-dev@linux-c6x.org,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH v2] arch: Kconfig: Let all little endian architectures
 define CPU_LITTLE_ENDIAN explicitly
References: <53EA99C3.90203@gmail.com> <CAMuHMdV_2b-A+eE--cXEFA68=72HK6mqx8+TCXRMVkyhESLYxQ@mail.gmail.com>
In-Reply-To: <CAMuHMdV_2b-A+eE--cXEFA68=72HK6mqx8+TCXRMVkyhESLYxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 8/13/14 16:03, Geert Uytterhoeven wrote:
> CC kbuild
> 
> On Wed, Aug 13, 2014 at 12:48 AM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index c49a775..0510a5d 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -199,6 +199,11 @@ config NEED_DMA_MAP_STATE
>>  config ARCH_SUPPORTS_UPROBES
>>         def_bool y
>>
>> +config CPU_LITTLE_ENDIAN
>> +       depends on !CPU_BIG_ENDIAN
>> +       def_bool y
>> +
>> +
>>  config ARCH_HAS_DMA_SET_COHERENT_MASK
>>         bool
> 
> As this is a common symbol, and replicated for all affected architectures,
> I'm wondering if we should have the "config CPU_LITTLE_ENDIAN" in
> common Kconfig code instead, and make the individual architectures do a
> "select CPU_LITTLE_ENDIAN"?
> 

That sounds a good idea to me.

> Also we could have "config CPU_BIG_ENDIAN", too, and error out
> if none or both are selected (can Kconfig error out?).
> 

It is a good idea to me, welcome any members ideas, especially Kbuild
members' ideas, suggestions or completions.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
