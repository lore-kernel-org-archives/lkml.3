Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaJ1UNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:13:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36758 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbaJ1UNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:13:46 -0400
Date: Tue, 28 Oct 2014 21:13:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mathias Krause <minipli@googlemail.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
Message-ID: <20141028201342.GG10873@pd.tnic>
References: <1411313216-2641-2-git-send-email-minipli@googlemail.com>
 <20141003134707.GJ14343@console-pimps.org>
 <20141007150132.GA7307@nazgul.tnic>
 <20141007170748.GA25767@jig.fritz.box>
 <20141008151730.GB16892@pd.tnic>
 <CA+rthh_Q0HQfLX6P3kcuOUwggjSnhYGCc5YJNOn0UCCRPZbaxA@mail.gmail.com>
 <20141008222619.GG16892@pd.tnic>
 <20141012125515.GA32045@jig.fritz.box>
 <20141028185756.GD10873@pd.tnic>
 <CA+rthh9qePkJogFDT+ttSLvYPvJrAM6CXMJ407Hq3PjcRw9WTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+rthh9qePkJogFDT+ttSLvYPvJrAM6CXMJ407Hq3PjcRw9WTw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 08:48:23PM +0100, Mathias Krause wrote:
> I tried so too but failed early as well. I tried putting the EFI
> virtual mappings not in trampoline_pgd[511] but trampoline_pgd[510].
> However, that didn't work out. I got page faults when trying to invoke
> EFI functions, as, apparently, efi.systab was only mapped in the EFI
> page table but not the kernel's page table -- at least not at the same
> address. So when efi_call_virt() tries to dereference
> efi.systab->runtime->f, it just traps.
> I tried to hack around that by fiddling with get_systab_virt_addr() to
> make it point to the direct mapping for the phys_addr but failed on
> the first few attempts to get the math right. Then I noticed it was
> way to late to hack EFI code and fell asleep. Next day I just gave up
> and 'git reset --hard HEAD'. :(

I know exactly what you mean. The nasty thing about it is, debugging
this is not trivial as once you switch to another page table, you don't
have a #PF handler and the guest triple-faults. All of the above issues
I've encountered already while hacking on the current code :-) *Cringe*

I want to do experimentation with tracing page faults in KVM with the
nested PF handling in hw turned off so that I can see all #PFs. Maybe
that'll tell me something more, we'll see.

> Debian's version of qemu + OVMF works fine here. Probably slightly
> outdated but still good enough for testing EFI stuff ;)

Yeah, Paolo fixed it already:

https://lkml.kernel.org/r/1414420306-2771-2-git-send-email-pbonzini@redhat.com

I think we want to keep qemu+kvm functioning :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
