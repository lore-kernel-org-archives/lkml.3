Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab3DXXbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:31:08 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:46133 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab3DXXbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:31:06 -0400
MIME-Version: 1.0
In-Reply-To: <5178657E.9020905@zytor.com>
References: <CA+55aFwpLu0qNms=hkQr43yqD0K9DgESNm91OEWKT1ZuT8MU6Q@mail.gmail.com>
	<20130424072630.GB1780@gmail.com>
	<20130424170702.GA1867@redhat.com>
	<CAFTL4hzmW43o8dxW0_E7F00a+PT+T4=F4h=gdCxHvcZhMiH3-w@mail.gmail.com>
	<5178657E.9020905@zytor.com>
Date: Thu, 25 Apr 2013 01:31:03 +0200
Message-ID: <CAFTL4hyCQ1DGg5JOmWgvZoC9kcrV6TmodCw=TCFcr+QXMwv9yQ@mail.gmail.com>
Subject: Re: [PATCH] x86: make DR*_RESERVED unsigned long
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/25 H. Peter Anvin <hpa@zytor.com>:
> On 04/24/2013 03:48 PM, Frederic Weisbecker wrote:
>> You told in an earlier email that intel manual says upper 32 bits of
>> dr6 are reserved.
>> In this case don't we need to expand the mask in 64 bits like is done
>> for DR_CONTROL_RESERVED?
>>
>
> Arguably this would be a *good* use for ~ ...
>
> Instead of defining separate bitmasks for 32 and 64 bits have the
> reciprocal (non-reserved bits):
>
> #define DR6_RESERVED (~0x0000F00FUL)
>
> That does have the right value on both 32 and 64 bits.  The leading
> zeroes aren't even really needed.

Ah, looks better indeed.

>
> Now, DR6 is a bit special in that a bunch of the reserved bits are
> hardwired to 1, not 0; I don't know offhand if that is true for bits
> [63:32].

Hmm, good point, could it be a problem given that we clear the
reserved dr6 bits on do_trap() and write that 'cleaned up" value back
to "tsk->thread.debugreg6"? Probably not if those hardwired reserved
bits are set to "1" on dr6 physical write whether those bits are
cleared or not in their storage in thread struct before resuming the
task?
