Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaJ1S6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:58:02 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52778 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaJ1S6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:58:00 -0400
Date: Tue, 28 Oct 2014 19:57:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mathias Krause <minipli@googlemail.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
Message-ID: <20141028185756.GD10873@pd.tnic>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
 <1411313216-2641-2-git-send-email-minipli@googlemail.com>
 <20141003134707.GJ14343@console-pimps.org>
 <20141007150132.GA7307@nazgul.tnic>
 <20141007170748.GA25767@jig.fritz.box>
 <20141008151730.GB16892@pd.tnic>
 <CA+rthh_Q0HQfLX6P3kcuOUwggjSnhYGCc5YJNOn0UCCRPZbaxA@mail.gmail.com>
 <20141008222619.GG16892@pd.tnic>
 <20141012125515.GA32045@jig.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141012125515.GA32045@jig.fritz.box>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 02:55:15PM +0200, Mathias Krause wrote:

...

> There's a lengthy comment in arch/x86/platform/efi/efi.c that mentions
> the duplication of pgd entries -- and therefore whole hierarchies --
> between trampoline_pgd and init_level4_pgt. And, ironically, that
> comment is yours from earlier this year. Looks like you forgot about
> that in the meantime ;)

Absolutely - you can see how crazy I am about UEFI :-)

Ok, thanks for refreshing this for me, your patch is good, so

Acked-by: Borislav Petkov <bp@suse.de>

What this whole story shows, however, is that the EFI mappings are in
fact in the kernel page table and this shouldn't be IMO - I'd like to
very much have them split because otherwise there's no need to switch
page tables at all. And besides, having UEFI in its own address space is
a good thing in itself anyway.

So, I've already hacked up something to have a completely separate EFI
page table - need to find out why it doesn't work yet but qemu was
b0rked until recently so we had to deal with that first... bla bla.

Thanks :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
