Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab3FLSPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:15:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40757 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab3FLSPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:15:07 -0400
Message-ID: <51B8BA92.2090801@zytor.com>
Date: Wed, 12 Jun 2013 11:14:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] x86, relocs: move ELF relocation handling to C
References: <20130611185846.GA23707@www.outflux.net> <CAE9FiQXgO+yScU2cBazJtX2mFHRMv=wObrTjpFvW5ajFNjBvCA@mail.gmail.com>
In-Reply-To: <CAE9FiQXgO+yScU2cBazJtX2mFHRMv=wObrTjpFvW5ajFNjBvCA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 11:13 AM, Yinghai Lu wrote:
> 
> it seems those lines for x86_64 are never used.
> as X86_NEED_RELOCS is not defined for x86_64
> 
>>  config X86_NEED_RELOCS
>>         def_bool y
>>         depends on X86_32 && RELOCATABLE
> 
> 
>> +}
>> +#else
>> +static inline void handle_relocations(void *output, unsigned long output_len)
>> +{ }
>> +#endif
> 
> Can you make it clear that this patch only affect x86_32 in patch title?
> 

I am not sure this belongs in the patch title, as it is preparatory work
for x86-64.  It should be mentioned in the patch description body, though.

	-hpa


