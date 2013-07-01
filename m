Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3GAVHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:07:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55562 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755057Ab3GAVHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:07:34 -0400
Message-ID: <1372712853.2481.24.camel@joe-AO722>
Subject: Re: [PATCH] m68k/setup: Use pr_*() instead of plain printk()
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 01 Jul 2013 14:07:33 -0700
In-Reply-To: <CAMuHMdUA3+gLi00Tvik2SjZaRYSC2sMMmP9TMH=Vb1dAubXx3Q@mail.gmail.com>
References: <1372585689-29492-1-git-send-email-geert@linux-m68k.org>
	 <1372630948.2083.3.camel@joe-AO722>
	 <CAMuHMdUA3+gLi00Tvik2SjZaRYSC2sMMmP9TMH=Vb1dAubXx3Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 23:02 +0200, Geert Uytterhoeven wrote:
> On Mon, Jul 1, 2013 at 12:22 AM, Joe Perches <joe@perches.com> wrote:
> >> diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
> >
> >> @@ -161,7 +161,7 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
> > []
> >> -                             printk("m68k_parse_bootinfo: too many memory chunks\n");
> >> +                             pr_warn("m68k_parse_bootinfo: too many memory chunks\n");
> >
> > These are generally better written by
> > removing the hand-written function name
> > and using "%s: ", __func__
> >
> >                                 pr_warn("%s: too many memory chunks\n",
> >                                         __func__);
> 
> I had tried that, too. But surprisingly (although the same function
> name was in two
> messages), it increased the size of the kernel image.

That's not surprising really.
There is more call frame stack per use too.

It does eliminate any issue with function renaming
though and is also less typo prone.

And, at some point, those __func__ uses could be
identified and rolled into a mechanism to emit the
function name via a standardized use of %pf and
__builtin_return_address(0) in the printk subsystem.

cheers, Joe

