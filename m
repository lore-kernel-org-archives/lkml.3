Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaDNTEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:04:45 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47848 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaDNTEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:04:43 -0400
X-Auth-Info: C1bgZ+CrtAReA619/X6a2Qw0rT5CGN7nKElKOy58Jrk=
From: Marek Vasut <marex@denx.de>
To: Graham Moore <ggrahammoore@gmail.com>
Subject: Re: [PATCH V2] Add support for flag status register on Micron chips.
Date: Mon, 14 Apr 2014 20:29:15 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: "grmoore@altera.com" <grmoore@altera.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Insop Song <insop.song@gainspeed.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
References: <1397228593-17996-1-git-send-email-grmoore@altera.com> <201404131918.45753.marex@denx.de> <CA+iBjpSHL0+A=wzhhVvT_y+mhZoFNLUkNe18OtxPn1hZVCdUDw@mail.gmail.com>
In-Reply-To: <CA+iBjpSHL0+A=wzhhVvT_y+mhZoFNLUkNe18OtxPn1hZVCdUDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404142029.15280.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 14, 2014 at 06:19:24 PM, Graham Moore wrote:
> On Sun, Apr 13, 2014 at 12:18 PM, Marek Vasut <marex@denx.de> wrote:
> [...]
> 
> >> +#define      OPCODE_RDFSR            0x70  /* read flag status register
> >> */
> > 
> > I know this is not your fault, but can you please indent this properly
> > with tabs?
> > 
> >>  #define      OPCODE_NORM_READ        0x03    /* Read data bytes (low
> > 
> > frequency) */
> > 
> >>  #define      OPCODE_FAST_READ        0x0b    /* Read data bytes (high
> > 
> > frequency) */
> > 
> >>  #define      OPCODE_QUAD_READ        0x6b    /* Read data bytes */
> > 
> > And fix this one in a separate patch to use tabs as well please ?
> 
> I'm rebasing on l2-mtd spinor, and the tabs are jacked up there too.
> I'll fix the
> one I added, and fix other tabs in a new patch on that branch.

I know :( , thanks!

> [...]
> 
> > I wonder, can't wait_till_ready() be made a wrapper that will check the
> > USE_FSR flag and call correct wait-function ? This would avoid adding a
> > new member to *flash and also would avoid so many changes throughout the
> > code. What do you think?
> 
> Yeah, that's kind of ugly, but the flags exist only in the static
> m25p_ids[] and are only
> used in the scan/init.  I'd have to add a new member to save them for
> later use.
> And then other uses would crop up.  So, seemed kinda iffy either way.
> 
> It's going to change anyway, because l2-mtd spinor branch has refactored
> wait_till_ready() such that it uses a function pointer from the new
> spi_nor struct.
> I'm still mulling it over :)

Roger that, I'll wait for the V3 . Thanks!

Best regards,
Marek Vasut
