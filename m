Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbaISNlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:41:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbaISNlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:41:08 -0400
Message-ID: <541C324D.2080608@redhat.com>
Date: Fri, 19 Sep 2014 15:40:29 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Nadav Amit <namit@cs.technion.ac.il>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
References: <20140917124501.GC5358@nazgul.tnic> <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il> <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il> <20140917132141.GD5358@nazgul.tnic> <CAKLkAJ5wYuDL+96RcRwxi7xD1iAK8_oug1zC_niipV-ToCUu=A@mail.gmail.com> <20140917140601.GE5358@nazgul.tnic> <541AD8F3.5010700@redhat.com> <20140918132635.GB27008@nazgul.tnic> <541ADFEB.6030801@redhat.com> <20140919075814.GA30491@nazgul.tnic>
In-Reply-To: <20140919075814.GA30491@nazgul.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/09/2014 09:58, Borislav Petkov ha scritto:
>> > The trivial example is feature bits like XSAVE. We query them all the
>> > time without checking the family when they were first introduced,
>> > don't we?
> The feature bits would obviously be 0 if features are not supported.

And similarly, Intel would not extend a bit from 16 to 17 bits if it
weren't zero on all older processors.

> However, even there
> 
> "16 - Reserved - Do not count on the value."
> 
> I'm quoting Intel's CPUID doc 241618-037 from 2011 (there might be a
> newer one though), the CPUID(1).ECX description.

Once that bit gets a meaning in newer processors, the same meaning will
work retroactively for existing processors.  That's just how CPUID is
used.  Nobody checks families before testing bits, Intel/AMD do not even
suggest that.

> Do you have a guarantee that this won't happen in the future and break
> all your fancy bitfields assumptions?

No guarantee, but were that to happen, I'd expect tar and feathers
spectacles around Intel's engineering headquarters.

Paolo
