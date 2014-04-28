Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbaD1Phq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:37:46 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48699 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbaD1Phm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:37:42 -0400
Date: Mon, 28 Apr 2014 23:37:32 +0800
From: Huang Shijie <shijie8@gmail.com>
To: Graham Moore <ggrahammoore@gmail.com>
Cc: Huang Shijie <b32955@freescale.com>, Marek Vasut <marex@denx.de>,
        Graham Moore <grmoore@altera.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        linux-mtd@lists.infradead.org, Insop Song <insop.song@gainspeed.com>,
        Alan Tull <atull@altera.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH V3] Add support for flag status register on Micron chips.
Message-ID: <20140428153728.GA2020@localhost.localdomain>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com>
 <201404260012.24311.marex@denx.de>
 <20140426031011.GA4811@localhost.localdomain>
 <201404280706.18068.marex@denx.de>
 <20140428070602.GA29525@localhost>
 <CA+iBjpS9gstvippLHzm_Tpgxx19VxnRzWEwi_tJV5d7+snnfWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+iBjpS9gstvippLHzm_Tpgxx19VxnRzWEwi_tJV5d7+snnfWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 09:22:58AM -0500, Graham Moore wrote:
> On Mon, Apr 28, 2014 at 2:06 AM, Huang Shijie <b32955@freescale.com> wrote:
> > On Mon, Apr 28, 2014 at 07:06:17AM +0200, Marek Vasut wrote:
> >>
> >> Two things competing over the same pointer looks misdesigned to me. I will need
> >> to dig into this one more time ...
> > Please refer to the code for NAND chip, the nand_get_flash_type() :
> >
> > -----------------------------------------------------------
> >         /* Do not replace user supplied command function! */
> >         if (mtd->writesize > 512 && chip->cmdfunc == nand_command)
> >                 chip->cmdfunc = nand_command_lp;
> > -----------------------------------------------------------
> >
> > It uses the same logic:
> >         " Do not replace user supplied command function!"
> >
> > thanks
> > Huang Shijie
> 
> I would like to set the @wait_till_ready in m25p80.c, because the
> USE_FSR flag is only for Micron chips.  But the m25p80 driver doesn't
m25p80.c is not the right place. 

we should put these code in the spi-nor.c

thanks
Huang Shijie
