Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab3CNEsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:48:45 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:41690 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3CNEso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:48:44 -0400
MIME-Version: 1.0
In-Reply-To: <1363229965-13128-1-git-send-email-b32955@freescale.com>
References: <1363229965-13128-1-git-send-email-b32955@freescale.com>
Date: Wed, 13 Mar 2013 21:48:42 -0700
Message-ID: <CAN8TOE9XBphuTY6h_fgBaSfrFRVg0ZuG+9OxDYR+yvfJn1CcGQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] mtd: use the full-id as the keyword for some nand chips
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 7:59 PM, Huang Shijie <b32955@freescale.com> wrote:
> As time goes on, we begin to meet the situation that we can not
> get enough information from some nand chips's id data.
> Take some Toshiba's nand chips for example.
> I have 4 Toshiba's nand chips in my hand:
>         TC58NVG2S0F, TC58NVG3S0F, TC58NVG5D2, TC58NVG6D2
>
> When we read these chips' datasheets, we will get the geometry of these chips:
>         TC58NVG2S0F : 4096 + 224
>         TC58NVG3S0F : 4096 + 232
>         TC58NVG5D2  : 8192 + 640
>         TC58NVG6D2  : 8192 + 640
>
> But we can not parse out the correct oob size for these chips from the id data.
> So it is time to add some new fields to the nand_flash_dev{},
> and update the detection mechanisms.
>
> v4 --> v4:
>         [1] remove the id_len field.
>         [2] based on Artem "mtd: nand: use more reasonable integer types"
>         [3] add more comments.

Sorry for not posting this earlier, but why don't we want an id_len
field? NAND chips often only have a 5-byte or 6-byte ID "defined" in
their datasheet, and so the next few bytes aren't guaranteed to be any
particular value. Wouldn't we want to accommodate for any potential
variation in the "undefined" bytes? (These bytes do typically have a
pattern, and in fact, we currently rely on that fact.) Also, I can
easily foresee a situation in which someone might want to support NAND
based solely on the datasheet, not waiting till they get a sample of
that chip in their hands. In that case, they cannot specify a full 8
bytes in the table; they can (and should) only specify the few
substring found in their datasheet.

Really, the only argument I see for dropping id_len is to save space.
I think this is a bad choice.

... <snip> ...

Brian
