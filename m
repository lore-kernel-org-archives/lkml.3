Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaCaTpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:45:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:36313 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaCaTpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:45:40 -0400
Date: Mon, 31 Mar 2014 21:45:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@kernel.org>, Neil Horman <nhorman@tuxdriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/iommu change for v3.15
In-Reply-To: <CA+55aFyAi0Vh6L5C8G6Jm3-FP81TNZekM_MiN-0wA3vvg3tSCQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1403312144280.14882@ionos.tec.linutronix.de>
References: <20140331144934.GA12335@gmail.com> <CA+55aFyAi0Vh6L5C8G6Jm3-FP81TNZekM_MiN-0wA3vvg3tSCQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014, Linus Torvalds wrote:

> On Mon, Mar 31, 2014 at 7:49 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > Neil Horman (1):
> >       x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets
> 
> Before I pull this, I want somebody to double-check it:
> 
> > -       if (revision == 0x13)
> > +       if (revision < 0x13)
> >                 set_irq_remapping_broken();
> 
> This change does *not* match the comment just above it. The comment
> talks very much about revision 13.
> 
> So the comment should be fixed, and/or that "< 0x13" should perhaps be
> "<= 0x13".
> 
> Because making it "less than" simply makes no sense in light of the
> comment. Does revision 13 suddenly work? Was that where it was fixed?
> If so, please fix the comment.

That is my bad. I applied V1 of the patch instead of V2 which had the
<= 0x13 instead of < 0x13.

Please drop the pull request for now. I'll fix it up and we resubmit.

Thanks,

	tglx

