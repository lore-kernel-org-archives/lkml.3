Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3GAOqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:46:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58930 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab3GAOqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:46:31 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130701143646.GG23515@pd.tnic>
References: <1372416851-56830-1-git-send-email-wedsonaf@gmail.com> <20130628111948.GA31065@gmail.com> <20130628140938.GA24819@pd.tnic> <CANeycqpiXO-B1+f-OXZfHaxxPd2aVEL0kutFp6-sALHqXNrazQ@mail.gmail.com> <20130630220004.GA23124@pd.tnic> <20130701075046.GB1681@gmail.com> <20130701102306.GC23515@pd.tnic> <19b76ce4-35e0-4f82-b7e9-aa07d5d8af2c@email.android.com> <20130701143646.GG23515@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 01 Jul 2013 07:45:41 -0700
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <07ca6bb4-2153-48ec-9171-dd7d66720d96@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right... brain not awake yet, sorry, and responding from my phone.

I am not to worried about trading off a bit of additional branch mispredicts if everything else wins, but Ingo does have a valid question if we are measuring the right thing.

The effect is definitely big enough that it would be good to understand it one way or the other.

And regardless of the source... nice job!

Borislav Petkov <bp@alien8.de> wrote:

>On Mon, Jul 01, 2013 at 07:30:14AM -0700, H. Peter Anvin wrote:
>> Unconditional branches don't need prediction. The branch predictor
>> is used for conditional branches and in some hardware designs for
>> indirect branches. Unconditional direct branches never go through
>> the branch predictor simply because the front end can know with 100%
>> certainty where the flow of control will be.
>
>I meant the conditional Jcc branches:
>
>ffffffff81774920 <mutex_lock>:
>
>...
>
>ffffffff8177492d:       f0 ff 0b                lock decl (%rbx)
>ffffffff81774930:       79 08                   jns    ffffffff8177493a
><mutex_lock+0x1a>
>
>
>
>ffffffff81774730 <mutex_unlock>:
>
>...
>
>ffffffff81774738:       f0 ff 07                lock incl (%rdi)
>ffffffff8177473b:       7f 0a                   jg     ffffffff81774747
><mutex_unlock+0x17>

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
