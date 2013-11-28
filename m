Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab3K1CBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:01:15 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:43565 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3K1CBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:01:14 -0500
MIME-Version: 1.0
In-Reply-To: <52968018.5090907@zytor.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
	<5294F10C.8060901@amacapital.net>
	<CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com>
	<52964EC7.9000504@zytor.com>
	<52966C0A.7070201@zytor.com>
	<CA+55aFzr9ZKcGfT_Q31T9_vuCcmWxGCh0wixuZqt7VhjxxYU9g@mail.gmail.com>
	<529677D7.9080203@zytor.com>
	<CA+55aFx9mXy3VASfek5052GTbiUVSgBVsRwnF4cse1dc=z70HQ@mail.gmail.com>
	<52968018.5090907@zytor.com>
Date: Wed, 27 Nov 2013 18:01:13 -0800
X-Google-Sender-Auth: E6vnYCeOh-y7ds0TVQTccy04vaQ
Message-ID: <CA+55aFw2RANS0j5zjfKhbejYpoLe5Z9VnPudb+AouzA242LJJg@mail.gmail.com>
Subject: Re: [PATCH] Add a text_poke syscall v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 3:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> The timeout bit was an acknowledgment that some kind of batching
> interface is necessary.

That's just moronic. People would make up totally random timeouts, so
from an interface standpoint it's just horrid, horrid.

Giving user space random knobs that you don't understand yourself, and
the monkeys in user space are guaranteed to mis-use is just entirely
the wrong thing to do.

Much better to then just making the interface itself be about
batching, which isn't as hard as you make it out to be. Make it an
array of those addr/replace/len things. And we have that
"restart_block" for system calls, and we'd limit batching to some
random smallish number ("128 instructions, just because"), while still
being easily interruptible in between those blocks. That limits you to
two IPI's per 128 instructions replaced - and at that point even
*that* is just an internal kernel random tuning thing, not some insane
user interface.

But is such batching really even worth it? If' it's not *that* much
more effort, maybe it's worth it, but do we have known users that
really would have thousands and thousands of cases all at once?

            Linus
