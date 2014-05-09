Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbaEIUb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:31:56 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:64542 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249AbaEIUby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:31:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140509135259.GC16260@pd.tnic>
References: <1399330337-16748-1-git-send-email-tthayer@altera.com>
	<1399330337-16748-4-git-send-email-tthayer@altera.com>
	<20140508120524.GF12548@pd.tnic>
	<CAF03EBecxtMr1670ktQKTAZX_kHeZWz1SwuEk373B99BoVjbDw@mail.gmail.com>
	<20140509135259.GC16260@pd.tnic>
Date: Fri, 9 May 2014 15:31:53 -0500
Message-ID: <CAF03EBeKbXr-7+qeARkBRXjystMjs4yEWnmw7q8tgJv9-SPgXA@mail.gmail.com>
Subject: Re: [PATCHv3 3/3] edac: altera: Add EDAC support for Altera SDRAM
From: Thor Thayer <tthayer.linux@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thor Thayer <tthayer@altera.com>, Rob Herring <robherring2@gmail.com>,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, linux@arm.linux.org.uk,
        Dinh Nguyen <dinguyen@altera.com>, dougthompson@xmission.com,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 8:52 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, May 08, 2014 at 03:37:19PM -0500, Thor Thayer wrote:
>> Yes. Their reasoning is that they want to retain the rights and
>> warranty language with the file (just in case the COPYING file
>> changes).
>
> Ok, thanks for checking up on this.
>
>> Yes. I tested using edac_core.edac_mc_panic_on_ue=1 from the command
>> line and it worked fine. I'll add a comment to clarify. BTW, thanks
>> for your help on that.
>
> Sure, but the question still remains: do you want to panic on
> uncorrectable errors by default or want the user to decide? I guess this
> is something you can answer for your hardware...

Yes, good point. Our hardware can't recover from Double Bit Errors so
I'll go back to the panic() in that path. I like the flexibility of
the command line parameter though...

>
>> I considered using "volatile" variables, but decided against it after
>> I read Documentation/volatile-considered-harmful.txt and my situation
>> doesn't fit into the exemptions. Is there a better way to handle this?
>
> Off the top of my head, I'd first look at compiler asm output to
> check what my compiler does with those writes and then take a look at
> employing the ACCESS_ONCE macro or something similar where we use the
> asm volatile() as an optimization stop for the compiler, among others.
>
> And then I'll look at asm again to make sure it does what it is supposed
> to do. Something to that effect, in any case...
>
> HTH.

The reads aren't optimized out now but I'd like to protect against
future optimization changes. I implemented ACCESS_ONCE and checked the
resulting asm output - it looks clean. Thanks.

>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
