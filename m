Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaA0ONk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:13:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:30120 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbaA0ONi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:13:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,729,1384329600"; 
   d="scan'208";a="473099344"
Message-ID: <52E669F1.9080603@intel.com>
Date: Mon, 27 Jan 2014 16:15:13 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Kees Cook <keescook@chromium.org>, crash-utility@redhat.com,
        linux-kernel@vger.kernel.org, Dave Anderson <anderson@redhat.com>,
        Andrew Honig <ahonig@google.com>,
        Eugene Surovegin <surovegin@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] x86, kaslr: export offset in VMCOREINFO ELF notes
References: <20140123173120.GA25474@www.outflux.net> <20140125074738.GB10565@gmail.com>
In-Reply-To: <20140125074738.GB10565@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/01/14 09:47, Ingo Molnar wrote:
> 
> * Kees Cook <keescook@chromium.org> wrote:
> 
>> From: Eugene Surovegin <surovegin@google.com>
>>
>> Include kASLR offset in VMCOREINFO ELF notes to assist in debugging.
>>
>> Signed-off-by: Eugene Surovegin <surovegin@google.com>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> v2:
>>  - make sure "From:" got sent correctly
>> ---
>>  arch/x86/kernel/machine_kexec_64.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
>> index 4eabc160696f..679cef0791cd 100644
>> --- a/arch/x86/kernel/machine_kexec_64.c
>> +++ b/arch/x86/kernel/machine_kexec_64.c
>> @@ -279,5 +279,7 @@ void arch_crash_save_vmcoreinfo(void)
>>  	VMCOREINFO_SYMBOL(node_data);
>>  	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
>>  #endif
>> +	vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
>> +			      (unsigned long)&_text - __START_KERNEL);
>>  }
> 
> I've Cc:-ed Adrian Hunter, who has sent the following kaslr fixes for 
> perf yesterday:
> 
>   http://lkml.org/lkml/2014/1/24/220
> 
> Adrian, is this patch the right solution from the perf tooling 
> perspective?

perf tools isn't a consumer of VMCOREINFO although I see VMCOREINFO already
has _stext which would be enough for many purposes.

> 
> Thanks,
> 
> 	Ingo
> 
> 

