Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab3K1CLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:11:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55021 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370Ab3K1CLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:11:04 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFw2RANS0j5zjfKhbejYpoLe5Z9VnPudb+AouzA242LJJg@mail.gmail.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <5294F10C.8060901@amacapital.net> <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com> <52964EC7.9000504@zytor.com> <52966C0A.7070201@zytor.com> <CA+55aFzr9ZKcGfT_Q31T9_vuCcmWxGCh0wixuZqt7VhjxxYU9g@mail.gmail.com> <529677D7.9080203@zytor.com> <CA+55aFx9mXy3VASfek5052GTbiUVSgBVsRwnF4cse1dc=z70HQ@mail.gmail.com> <52968018.5090907@zytor.com> <CA+55aFw2RANS0j5zjfKhbejYpoLe5Z9VnPudb+AouzA242LJJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Add a text_poke syscall v2
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 27 Nov 2013 18:10:22 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <90b60466-2d5e-4df3-952b-052259c04e37@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftrace is the flagship example.

And yes, agreed about timeouts.

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>On Wed, Nov 27, 2013 at 3:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> The timeout bit was an acknowledgment that some kind of batching
>> interface is necessary.
>
>That's just moronic. People would make up totally random timeouts, so
>from an interface standpoint it's just horrid, horrid.
>
>Giving user space random knobs that you don't understand yourself, and
>the monkeys in user space are guaranteed to mis-use is just entirely
>the wrong thing to do.
>
>Much better to then just making the interface itself be about
>batching, which isn't as hard as you make it out to be. Make it an
>array of those addr/replace/len things. And we have that
>"restart_block" for system calls, and we'd limit batching to some
>random smallish number ("128 instructions, just because"), while still
>being easily interruptible in between those blocks. That limits you to
>two IPI's per 128 instructions replaced - and at that point even
>*that* is just an internal kernel random tuning thing, not some insane
>user interface.
>
>But is such batching really even worth it? If' it's not *that* much
>more effort, maybe it's worth it, but do we have known users that
>really would have thousands and thousands of cases all at once?
>
>            Linus

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
