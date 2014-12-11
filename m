Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830AbaLKGZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 01:25:16 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45534 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaLKGZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 01:25:13 -0500
Date: Thu, 11 Dec 2014 07:25:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, v2] x86/microcode tree changes for v3.19
Message-ID: <20141211062508.GB5059@gmail.com>
References: <20141209132745.GA31656@gmail.com>
 <20141210124254.GA25436@gmail.com>
 <CA+55aFwiu2D=hKNvCvn-LL+TpYn9RS-N7+E8w7p+xLNdWSk8sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwiu2D=hKNvCvn-LL+TpYn9RS-N7+E8w7p+xLNdWSk8sA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Dec 10, 2014 at 4:42 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Please pull the latest x86-microcode-for-linus git tree from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-microcode-for-linus
> 
> Hmm. There's a conflict with commit 02ecc41abcea ("x86, 
> microcode: Limit the microcode reloading to 64-bit for now"), 

Sorry, should have mentioned that explicitly, but forgot about 
it.

> but I'm going to assume that the issue is fixed now, and that 
> commit fbae4ba8c4a3 ("x86, microcode: Reload microcode on 
> resume") that causes the conflict also handles the 32-bit case 
> correctly. So my merge is going to just remove the X86_64 test, 
> effectively undoing that first commit, ratehr than keep it 
> around.
> 
> If it turns out that the 64-bit limitation needs to be still in 
> place, holler. We can re-do the ugly 64-bit limit thing if 
> required.

Hm, so in my own conflict resolution I kept that check, last I 
heard Boris was still seeing weirdnesses (read: crashes) on 
32-bit and I'm not sure even the full series fixes it all.

In any case, would be nice to double check this and reinstate the 
limitation explicitly if it's still needed, or apply a fix. 
Boris?

Thanks,

	Ingo
