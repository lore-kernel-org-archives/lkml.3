Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3HERCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:02:20 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:48345 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3HERCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:02:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130805143935.GA18100@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
	<CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
	<20130805132948.GA14942@redhat.com>
	<CAMP44s0iXYjNuSqtCCjBHbbmmrYsKcrRBmD_W_nEiWTxPX1+xQ@mail.gmail.com>
	<20130805143935.GA18100@redhat.com>
Date: Mon, 5 Aug 2013 12:02:14 -0500
Message-ID: <CAMP44s0Q5fCcAwjPWaiz8uVE+BAnQ=YOBxtqNXR6XT1KBApFng@mail.gmail.com>
Subject: Re: Linux 3.11-rc4
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 9:39 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/05, Felipe Contreras wrote:
>>
>> On Mon, Aug 5, 2013 at 8:29 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > Could you please run wine under strace
>> >
>> >         strace -f -e ptrace -o LOG wine ...
>> >
>> > and show the result?
>>
>> Sure.
>
> Thanks.
>
>> Note that the crash might have happened some time before the end
>> of the log.
>
> Hmm. It should not crash under strace... please see below.
>
>> 953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
>
> OK, so it actually uses ptrace ;)
>
> PTRACE_ATTACH fails because this child is already traced by strace, I guess.
>
> So does Starcraft crash this way? Or does it fail in some other way?

It's crashing just the same.

> And just in case... perhaps wine does some logging too?

Yeah, but there doesn't seem to be anything interesting:

http://bugs.winehq.org/attachment.cgi?id=45489

-- 
Felipe Contreras
