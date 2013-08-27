Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3H0IXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:23:37 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:46408 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3H0IXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:23:32 -0400
Date: Tue, 27 Aug 2013 09:23:26 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 21/33] clk: ux500: Add Device Tree support for the PRCC
 Kernel clock
Message-ID: <20130827082326.GE6152@lee--X1>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
 <1370521041-32318-22-git-send-email-lee.jones@linaro.org>
 <CACRpkdY2KOxX=oA7i9GUnzpwRKiK2rXqTBPVpg+zW082f2TJdg@mail.gmail.com>
 <20130821101448.GJ29850@lee--X1>
 <CACRpkdYjvFTJAUL6xKxjkVd_v=DHHRkswoB_eq0Npqj5Sw23KQ@mail.gmail.com>
 <20130822092130.GB22023@lee--X1>
 <CACRpkdYLJdmhCqXpQ0s5nbxRoFdZ3bLn+hxAhkoGHYfvugc=7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYLJdmhCqXpQ0s5nbxRoFdZ3bLn+hxAhkoGHYfvugc=7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013, Linus Walleij wrote:

> On Thu, Aug 22, 2013 at 11:21 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> >> I really do not like the approach of uglifying something and then
> >> beautifying it later... I prefer each step in isolation to be good
> >> looking, or you will be confused when traversing the history.
> >
> > So then we have a few options, some more realistic than others.
> >
> > 1. Duplicate each of the; clk_reg_prcmu_*(), clk_reg_prcc_pclk(),
> > clk_reg_prcc_kclk() calls into your proposed u8500_clk_init_dt(),
> > which, while keeping everything separate would be unrealistic.
> 
> I think this is perfectly realistic.
> 
> You're not going to duplicate each clk_register_clkdev(),
> which makes it way smaller than the original function,
> and since one of the function will be inside a
> 
> #ifdef CONFIG_OF
> #endif
> 
> After we switch the entire platform to DT-only it will be pretty
> obvious which big chunk of code that needs to go away, it's
> a clean cut.
> 
> (Note: I know the #ifdef CONFIG_OF is not necessary anymore
> since we switched to multiplatform, but I intend that marker for
> humans, not machines.)

This sounds gross. To duplicate; u8500_clk_init(), u8540_clk_init()
and u9540_clk_init() just for the sake of loading a few pointers into
an array for a small part of the development cycle sounds obscene.

I genuinely think keeping the current patch in this series and then
removing the clk_register_clkdev() in the remove ATAG support series
is the best way to go.

If you think I'm wrong then I'll so as you ask however. Just pass me
the sick bucket.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
