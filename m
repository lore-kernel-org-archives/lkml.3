Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaDNQVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:21:43 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:54052 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaDNQT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:19:26 -0400
MIME-Version: 1.0
In-Reply-To: <201404131918.45753.marex@denx.de>
References: <1397228593-17996-1-git-send-email-grmoore@altera.com>
	<201404131918.45753.marex@denx.de>
Date: Mon, 14 Apr 2014 11:19:24 -0500
Message-ID: <CA+iBjpSHL0+A=wzhhVvT_y+mhZoFNLUkNe18OtxPn1hZVCdUDw@mail.gmail.com>
Subject: Re: [PATCH V2] Add support for flag status register on Micron chips.
From: Graham Moore <ggrahammoore@gmail.com>
To: Marek Vasut <marex@denx.de>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 12:18 PM, Marek Vasut <marex@denx.de> wrote:
[...]
>> +#define      OPCODE_RDFSR            0x70  /* read flag status register */
>
> I know this is not your fault, but can you please indent this properly with
> tabs?
>
>>  #define      OPCODE_NORM_READ        0x03    /* Read data bytes (low
> frequency) */
>>  #define      OPCODE_FAST_READ        0x0b    /* Read data bytes (high
> frequency) */
>>  #define      OPCODE_QUAD_READ        0x6b    /* Read data bytes */
>
> And fix this one in a separate patch to use tabs as well please ?

I'm rebasing on l2-mtd spinor, and the tabs are jacked up there too.
I'll fix the
one I added, and fix other tabs in a new patch on that branch.

[...]
> I wonder, can't wait_till_ready() be made a wrapper that will check the USE_FSR
> flag and call correct wait-function ? This would avoid adding a new member to
> *flash and also would avoid so many changes throughout the code. What do you
> think?

Yeah, that's kind of ugly, but the flags exist only in the static
m25p_ids[] and are only
used in the scan/init.  I'd have to add a new member to save them for
later use.
And then other uses would crop up.  So, seemed kinda iffy either way.

It's going to change anyway, because l2-mtd spinor branch has refactored
wait_till_ready() such that it uses a function pointer from the new
spi_nor struct.
I'm still mulling it over :)

Thanks,
-Graham
