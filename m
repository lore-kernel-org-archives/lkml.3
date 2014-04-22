Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbaDVQdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:33:25 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:56942 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153AbaDVQdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:33:21 -0400
MIME-Version: 1.0
In-Reply-To: <53569467.1030809@zytor.com>
References: <CAObL_7EJi5+m-oDXRy4hu+-OTZ=9wZ9WEivTMsdDtccU00wfWA@mail.gmail.com>
 <5355A9E9.9070102@zytor.com> <CAObL_7EP+zPpx9TVgsSu2iFN+r0U8yy6UEZtdk=CPwowXUu=Qw@mail.gmail.com>
 <1dbe8155-58da-45c2-9dc0-d9f4b5a6e643@email.android.com> <CAObL_7FUDpV9md+UnDbXxWw=trrXLFLNNJMNegdezrQt7rm6TA@mail.gmail.com>
 <a035392c-f332-4b3f-b851-13b0c7a0fc68@email.android.com> <CAObL_7FMX9yaGVi19pVwsU5VwHqKLLWMEB7kwDF-fatsGnHvdQ@mail.gmail.com>
 <ee12ff5e-91fe-487b-bed9-4472f15f94fe@email.android.com> <CAObL_7HTDvN2zu2_CDnVR_ztZ-b7PfLYz0csuVX-ShQ7EHGEjg@mail.gmail.com>
 <20140422112312.GB15882@pd.tnic> <20140422144659.GF15882@pd.tnic>
 <CAObL_7FGs4n6zusbdwTLi5W5q2V81Sf7pOnOmHPFyv5d7jMfvA@mail.gmail.com> <53569467.1030809@zytor.com>
From: Andrew Lutomirski <amluto@gmail.com>
Date: Tue, 22 Apr 2014 09:33:00 -0700
Message-ID: <CAObL_7F9yxt=vXjbssYB5wjZ7HUyKcstG7KYaRWxDDK0n7_vQw@mail.gmail.com>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 9:10 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Honestly, guys... you're painting the bikeshed at the moment.
>
> Initialization is the easiest bit of all this code.  The tricky part is
> *the rest of the code*, i.e. the stuff in entry_64.S.

That's because the initialization code is much simpler, so it's easy
to pick on :)  Sorry.

For the espfix_adjust_stack thing, when can it actually need to do
anything?  irqs should be off, I think, and MCE, NMI, and debug
exceptions use ist, so that leaves just #SS and #GP, I think.  How can
those actually occur?  Is there a way to trigger them deliberately
from userspace?  Why do you have three espfix_adjust_stack

What happens on the IST entries?  If I've read your patch right,
you're still switching back to the normal stack, which looks
questionable.

Also, if you want to same some register abuse on each exception entry,
could you check the saved RIP instead of the current RSP?  I.e. use
the test instruction with offset(%rsp)?  Maybe there are multiple
possible values, though, and just testing some bits doesn't help.

--Andy
