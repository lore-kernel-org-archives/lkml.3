Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3HERku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:40:50 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35515 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3HERks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:40:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130805171142.GA6978@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
	<CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
	<20130805132948.GA14942@redhat.com>
	<CAMP44s0iXYjNuSqtCCjBHbbmmrYsKcrRBmD_W_nEiWTxPX1+xQ@mail.gmail.com>
	<20130805143935.GA18100@redhat.com>
	<CAMP44s0Q5fCcAwjPWaiz8uVE+BAnQ=YOBxtqNXR6XT1KBApFng@mail.gmail.com>
	<20130805171142.GA6978@redhat.com>
Date: Mon, 5 Aug 2013 12:40:46 -0500
Message-ID: <CAMP44s26f-AFWyxgWEyF50N6wntwT-UDHS4ZdSnZbagj+Rai7g@mail.gmail.com>
Subject: Re: Linux 3.11-rc4
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 12:11 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/05, Felipe Contreras wrote:
>>
>> On Mon, Aug 5, 2013 at 9:39 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > Hmm. It should not crash under strace... please see below.
>> >
>> >> 953   ptrace(PTRACE_ATTACH, 1035, 0, 0) = -1 EPERM (Operation not permitted)
>> >
>> > OK, so it actually uses ptrace ;)
>> >
>> > PTRACE_ATTACH fails because this child is already traced by strace, I guess.
>> >
>> > So does Starcraft crash this way? Or does it fail in some other way?
>>
>> It's crashing just the same.
>
> But then it is not clear how fab840f can make any difference.

Yeah, it's very strange.

> wine can not use ptrace when it runs after "strace -f". But, to remind,
> I know nothing about wine. Perhaps wine uses some daemons which actually
> run/ptrace the workload?

There's this thing called wineserver, I'm not exactly sure how it would affect.

But I found this:

http://askubuntu.com/questions/146160/what-is-the-ptrace-scope-workaround-for-wine-programs-and-are-there-any-risks

Would it be possible to just revert that patch for v3.11, and fix it later?

-- 
Felipe Contreras
