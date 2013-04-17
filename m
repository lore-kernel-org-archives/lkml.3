Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966227Ab3DQRsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:48:21 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47293 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965225Ab3DQRsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:48:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130417.132702.1585825670796781999.davem@davemloft.net>
References: <CA+55aFwt82h7hk1YiCeoG2-GGpgLvyW8t_hZRHxyhDQw=_Luzw@mail.gmail.com>
	<20130417.131156.13653463501819067.davem@davemloft.net>
	<CA+55aFw2f3cnJOSr2Xz78sRACk1k6xLog-3HpqtCsgNtA4=Fdw@mail.gmail.com>
	<20130417.132702.1585825670796781999.davem@davemloft.net>
Date: Wed, 17 Apr 2013 10:48:16 -0700
X-Google-Sender-Auth: ZGE7y6J4Lgg1tlDpZjbxHxTPjK4
Message-ID: <CA+55aFy9xtep6t3w+WtpjiMreX-++2fW-XrTA=hOcaYRa8fe7A@mail.gmail.com>
Subject: Re: Device driver memory 'mmap()' function helper cleanup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 10:27 AM, David Miller <davem@davemloft.net> wrote:
>
> Passing PCI BARs into these routines is illegal, we have proper
> abstractions for mmap()'ing PCI resources via pci_mmap_page_range()
> et al.
>
> So, any code doing that needs to be fixed.

Hmm. I've definitely seen code that does that (well, it's not PCI, but
HPET, which is the same kind of "device mapped into memory rather than
RAM"), but the one example I definitely know of is x86-specific, where
it doesn't matter if it's IO memory or RAM.

I suspect there may be other drivers our there that do it, for the
simple reason that "it works on x86". And it's almost certainly
hardware that anybody with a sparc machine will never ever care about,
so I wouldn't worry too much about it ;)

(Same goes for things like s390 etc, which has a large comment about
"io_remap_pfn_range()" not being something they can support).

So in practice I suspect it's moot. The normal uses are about DMA
kernel allocations, and the cases where that isn't the case they might
not work on some architectures.

               Linus
