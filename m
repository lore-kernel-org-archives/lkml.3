Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965983Ab3DQRVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:21:00 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:64623 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965409Ab3DQRUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:20:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130417.131156.13653463501819067.davem@davemloft.net>
References: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
	<516E88A9.9070200@ti.com>
	<CA+55aFwt82h7hk1YiCeoG2-GGpgLvyW8t_hZRHxyhDQw=_Luzw@mail.gmail.com>
	<20130417.131156.13653463501819067.davem@davemloft.net>
Date: Wed, 17 Apr 2013 10:20:43 -0700
X-Google-Sender-Auth: 26VFKeQWCAnt3bdZI35Q1E2hfG8
Message-ID: <CA+55aFw2f3cnJOSr2Xz78sRACk1k6xLog-3HpqtCsgNtA4=Fdw@mail.gmail.com>
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

On Wed, Apr 17, 2013 at 10:11 AM, David Miller <davem@davemloft.net> wrote:
>
> Yeah, the only thing special we do on sparc is interpret the PFN
> specially.  We munge it into the real physical address and then
> pass it all down to remap_pfn_range() to do the real work.

So the main thing I want to check is that *if* it's given a regular
RAM physical address, it still works?

Some drivers basically allocate DMA memory and then pass on the
resulting physical address to this. Others pass in the PCI BAR
addresses etc. And some try to use "remap_pfn_range()", and others try
to use "io_remap_pfn_range()", and quite frankly, from what I can tell
we can just always use the "io_" version because it ends up being a
proper superset.

I'm pretty sure it works fine the way I read it, but I'm just verifying..

              Linus
