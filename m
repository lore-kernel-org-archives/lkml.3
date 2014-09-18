Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbaIRKBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 06:01:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786AbaIRKBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:01:02 -0400
Date: Thu, 18 Sep 2014 12:00:17 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Nadav Amit <namit@cs.technion.ac.il>, Ingo Molnar <mingo@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
Message-ID: <20140918100016.GA9260@potion.redhat.com>
References: <20140917124501.GC5358@nazgul.tnic>
 <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
 <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il>
 <20140917132141.GD5358@nazgul.tnic>
 <CAKLkAJ5wYuDL+96RcRwxi7xD1iAK8_oug1zC_niipV-ToCUu=A@mail.gmail.com>
 <20140917140601.GE5358@nazgul.tnic>
 <20140917150433.GC1273@potion.brq.redhat.com>
 <20140917152221.GF5358@nazgul.tnic>
 <20140918002953.GA6918@potion.redhat.com>
 <20140918071945.GA24842@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140918071945.GA24842@nazgul.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-18 09:19+0200, Borislav Petkov:
> On Thu, Sep 18, 2014 at 02:29:54AM +0200, Radim Krčmář wrote:
> > I think you proposed to use magic constant in place of of MASK_FAM_X, so
> 
> Huh, what?

Your example.  It cannot be verbatim MASK_FAM_X in real code.

I interpreted it to be a placeholder for 0x1ffff (first 17 bits) and
said why I think it is not a good thing.
The other interpretation (well named macro) was against your goal.

> > Second problem:  Most elements don't begin at offset 0, so the usual
> > retrieval would add a shift, (repurposing max_monitor_line_size)
> 
> So what?

Your goal was easy parsing (last sentence of the mail).

My argument is that bitfields are easier to read.  (With examples.)

> >  max_monitor_line_size = (cpuid & MASK_FAM_X) >> OFFSET_FAM_X;
> > 
> > and it's not better when we write it back after doing stuff.
> 
> Writing back CPUID on baremetal? You can't be serious.

We are not talking just about baremetal, see patch [3/3].

There are, and will be new, use cases for modifying and storing cpuid.

> Ok, this is getting ridiculous so I'll stop wasting time. I stand by my
> initial statement - this is a bad idea.

Acknowledged.
