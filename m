Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbaCTQkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:40:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51211 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752923AbaCTQkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:40:16 -0400
Date: Thu, 20 Mar 2014 17:40:04 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: at91: panic when the mck rate is zero
Message-ID: <20140320164003.GV12021@piout.net>
References: <1395332062-4967-1-git-send-email-alexandre.belloni@free-electrons.com>
 <532B1881.2050409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <532B1881.2050409@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/2014 at 17:34:09 +0100, Boris BREZILLON wrote :
> Le 20/03/2014 17:14, Alexandre Belloni a écrit :
> >If the mck rate is zero, we'll hit the following warning:
> >
> >WARNING: CPU: 0 PID: 0 at arch/arm/mach-at91/at91sam926x_time.c:257 at91sam926x_pit_init+0x13c/0x260()
> >
> >But the kernel will continue to try booting and face a lot of divisions by zero
> >when trying to handle the various clocks.
> >
> >Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> >---
> >  arch/arm/mach-at91/at91sam926x_time.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> >diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
> >index 0f04ffe9c5a8..f060f6371392 100644
> >--- a/arch/arm/mach-at91/at91sam926x_time.c
> >+++ b/arch/arm/mach-at91/at91sam926x_time.c
> >@@ -250,6 +250,8 @@ void __init at91sam926x_pit_init(void)
> >  	if (IS_ERR(mck))
> >  		panic("AT91: PIT: Unable to get mck clk\n");
> >  	pit_rate = clk_get_rate(mck) / 16;
> >+	if (pit_rate == 0)
> >+		panic("AT91: PIT: can't continue, mck rate is zero\n");
> You're testing pit_rate why not printing:
> 
> "AT91: PIT: can't continue, *pit* rate is zero\n"
> 

pit_rate is zero because mck is zero I just didn't want to introduce a
new variable or another call to clk_get_rate(mck). I don't have any
strong opinion about that either so I can definitely make that change.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
