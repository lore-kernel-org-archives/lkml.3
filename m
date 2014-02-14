Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaBNRdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:33:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37893 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbaBNRdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:33:42 -0500
Date: Fri, 14 Feb 2014 18:33:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
Message-ID: <20140214173333.GA6953@pd.tnic>
References: <52FB5669.7090506@canonical.com>
 <20140212115412.GW27965@twins.programming.kicks-ass.net>
 <52FCFA23.4060701@canonical.com>
 <20140213173852.GH6835@laptop.programming.kicks-ass.net>
 <52FD090C.7010408@canonical.com>
 <20140213182605.GC14089@laptop.programming.kicks-ass.net>
 <20140214133428.GB26356@pd.tnic>
 <52FE2709.3050505@canonical.com>
 <20140214144700.GC26356@pd.tnic>
 <52FE4C28.1080500@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52FE4C28.1080500@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 06:02:32PM +0100, Stefan Bader wrote:
> Okaaay, I think I did what you asked. So yes, there is sse2 in the cpu info. And
> there is a mfence in the disassembly:

Btw, I just realized booting the kernel in the guest was a dumb idea,
because, doh, the guest is not baremetal. The only reliable thing we
can say is that sse2 is present and that MFENCE alternative replacement
works :)

But for simplicity's sake let's just assume the machine can do MFENCE
just fine and it gets replaced by the alternatives code.

Besides, if that weren't true, we'd have a whole lot of other problems
on those boxes.

> Thinking about it, I guess Peter is quite right saying that I likely
> will end on the patch that converted preempt_count to percpu.

Yeah, c2daa3bed53a81171cf8c1a36db798e82b91afe8 et al.

> One thing I likely should do is to reinstall the exact same laptop
> with 64bit kernel and userspace... maybe only 64bit kernel first...
> and make sure on my side that this does not show up on 64bit, too. I
> took the word of reporters for that (and the impression that otherwise
> many more people would have complained).

Yeah, that should be a prudent thing to do.

Also, Paolo and I were wondering whether you can trigger this thing
without kvm, i.e. virtualization involved... do you have any data on
that?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
