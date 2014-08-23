Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaHWC0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 22:26:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36556 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaHWC02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 22:26:28 -0400
Message-ID: <53F7FCF3.4000800@gmail.com>
Date: Sat, 23 Aug 2014 10:31:15 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, Geert Uytterhoeven <geert@linux-m68k.org>
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
References: <53EA99C3.90203@gmail.com> <CAMuHMdV_2b-A+eE--cXEFA68=72HK6mqx8+TCXRMVkyhESLYxQ@mail.gmail.com> <53F724DD.1080605@suse.cz>
In-Reply-To: <53F724DD.1080605@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/14 19:09, Michal Marek wrote:
> Dne 13.8.2014 10:03, Geert Uytterhoeven napsal(a):
>> CC kbuild
>>
>> On Wed, Aug 13, 2014 at 12:48 AM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>>> index c49a775..0510a5d 100644
>>> --- a/arch/arm/Kconfig
>>> +++ b/arch/arm/Kconfig
>>> @@ -199,6 +199,11 @@ config NEED_DMA_MAP_STATE
>>>  config ARCH_SUPPORTS_UPROBES
>>>         def_bool y
>>>
>>> +config CPU_LITTLE_ENDIAN
>>> +       depends on !CPU_BIG_ENDIAN
>>> +       def_bool y
>>> +
>>> +
>>>  config ARCH_HAS_DMA_SET_COHERENT_MASK
>>>         bool
>>
>> As this is a common symbol, and replicated for all affected architectures,
>> I'm wondering if we should have the "config CPU_LITTLE_ENDIAN" in
>> common Kconfig code instead, and make the individual architectures do a
>> "select CPU_LITTLE_ENDIAN"?
> 
> Yes!
> 
> 
>> Also we could have "config CPU_BIG_ENDIAN", too, and error out
>> if none or both are selected (can Kconfig error out?).
> 
> We can error out in the Makefile, if there is consensus that we should
> be doing so.
> 

OK, thanks. I have sent patch v3 for it, and did not check related error
in Kconfig files.

Please check the related patches (excuse me, I send the patch v3 only
according to "scripts/maintainers.pl", maybe not cc to you explicitly).


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
