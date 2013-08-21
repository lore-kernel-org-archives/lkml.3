Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab3HUTwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:52:03 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:18263 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3HUTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:52:00 -0400
Date: Wed, 21 Aug 2013 21:51:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Weinberger <richard@nod.at>,
        Linux-Arch <linux-arch@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [RFC] Get rid of SUBARCH
Message-ID: <20130821195157.GA18191@merkur.ravnborg.org>
References: <1377073172-3662-1-git-send-email-richard@nod.at> <CAMuHMdWk-EPTNmPB1O1+F7YVQLjhQsFJznYwA3t6UCGUU1T9PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWk-EPTNmPB1O1+F7YVQLjhQsFJznYwA3t6UCGUU1T9PQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > The series touches also m68k, sh, mips and unicore32.
> > These architectures magically select a cross compiler if ARCH != SUBARCH.
> > Do really need that behavior?
> 
> This does remove functionality.
> It allows to build a kernel using e.g. "make ARCH=m68k".
> 
> Perhaps this can be moved to generic code? Most (not all!) cross-toolchains
> are called $ARCH-{unknown-,}linux{,-gnu}.
> Exceptions are e.g. am33_2.0-linux and bfin-uclinux.

Today you can specify CROSS_COMPILE in Kconfig.
With this we should be able to remove these hacks.

	Sam
