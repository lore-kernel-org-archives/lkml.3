Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3HEQMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:12:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36614 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3HEQMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:12:49 -0400
Date: Mon, 5 Aug 2013 18:12:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Laszlo Ersek <lersek@redhat.com>
Cc: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130805161247.GF31845@pd.tnic>
References: <20130731205431.GG4724@pd.tnic>
 <1375307727.22084.103.camel@shinybook.infradead.org>
 <20130801164927.GA7445@pd.tnic>
 <51FF8C14.2070405@redhat.com>
 <20130805130258.GB31845@pd.tnic>
 <51FFAB13.4090603@redhat.com>
 <20130805140306.GD31845@pd.tnic>
 <51FFB660.4060400@redhat.com>
 <20130805144010.GE31845@pd.tnic>
 <51FFC19A.1020204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51FFC19A.1020204@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 05:15:38PM +0200, Laszlo Ersek wrote:
> The current implementation (how pointers are converted) probably doesn't
> accommodate a second call.
> 
> Of course you want to know why SetVirtualAddressMap() was designed like
> that... I didn't participate in the design so I don't know :)
> 
> But, as I said, a kernel directly executing another kernel is an
> unexpected idea. IMHO the second kernel in question doesn't fit the UEFI
> phases at all. The OS booted like that (ie. the OS whose kernel is the
> 2nd (=kexec) kernel) never goes through SEC, PEI, DXE, BDS.

Yes, the thing is, imposing unnecessary restrictions is very
counterproductive. And kexec is just an example here - if
SetVirtualAddressMap was callable an arbitrary number of times, this
whole work I'm doing is unnecessary. So I'm jumping through hoops just
to accomodate a braindead design.

This is what I cannot fathom in the face of people praising UEFI as the
solution to all problems. Where in fact it causes more, and needlessly
at that.

> That doesn't matter as long as the UEFI designers aren't aware of it :)

Well, it wouldn't have hurt if they at least looked around what's out
there...

> (Who should have made whom aware, ie. Linux people approaching UEFI
> people, or UEFI people exploring Linux, is a separate topic. As always
> I'm apolitical about UEFI; I'm not arguing for it or against it. My
> feeble efforts for improving OVMF and interfacing code are motivated by
> my employer, not my world view, but as a side-effect of working with the
> code I can't help but notice some nice things in edk2 and appreciate
> them :))

No, I completely understand. I was simply asking whether you've managed
to see an aspect which made sense for SetVirtualAddressMap to be
callable only once and to enlighten me about it because I can't see one
so far.

> Insult my code or my analysis pls.

I won't and I don't need to insult anybody or anything. :)

> BTW there's another point I'd like to ask about -- you're saying you
> see the region corruption during the same boot, from the first (early)
> memmap dump to the second one (when just about to enter virtual mode).
> But, is this one boot the very first boot, or the kexec one?

No, kexec is not even involved yet. If you look at the timestamps,
there's 0.005 seconds between the two dumps during the *same* kernel
booting on the machine, baremetal, straight from grub.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
