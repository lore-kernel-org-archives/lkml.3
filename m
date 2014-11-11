Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaKKWdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:33:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48886 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbaKKWdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:33:22 -0500
Date: Tue, 11 Nov 2014 23:33:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Message-ID: <20141111223316.GQ31490@pd.tnic>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141111213628.GP31490@pd.tnic>
 <CALCETrU-Uiv8zHC1_-agcH-ByLqzeN1c58EPue5AdbmaDQLpdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrU-Uiv8zHC1_-agcH-ByLqzeN1c58EPue5AdbmaDQLpdQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 02:12:18PM -0800, Andy Lutomirski wrote:
> I don't see why it would be any more likely for the normal kernel
> stack to be corrupted due to a hardware issue that interrupted ring 3
> code than that the IST stack is corrupted.

The IST stack is, well, used solely be used for the vectors it is
assigned for. Maybe the probabability of it getting bad is a bit
lower..., who knows.

> I don't know what, if anything, masks and unmasks #MC, but certainly
> switching to process context like this patch does will not unmask it.

Manuals say to clear MCG_STATUS[MCIP] before you return but you also
have to IRET. Because not having cleared MCIP and returning would shut
down the machine on another #MC.

But then what does it bring me to run on the kernel stack if I'm still
in atomic context and I can't take locks? That doesn't help me with the
memory_failure() thing.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
