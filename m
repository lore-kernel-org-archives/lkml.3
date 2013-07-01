Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3GAOg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:36:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54954 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab3GAOg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:36:57 -0400
Date: Mon, 1 Jul 2013 16:36:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
Message-ID: <20130701143646.GG23515@pd.tnic>
References: <1372416851-56830-1-git-send-email-wedsonaf@gmail.com>
 <20130628111948.GA31065@gmail.com>
 <20130628140938.GA24819@pd.tnic>
 <CANeycqpiXO-B1+f-OXZfHaxxPd2aVEL0kutFp6-sALHqXNrazQ@mail.gmail.com>
 <20130630220004.GA23124@pd.tnic>
 <20130701075046.GB1681@gmail.com>
 <20130701102306.GC23515@pd.tnic>
 <19b76ce4-35e0-4f82-b7e9-aa07d5d8af2c@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19b76ce4-35e0-4f82-b7e9-aa07d5d8af2c@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 07:30:14AM -0700, H. Peter Anvin wrote:
> Unconditional branches don't need prediction. The branch predictor
> is used for conditional branches and in some hardware designs for
> indirect branches. Unconditional direct branches never go through
> the branch predictor simply because the front end can know with 100%
> certainty where the flow of control will be.

I meant the conditional Jcc branches:

ffffffff81774920 <mutex_lock>:

...

ffffffff8177492d:       f0 ff 0b                lock decl (%rbx)
ffffffff81774930:       79 08                   jns    ffffffff8177493a <mutex_lock+0x1a>



ffffffff81774730 <mutex_unlock>:

...

ffffffff81774738:       f0 ff 07                lock incl (%rdi)
ffffffff8177473b:       7f 0a                   jg     ffffffff81774747 <mutex_unlock+0x17>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
