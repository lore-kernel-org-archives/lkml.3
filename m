Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3BFI7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:59:44 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:47924 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3BFI7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:59:41 -0500
MIME-Version: 1.0
In-Reply-To: <201302052303.01795.arnd@arndb.de>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<1360066756.4529.6.camel@pasglop>
	<CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
	<201302052303.01795.arnd@arndb.de>
Date: Wed, 6 Feb 2013 09:59:39 +0100
X-Google-Sender-Auth: a0OvUA608-Uthcck1MzFT3ycG74
Message-ID: <CAMuHMdWTtEyP_505x4S+uT1J-uFWb9VOMHNOCPcF-z1uSF6xDQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        alan@lxorguk.ukuu.org.uk, dahinds@users.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 12:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 05 February 2013, Michal Simek wrote:
>> I want to be sure about this. I have parsed this again with closer look and
>> seems to me that ioread32 is equal to readl and iowrite32 to writel.
>> Arnd: Am I right?
>
> Correct. On all the architectures you care about (most importantly, not
> x86), readl and ioread32 are defined to have the same semantics. There
> are a few exceptions where ioread32 provides a wrapper for PCI
> PIO accesses that are not memory mapped, making ioread32 slightly
> slower than readl, but for all practical purposes you don't have
> to worry about it ;-)

PCI PIO? Do you mean "PCI I/O space"?
That's different, and accessed through inb() and friends, right?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
