Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaISH61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 03:58:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54401 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbaISH6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 03:58:25 -0400
Date: Fri, 19 Sep 2014 09:58:15 +0200
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
Message-ID: <20140919075814.GA30491@nazgul.tnic>
References: <20140917124501.GC5358@nazgul.tnic>
 <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
 <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il>
 <20140917132141.GD5358@nazgul.tnic>
 <CAKLkAJ5wYuDL+96RcRwxi7xD1iAK8_oug1zC_niipV-ToCUu=A@mail.gmail.com>
 <20140917140601.GE5358@nazgul.tnic>
 <541AD8F3.5010700@redhat.com>
 <20140918132635.GB27008@nazgul.tnic>
 <541ADFEB.6030801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <541ADFEB.6030801@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 03:36:43PM +0200, Paolo Bonzini wrote:
> We're talking about the case where the field is not reserved anymore and
> we _know_ that the vendor has just decided to grow the bitfield that
> precedes it.

We're talking about the case where you assumed that a reserved bit is 0
which is an unsafe assumption, the least.

> As soon as we know that the field is not reserved anymore, we
> obviously rely on reserved bits being zero in older processors, and in
> future processors from other vendors.

Again, this is an unsafe assumption.

> The trivial example is feature bits like XSAVE. We query them all the
> time without checking the family when they were first introduced,
> don't we?

The feature bits would obviously be 0 if features are not supported.

However, even there

"16 - Reserved - Do not count on the value."

I'm quoting Intel's CPUID doc 241618-037 from 2011 (there might be a
newer one though), the CPUID(1).ECX description.

-- 
Regards/Gruss,
    Boris.
--
