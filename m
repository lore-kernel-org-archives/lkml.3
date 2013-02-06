Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab3BFQ1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:27:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52361 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3BFQ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:27:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Wed, 6 Feb 2013 16:27:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Michal Simek <monstr@monstr.eu>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <1360105635.2707.7.camel@pasglop> <CACxGe6u=zhGXm0AO_h354g8OOkAQgdczdw_gCCRxL+=r8hM+-g@mail.gmail.com>
In-Reply-To: <CACxGe6u=zhGXm0AO_h354g8OOkAQgdczdw_gCCRxL+=r8hM+-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302061627.07587.arnd@arndb.de>
X-Provags-ID: V02:K0:ckFmy9gSKq82i2kTpMubaGN0GbEdfX5pdvC0BgmrNit
 eyR/ZKIUZwdY89RiFju3pCU27xvsn2qI5TkyQpWtoua0eV/YzZ
 af0L6o0UWLfkQPN4DDxR9Rqp1lVqJW+wH35cd6dQnDZO0FEWsI
 08+bQy2WLkRvVkSyHmOo37vnVeE2SeWyELGGtcst2n7fa0kMxi
 Olfy8l2ZVJy1gUHaDx3dkeyVyizFj5QfoZPnjm6+fUmBWPRWBo
 PD6h7rt1MYv7GSxeVQTKt+OpqrSMAJ5p5vtiEUB8vBkSNI11ZN
 MnNK6qzRQGRNk+ycLUJ+OihWs4hCVBfLnzdoxu6OhyIYSmIpc7
 Y+RAYhGawcGcfxeNede0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2013, Grant Likely wrote:
> The only problem that I see is that the ARM and Microblaze
> ioread16be/iowrite16be helpers are missing barriers which smells like
> a bug and should be fixed.

It looks correct to me on ARM, we use the same barriers in ioread and
iowrite that we use in readl/writel.

Microblaze uses no barriers in any of the I/O accessor families
(readl, ioread32, in_le32, inl, inl_p), so it presumably doesn't
require any because it is fully ordered, at least changing from
in_le32 to ioread32 won't make it worse.
On a related note, the inb/outb style accessors are bogus on microblaze
and should be removed, but that is a different discussion. I should
have updated my old patches to introduce a meaningful CONFIG_NO_IOPORT
ages ago, and without them it probably breaks.

	Arnd
