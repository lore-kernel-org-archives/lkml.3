Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295Ab3JPRO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:14:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60711 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760726Ab3JPRO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:14:26 -0400
Message-ID: <525EC929.5030001@zytor.com>
Date: Wed, 16 Oct 2013 10:13:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] x86-64: properly handle FPU code/data selectors
References: <525E9BFF02000078000FB74E@nat28.tlf.novell.com> <525EB320.2000607@zytor.com> <525ED5F602000078000FB948@nat28.tlf.novell.com>
In-Reply-To: <525ED5F602000078000FB948@nat28.tlf.novell.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 09:07 AM, Jan Beulich wrote:
> 
>> Furthermore, you define X86_FEATURE_NO_FPU_SEL, but you don't set it
>> anywhere.  At least that bit needs to be factored out into a separate patch.
> 
> That's already being done in get_cpu_cap(), as it's part of
> x86_capability[9].
> 

Ah, sorry, my bad.  For some reason I thought you added it to word 3,
but this is a hardware-provided CPUID bit.  I, if anyone, should have
known :)

>> +	if (config_enabled(CONFIG_IA32_EMULATION) &&
>> +	    test_tsk_thread_flag(tsk, TIF_IA32))
>>
>> is_ia32_task()?
> 
> That'd imply that "tsk == current" in all cases, which I don't
> think is right here.

True.  It wold be good to have an equivalent predicate function for
another task, though.

This assumes the process doesn't switch modes on us, which it is allowed
to do.  For that it really would be better to look at the CS.L bit,
which can be done with the LAR instruction for the current task;
otherwise we'd have to walk the descriptor tables.

	-hpa

