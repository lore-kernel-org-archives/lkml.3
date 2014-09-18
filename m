Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbaIRN0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:26:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55453 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbaIRN0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:26:46 -0400
Date: Thu, 18 Sep 2014 15:26:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nadav Amit <namit@cs.technion.ac.il>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
Message-ID: <20140918132635.GB27008@nazgul.tnic>
References: <20140917124501.GC5358@nazgul.tnic>
 <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
 <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il>
 <20140917132141.GD5358@nazgul.tnic>
 <CAKLkAJ5wYuDL+96RcRwxi7xD1iAK8_oug1zC_niipV-ToCUu=A@mail.gmail.com>
 <20140917140601.GE5358@nazgul.tnic>
 <541AD8F3.5010700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <541AD8F3.5010700@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 03:06:59PM +0200, Paolo Bonzini wrote:
> The extra bit used to be reserved and thus will be zero on older
> families.  So, nothing?

"thus will be zero" is unfortunately simply not true.

>From the SDM:

"1.3.2 Reserved Bits and Software Compatibility

In many register and memory layout descriptions, certain bits are marked
as reserved. When bits are marked as reserved, it is essential for
compatibility with future processors that software treat these bits as
having a future, though unknown, effect. The behavior of reserved bits
should be regarded as not only undefined, but unpredict- able. Software
should follow these guidelines in dealing with reserved bits:

* Do not depend on the states of any reserved bits when testing the values of registers that contain such bits.
Mask out the reserved bits before testing.

*  Do not depend on the states of any reserved bits when storing to memory or to a register.

* Do not depend on the ability to retain information written into any reserved bits.

* When loading a register, always load the reserved bits with the values indicated in the documentation, if any,
or reload them with values previously read from the same register."

And so on and so on.

Aaanyway, I see kvm folks are strongly determined to do this so I'll
propose you do it for kvm only and not touch the rest of arch/x86/.

I really really disagree with casting CPUID words in stone and with
touching code which is perfectly fine.

But this is just me and the final word lies with x86 people so it'll
happen whatever they say.

-- 
Regards/Gruss,
    Boris.
--
