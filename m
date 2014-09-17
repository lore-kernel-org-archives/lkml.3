Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaIQPWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:22:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40762 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbaIQPWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:22:33 -0400
Date: Wed, 17 Sep 2014 17:22:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Nadav Amit <namit@cs.technion.ac.il>, Ingo Molnar <mingo@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
Message-ID: <20140917152221.GF5358@nazgul.tnic>
References: <20140917124501.GC5358@nazgul.tnic>
 <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
 <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il>
 <20140917132141.GD5358@nazgul.tnic>
 <CAKLkAJ5wYuDL+96RcRwxi7xD1iAK8_oug1zC_niipV-ToCUu=A@mail.gmail.com>
 <20140917140601.GE5358@nazgul.tnic>
 <20140917150433.GC1273@potion.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140917150433.GC1273@potion.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 05:04:33PM +0200, Radim Krčmář wrote:
> which would result in a similar if-else hack
> 
>   if (family > X)
>   	ebx.split.max_monitor_line_size_after_family_X = 0
>   else
>   	ebx.split.max_monitor_line_size = 0
> 
> other options are
>   ebx.split.after_family_X.max_monitor_line_size
> or even
>   ebx.split.max_monitor_line_size.after_family_X

And how is that better than simply doing

	cpuid = cpuid_ebx(5);

	if (family > X)
		max_monitor_line_size = cpuid & MASK_FAM_X;
	else
		max_monitor_line_size = cpuid & MASK_BEFORE_FAM_X;

?

With proper variable naming all is perfectly clear, readable
and simple. You don't need to open even the CPUID manual - the
variable tells you you're getting the max monitor line size -
"ebx.split.max_monitor_line_size_after_family_X" needs me to parse it
with my eyes first.

-- 
Regards/Gruss,
    Boris.
--
