Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaGUIB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:01:59 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:63624 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaGUIB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:01:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v2 21/29] nios2: Futex operations
Date: Mon, 21 Jul 2014 10:01:38 +0200
Message-ID: <5003438.ZMUcOxtMrE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFiDJ5_hjBQ4tOpsUdgqgwRrJ1TgFSa9pEqc2m+srMj5Fkir=w@mail.gmail.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <5659104.6O7AZx76W6@wuerfel> <CAFiDJ5_hjBQ4tOpsUdgqgwRrJ1TgFSa9pEqc2m+srMj5Fkir=w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:UqAO3G6J2cY/HFMIE9enybxmggPftlC6iYM0sxy3BhE
 dpLXH8GpzizH8JGZaPnY9+07rrp8lu8foxuapQtit8k4BWZYR4
 a6lNmZDDkzq96F3xjBHwVMj2b4qpOLk5ggGW2REdwaJGK8nGdj
 22N0nyPYETMgMzoNqO9NNoRgQVkrUyv4pqlKAAvfInr2IM0Xan
 a3DC2e08V1ccSdENWUfobe/XhjdWNePgvRUgzeZU89Rwww/Fqx
 zv+BumD9tP8mw13OpQ6nGtgJNrepwCXumNsEqbk9gGouobpq+3
 ByaZxwgap8uJEX/wFbEuXFW45/rWxBc7SKVNW9A7hSnMicDqZV
 RDrgGt65/j2ypHTXTtJY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2014 11:20:02 Ley Foon Tan wrote:
> On Fri, Jul 18, 2014 at 5:55 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 18 July 2014 11:42:34 Thomas Gleixner wrote:
> >> On Fri, 18 Jul 2014, Arnd Bergmann wrote:
> >> > On Friday 18 July 2014 14:07:42 Ley Foon Tan wrote:
> >> > > On Thu, Jul 17, 2014 at 7:07 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > If this understanding is right, we can probably just merge the
> >> > m68k implementation into the asm-generic version, as that does
> >> > exactly that, and just isn't SMP safe. I'm still unsure whether
> >> > I'm missing something here though, as everything else seems to
> >> > do this in assembly, even for non-SMP machines that could use
> >> > the trivial method that m68k has.
> >>
> >> For UP relying of pagefault disable should be good enough indeed. I
> >> guess the asm for the other UP stuff results from looking at
> >> architectures or copying from architectures which did this in ASM
> >
> > Ok, thanks for the confirmation!
> >
> > Ley Foon Tan, I think the best way forward then is for you to
> > take the m68k code and copy (or move) that into asm-generic/futex.h
> > under an #ifndef CONFIG_SMP.
> 
> Okay, I will copy m68k implementation to asm-generic/futex.h.
> Do you prefer this as separate patch submission or this can be part of
> nios2 patchset?

I think it's better for everybody if you include it in your nios2
patchset, once I've seen the patch and provided an Ack. You can send
it separately for review at first.

	Arnd
