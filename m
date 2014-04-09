Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbaDIKHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:07:23 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:54603 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbaDIKHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:07:19 -0400
X-Auth-Info: pl+OQV9d+GQ6AJ+iUAMV35B96jJcIhgJQyUHLDHW1og=
From: Marek Vasut <marex@denx.de>
To: grmoore@altera.com
Subject: Re: [PATCH] Add support for flag status register on Micron chips
Date: Wed, 9 Apr 2014 12:03:24 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: ggrahammoore@gmail.com, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Insop Song <insop.song@gainspeed.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Gerhard Sittig <gsi@denx.de>
References: <1396973570-13995-1-git-send-email-grmoore@altera.com>
In-Reply-To: <1396973570-13995-1-git-send-email-grmoore@altera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404091203.24956.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 08, 2014 at 06:12:49 PM, grmoore@altera.com wrote:
> From: Graham Moore <grmoore@altera.com>
> 
> This is a slightly different version of the patch that Insop Song
> submitted
> (http://marc.info/?i=201403012022.10111.marex%20()%20denx%20!%20de).
> 
> I talked to Insop, and he agreed I should submit this patch as a follow-on
> to his.
> 
> This patch uses a flag in the m25p_ids[] array to determine which chips
> need to use the FSR (Flag Status Register).
> 
> Rationale for using the FSR:
> 
> The Micron data sheets say we have to do this, at least for the multi-die
> 512M and 1G parts (n25q512 and n25q00).  In practice, if we don't check
> the FSR for program/erase status, and we rely solely on the status
> register (SR), then we get corrupted data in the flash.

I talked to Gerhard yesterday and he told me there is something like that on 
ONFI NAND. I think I now understand why that new register is in-place. 
Apparently, in the ONFI NAND case, there is a READY and TRUE-READY signal and 
one of those reflects that _all_ the dies have finished their operation. This is 
in my opinion seriously misdesigned as it breaks any kind of backward 
compatibility.

> Micron told us (Altera) that for multi-die chips based on the 65nm 256MB
> die, we need to check the SR first, then check the FSR, which is why the
> wait_for_fsr_ready function does that.  Future chips based on 45 nm 512MB
> die will use the FSR only.

Can these SPI flash makers screw the design even more? OT: Why don't we have a 
single standard for all the SF chips which won't need all these crappy quirks 
:-(

Best regards,
Marek Vasut
