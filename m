Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab3AZVJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 16:09:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54723 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab3AZVJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 16:09:43 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFyskO6NMhgkwRNv4wXB=D97VS54_oZw0k_o4nQFso6p-Q@mail.gmail.com>
References: <1359123061-6139-1-git-send-email-ling.ma@alipay.com> <tip-d94ffd677469ef729e9d6e968191872577a6119e@git.kernel.org> <20130126125208.GC21395@pd.tnic> <8b0dfc4a-6f9c-498a-9844-4d99deb3052f@email.android.com> <CA+55aFyskO6NMhgkwRNv4wXB=D97VS54_oZw0k_o4nQFso6p-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/asm] x86/defconfig: Turn on CONFIG_CC_OPTIMIZE_FOR_SIZE= y in the 64-bit defconfig
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 26 Jan 2013 13:08:02 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jan Beulich <jbeulich@suse.com>, ling.ml@alipay.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Message-ID: <36b9ae37-2bf7-4ce7-a41c-9d533ac7ef94@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fast rep movsb was introduced on Ivy Bridge, IIRC.

Linus Torvalds <torvalds@linux-foundation.org> wrote:

>On Sat, Jan 26, 2013 at 7:18 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On the CPUs Ling is testing on the downsides of -Os probably matter
>less, in particular since rep movsb works well.
>>
>> It is questionable as a generic default, though.
>
>So being the person who really pushed for -Os to begin with (I think
>I$ and instruction decode bandwidth is one of the most fundamental
>limits to CPU performance), I wouldn't mind it if we reintroduced it.
>
>HOWEVER.
>
>It wasn't just "rep movs". The thing that killed -Os for me was that
>it makes it impossible to try to optimize hot code, because -Os seems
>to throw out branch prediction information. So when you use "likely()"
>etc to try to teach the compiler to lay out code a certain way so that
>code that never really gets executed isn't even brought into the I$,
>-Os then screws it up completely.
>
>Of course, maybe newer versions of gcc might not suck so horribly with
>-Os, I haven't actually tried in a while.
>
>[ Just tested. Still does it ]
>
>Also, I doubt Ling was testing a SB CPU. Because "rep movb" still
>sucks pretty bad on SB. What core *is* Ling testing? Haswell?
>
>Ugh. We could make it depend on the optimization target. I'd also wish
>there was some way to just tune gcc -Os to be closer to reasonable. Or
>make -O2 not do some of the excessive crap it does (it aligns code
>*much* too much, for example - who cares if you can do it with a
>single instruction, if that instruction is so long that it uses up
>half your decode bandwidth?)
>
>The problem, of course, is that most -O2 code generation is done
>assuming hot loops that don't show much if any I$ issues. And the -Os
>thing is done *purely* for size, not taking any performance into
>account at all. There's no balanced middle ground, which is what _we_
>would want.
>
>                  Linus

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
