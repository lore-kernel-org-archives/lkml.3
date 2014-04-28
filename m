Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaD1OXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:23:02 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:46666 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaD1OXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:23:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140428070602.GA29525@localhost>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com>
	<201404260012.24311.marex@denx.de>
	<20140426031011.GA4811@localhost.localdomain>
	<201404280706.18068.marex@denx.de>
	<20140428070602.GA29525@localhost>
Date: Mon, 28 Apr 2014 09:22:58 -0500
Message-ID: <CA+iBjpS9gstvippLHzm_Tpgxx19VxnRzWEwi_tJV5d7+snnfWg@mail.gmail.com>
Subject: Re: [PATCH V3] Add support for flag status register on Micron chips.
From: Graham Moore <ggrahammoore@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: Marek Vasut <marex@denx.de>, Huang Shijie <shijie8@gmail.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 2:06 AM, Huang Shijie <b32955@freescale.com> wrote:
> On Mon, Apr 28, 2014 at 07:06:17AM +0200, Marek Vasut wrote:
>>
>> Two things competing over the same pointer looks misdesigned to me. I will need
>> to dig into this one more time ...
> Please refer to the code for NAND chip, the nand_get_flash_type() :
>
> -----------------------------------------------------------
>         /* Do not replace user supplied command function! */
>         if (mtd->writesize > 512 && chip->cmdfunc == nand_command)
>                 chip->cmdfunc = nand_command_lp;
> -----------------------------------------------------------
>
> It uses the same logic:
>         " Do not replace user supplied command function!"
>
> thanks
> Huang Shijie

I would like to set the @wait_till_ready in m25p80.c, because the
USE_FSR flag is only for Micron chips.  But the m25p80 driver doesn't
have access to the flags, they are contained in spi-nor.c.  It seems
to me that the driver_data should be accessible by the driver.  So
maybe there is room for improvement there.

Thanks,
Graham Moore
