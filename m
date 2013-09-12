Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3ILO46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:56:58 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:36007 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3ILO44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:56:56 -0400
Date: Thu, 12 Sep 2013 15:56:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 21/33] clk: ux500: Add Device Tree support for the PRCC
 Kernel clock
Message-ID: <20130912145651.GJ11227@lee--X1>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
 <1370521041-32318-22-git-send-email-lee.jones@linaro.org>
 <CACRpkdY2KOxX=oA7i9GUnzpwRKiK2rXqTBPVpg+zW082f2TJdg@mail.gmail.com>
 <20130821101448.GJ29850@lee--X1>
 <CACRpkdYjvFTJAUL6xKxjkVd_v=DHHRkswoB_eq0Npqj5Sw23KQ@mail.gmail.com>
 <20130822092130.GB22023@lee--X1>
 <CACRpkdYLJdmhCqXpQ0s5nbxRoFdZ3bLn+hxAhkoGHYfvugc=7A@mail.gmail.com>
 <20130827082326.GE6152@lee--X1>
 <CACRpkdYvAfEh6UGa7qR_e9ynj3TkPSM2RKtr7Scw7L3p10AgXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYvAfEh6UGa7qR_e9ynj3TkPSM2RKtr7Scw7L3p10AgXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Linus Walleij wrote:

> On Tue, Aug 27, 2013 at 10:23 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Fri, 23 Aug 2013, Linus Walleij wrote:
> >> On Thu, Aug 22, 2013 at 11:21 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> >> > 1. Duplicate each of the; clk_reg_prcmu_*(), clk_reg_prcc_pclk(),
> >> > clk_reg_prcc_kclk() calls into your proposed u8500_clk_init_dt(),
> >> > which, while keeping everything separate would be unrealistic.
> >>
> >> I think this is perfectly realistic.
> >>
> >> You're not going to duplicate each clk_register_clkdev(),
> >> which makes it way smaller than the original function,
> >> and since one of the function will be inside a
> >>
> >> #ifdef CONFIG_OF
> >> #endif
> >>
> >> After we switch the entire platform to DT-only it will be pretty
> >> obvious which big chunk of code that needs to go away, it's
> >> a clean cut.
> >>
> >> (Note: I know the #ifdef CONFIG_OF is not necessary anymore
> >> since we switched to multiplatform, but I intend that marker for
> >> humans, not machines.)
> >
> > This sounds gross. To duplicate; u8500_clk_init(), u8540_clk_init()
> > and u9540_clk_init() just for the sake of loading a few pointers into
> > an array for a small part of the development cycle sounds obscene.
> >
> > I genuinely think keeping the current patch in this series and then
> > removing the clk_register_clkdev() in the remove ATAG support series
> > is the best way to go.
> 
> So what I am worrying about is not only the looks of the code
> and what is beautiful or not may be something of an opinion
> anway.
> 
> What I worry about is leaving all the calls to clk_register_clkdev()
> in the DT boot path. Because that has the potential to hide a lot
> of bugs, as clk_get() from drivers that should've got named and
> probed randomly now will still find their clocks from their old
> device names, instead of using the <&ampersand> clocks from
> the device tree.
> 
> But if you still don't like this, let me cook a counter-patch so
> I can realized on my own how terribly wrong I am...

I'm going to yank all of the clk_register_clkdev() calls out
imminently anyway, so all those these hiding bugs will soon become
apparent in any case. Why don't I place my 'remove ATAGs' patch-set
on top of this one and then finally remove the clk_register_clkdev()s
and watch the carnage ensue?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
