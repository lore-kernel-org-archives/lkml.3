Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274AbaLKJMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:12:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37848 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934260AbaLKJMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:12:41 -0500
Date: Thu, 11 Dec 2014 10:12:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, v2] x86/microcode tree changes for v3.19
Message-ID: <20141211091238.GA31140@pd.tnic>
References: <20141209132745.GA31656@gmail.com>
 <20141210124254.GA25436@gmail.com>
 <CA+55aFwiu2D=hKNvCvn-LL+TpYn9RS-N7+E8w7p+xLNdWSk8sA@mail.gmail.com>
 <20141211062508.GB5059@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141211062508.GB5059@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 07:25:08AM +0100, Ingo Molnar wrote:
> > Hmm. There's a conflict with commit 02ecc41abcea ("x86, 
> > microcode: Limit the microcode reloading to 64-bit for now"), 
> 
> Sorry, should have mentioned that explicitly, but forgot about 
> it.
> 
> > but I'm going to assume that the issue is fixed now, and that 
> > commit fbae4ba8c4a3 ("x86, microcode: Reload microcode on 
> > resume") that causes the conflict also handles the 32-bit case 
> > correctly. So my merge is going to just remove the X86_64 test, 
> > effectively undoing that first commit, ratehr than keep it 
> > around.

Yes, this is the intended outcome.

> > If it turns out that the 64-bit limitation needs to be still in 
> > place, holler. We can re-do the ugly 64-bit limit thing if 
> > required.
> 
> Hm, so in my own conflict resolution I kept that check, last I 
> heard Boris was still seeing weirdnesses (read: crashes) on 
> 32-bit and I'm not sure even the full series fixes it all.
> 
> In any case, would be nice to double check this and reinstate the 
> limitation explicitly if it's still needed, or apply a fix. 
> Boris?

The problem was that while I was testing 32-bit on an IVB laptop, the
machine would triple-fault on resuming from disk. Sometimes, not on each
resume cycle. So I thought this was originally caused by the changes to
the early reloading mechanism.

However, I did a coarse bisection all the way back to 3.10 and the issue
still exists. So it either is this particular laptop or 32-bit suspend
from disk has been always broken.

In any case, the current mainline state of the microcode loader should
be the correct one, I've been testing it on AMD and Intel, both early
and/xor late microcode loader, suspend to disk and to ram and all works
fine.

stable@ would need addressing at some point but I'd like to leave it in
mainline a bit to see some more testing and backport it to stable when
there's more confidence all is ok.

Thanks guys.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
