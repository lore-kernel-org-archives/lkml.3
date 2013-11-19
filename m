Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab3KSTSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:18:11 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:58362 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3KSTSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:18:08 -0500
MIME-Version: 1.0
In-Reply-To: <20131119190904.GA22076@gmail.com>
References: <20131119154253.GA12219@gmail.com>
	<CA+55aFzyBxFi8_4C4hAz6+SAgtHCmQtpxSyJhRyWzggoRGTD5w@mail.gmail.com>
	<20131119190904.GA22076@gmail.com>
Date: Tue, 19 Nov 2013 11:18:07 -0800
X-Google-Sender-Auth: GEYqxVfyowb_qaZvFfRnCztJXD0
Message-ID: <CA+55aFymaQj3ods2ahxj6xv03wL0gtEejWX6T94yGaxEGquSFA@mail.gmail.com>
Subject: Re: [GIT PULL] core kernel update
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Josh Boyer <jwboyer@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 11:09 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> As you pointed out offstack is definitely nonsensical for
> NR_CPUS <= 64. (on 64-bit CPUs) On-stack is known to crash with
> NR_CPUS >= 1024.
>
> The 128..512 CPUs range is somewhat of an unknown.

Agreed. And we could even decide to ask somewhere in that range.

I think 128 bits is still safely "don't bother with an external
pointer" (it's just two words, it's like a "struct list_head" -
there's no way that should be unsafe on the stack). Once we get to 256
bits I start going "Hmm, that's 32 bytes, maybe an external allocation
makes sense..."

I'd personally put the cut-off point at just keeping it on-stack if
it's smaller than or equal to 256. But I agree that at that point it's
really just a judgement call.

             Linus
