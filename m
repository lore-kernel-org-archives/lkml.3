Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbaESXKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:10:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41223 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbaESXKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:10:33 -0400
Date: Tue, 20 May 2014 01:10:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@kernel.org>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [GIT PULL] EFI changes for v3.16
Message-ID: <20140519231012.GF6311@pd.tnic>
References: <20140503130447.GW26088@console-pimps.org>
 <20140519105129.GF4798@console-pimps.org>
 <537A8A03.8060604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <537A8A03.8060604@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 03:47:31PM -0700, H. Peter Anvin wrote:
> >     efi_call can happen in an irq context (pstore) and there we really need
> >     to make sure we're not scribbling over FPU state while we've interrupted
> >     a thread or kernel mode with a live FPU state. Therefore, use the
> >     kernel_fpu_begin/end() variants which do that check.
> 
> How on earth does this solve anything?  The only thing we add here is a
> WARN_ON_ONCE()... but the above text already tells us we have a problem.
> 
> It seems, rather, that we need to figure out how to deal with a pstore
> in this case.  There are a few possibilities:
> 
> 1. We could keep an XSAVE buffer area around for this particular use.
>    I am *assuming* we don't let more than one CPU into EFI, because I
>    cannot for my life imagine that this is safe in typical CPUs.
> 
> 2. Drop the pstore on the floor if !irq_fpu_usable().
> 
> 3. Allow the pstore, then die (on the assumption that we're dead
>    anyway.)
> 
> Comments?

The question is, why can't that pstore mumbo jumbo go and do its dance
in !irq context?

And how useful is the whole deal really, btw? I wanted to use it for
saving oopses into it, for example, but Tony said its write speed is
horribly low for that.

So why do we even bother with this thing and do the dance in irq context
for it? Is it worth it at all?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
