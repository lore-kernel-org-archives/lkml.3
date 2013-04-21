Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3DUIzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 04:55:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35650 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3DUIzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 04:55:38 -0400
Date: Sun, 21 Apr 2013 09:54:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jongsung Kim <neidhard.kim@lge.com>, Greg KH <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH] ARM: PL011: add support for extended FIFO-size
	of PL011-r1p5
Message-ID: <20130421085442.GE14496@n2100.arm.linux.org.uk>
References: <201304151445.25151.neidhard.kim@lge.com> <CACRpkdbG4q54=j6nbxPmuSOG77zato5StSHdNQ1bSkCmvuQUvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbG4q54=j6nbxPmuSOG77zato5StSHdNQ1bSkCmvuQUvQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 20, 2013 at 03:31:39PM +0200, Linus Walleij wrote:
> static struct amba_id pl011_ids[] = {
>         {
>                 .id     = 0x00341011,
>                 .mask   = 0x00ffffff,
>                 .data   = &vendor_arm_deepfifo,
>         },
> (...)
> };
> 
> As you can see in amba_lookup() in
> drivers/amba/bus.c the table is traversed from the top,
> so for the new "3" variant this entry will match, while the
> next entry will match all older versions.

This isn't equivalent - this will only match variant 3, not any later
ones.  The original patch uses the deep fifo for variant 3 or larger.
