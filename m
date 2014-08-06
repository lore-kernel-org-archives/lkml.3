Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaHFPIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:08:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaHFPIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:08:04 -0400
Message-ID: <53E244C8.1030309@redhat.com>
Date: Wed, 06 Aug 2014 17:07:52 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 0/8] x86: entry_64.S: always allocate complete "struct
 pt_regs"
References: <1407250354-29525-1-git-send-email-dvlasenk@redhat.com> <53E13AD9.5080908@zytor.com>
In-Reply-To: <53E13AD9.5080908@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 10:13 PM, H. Peter Anvin wrote:
> On 08/05/2014 07:52 AM, Denys Vlasenko wrote:
>> Version 3 of the patchset.
>>
>> Please consider applying at least two first patches, they are definitely safe,
>> and the second one fixes a latent bug.
>>
> 
> Please do provide latency measurements.  I highly suspect that they will
> turn out that that this has no significant impact on latency, but we
> need to know for sure.

I ran tests in totally quiescent state (booted in /bin/sh)
on dual Core i7:

vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz
stepping	: 7
microcode	: 0x29


"timing_test32 20 getpid" command, best time:
old kernel 266.88 ns per getpid syscall
new kernel 265.95 ns per getpid syscall

"timing_test64 20 getpid" command, best time:
old kernel 54.12 ns per getpid syscall
new kernel 54.30 ns per getpid syscall

In both cases, run-to-run test variability is about 2 ns.
