Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbaJ1Vtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:49:39 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:42142 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaJ1Vti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:49:38 -0400
MIME-Version: 1.0
In-Reply-To: <20141028212642.GH10873@pd.tnic>
References: <20141007150132.GA7307@nazgul.tnic>
	<20141007170748.GA25767@jig.fritz.box>
	<20141008151730.GB16892@pd.tnic>
	<CA+rthh_Q0HQfLX6P3kcuOUwggjSnhYGCc5YJNOn0UCCRPZbaxA@mail.gmail.com>
	<20141008222619.GG16892@pd.tnic>
	<20141012125515.GA32045@jig.fritz.box>
	<20141028185756.GD10873@pd.tnic>
	<CA+rthh9qePkJogFDT+ttSLvYPvJrAM6CXMJ407Hq3PjcRw9WTw@mail.gmail.com>
	<20141028201342.GG10873@pd.tnic>
	<CA+rthh9LSRm12qYORAd5BWzpw7DEP7hqHLA3EDdfUDxwx-4=2g@mail.gmail.com>
	<20141028212642.GH10873@pd.tnic>
Date: Tue, 28 Oct 2014 22:49:36 +0100
Message-ID: <CA+rthh-Tk3PO0qUeyLzxggCYOhr5D4EvPjKR+jhmjdPXi4yu=Q@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
From: Mathias Krause <minipli@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 October 2014 22:26, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Oct 28, 2014 at 10:14:25PM +0100, Mathias Krause wrote:
>> Oh, well. Have fun with that! I would take the "map kernel into EFI
>> page table" route instead. ;)
>
> Actually, I want to try to keep them completely separate and sync only
> before an EFI RT call for function arguments.

Sync only data or kernel code, too?

> And then remove PGDs after
> I return from it. We'll see how it all works out.

That shouldn't be needed as you're switching away from the EFI page
table, so its entries wouldn't be effective any more anyway.

Really, I'd just map the EFI RT service virtual mappings "somewhere"
but at pgd[511] and have pgd[511] initially set up as
init_level4_pgt[511]. Then, thing should "just work"(TM).

If you fear the EFI code might do harm to the kernel code/data, then
you've lost anyway. Nothing will prevent the EFI code from doing nasty
things -- like setting up its own mappings to tamper with the kernel's
memory.

Regards,
Mathias
