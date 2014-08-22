Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaHVLJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 07:09:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbaHVLJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 07:09:23 -0400
Message-ID: <53F724DD.1080605@suse.cz>
Date: Fri, 22 Aug 2014 13:09:17 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Chen Gang <gang.chen.5i5j@gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 13.8.2014 10:03, Geert Uytterhoeven napsal(a):
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

Yes!


> Also we could have "config CPU_BIG_ENDIAN", too, and error out
> if none or both are selected (can Kconfig error out?).

We can error out in the Makefile, if there is consensus that we should
be doing so.

Michal
