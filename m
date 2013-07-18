Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab3GRHwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:52:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3GRHwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:52:10 -0400
Date: Thu, 18 Jul 2013 00:52:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kbuild" <linux-kbuild@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        hyojun.im@lge.com, chan.jeong@lge.com,
        Andy Lee <raphael.andy.lee@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
Message-Id: <20130718005203.9e9dc1d1.akpm@linux-foundation.org>
In-Reply-To: <201307180947.02456.yann.morin.1998@free.fr>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
	<CAMuHMdXzcRxEBqavTx-kEq6CNAx5fYug0w8kjDw=vNfS2iX4Fw@mail.gmail.com>
	<20130718003408.bb9d5b51.akpm@linux-foundation.org>
	<201307180947.02456.yann.morin.1998@free.fr>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jul 2013 09:47:02 +0200 "Yann E. MORIN" <yann.morin.1998@free.fr> wrote:

> > 
> > I prefer the "option exec" approach, actually.  That way the shell-outs
> > are colocated with the code which uses
> 
> Indeed, but in this case, all the checks will be spread-out in the Kconfig
> files, and not easily locatable. Having all in a single script will also
> more easily raise eyebrows when that script appears in a diffstat. Noticing
> the 'exec' option risks being a bit less easy.

Eh, there are a million ways to screw up the kernel.

> But, that's not my call to decide. ;-)
> 
> > them and they will only be executed
> > if you've actually selected that subsystem for building (I think?).
> 
> If I understand the code correctly (which is still to be proven), the
> exec option is run at parse-time, once.

Yes, but not every Kconfig file in the tree gets parsed every time. 
For example, if arch/arm/Kconfig uses "option exec=some-slow-thing",
x86 users won't execute some-slow-thing.  This is good.

