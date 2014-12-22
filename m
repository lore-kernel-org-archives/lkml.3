Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaLVAaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 19:30:21 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:54770 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaLVAaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 19:30:20 -0500
Date: Mon, 22 Dec 2014 01:30:11 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
To: Marek Vasut <marex@denx.de>
Cc: linux-kernel@vger.kernel.org, festevam@gmail.com, shawn.guo@linaro.org,
        mturquette@linaro.org, harald@ccbib.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <1033288193.576178.1419208211101.JavaMail.open-xchange@oxbaltgw03.schlund.de>
In-Reply-To: <201412212250.16007.marex@denx.de>
References: <1419169599-24791-1-git-send-email-stefan.wahren@i2se.com> <201412212250.16007.marex@denx.de>
Subject: Re: [PATCH] clk: mxs: Fix invalid 32-bit access to frac registers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.6.0-Rev33
X-Originating-Client: com.openexchange.ox.gui.dhtml
X-Provags-ID: V03:K0:FYOxzJ9TFLD6PxyDeTLZ1w8jGJ5LrTVZPCZW5LA/uIOq9S0XEFM
 5W03XEdkyqkNLFi2ilcHwX71zx+5Tu9fR51i4TPoICN0L62Houc419BoFHvH7g7LhlHDLma
 pH6ruvEkRdjcxO0cfdS/Bg4OSWpNyVhPzytlKj29uJwpF5c4qROJFyi9h0FOyN1LaWh4Lay
 ftUbAicpTzZPL3BRDhBvg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

> Marek Vasut <marex@denx.de> hat am 21. Dezember 2014 um 22:50 geschrieben:
>
>
> On Sunday, December 21, 2014 at 02:46:39 PM, Stefan Wahren wrote:
>
> Hi!
>
> [...]
>
> > diff --git a/drivers/clk/mxs/clk-ref.c b/drivers/clk/mxs/clk-ref.c
> > index 4adeed6..bdecec1 100644
> > --- a/drivers/clk/mxs/clk-ref.c
> > +++ b/drivers/clk/mxs/clk-ref.c
> > @@ -16,6 +16,8 @@
> > #include <linux/slab.h>
> > #include "clk.h"
> >
> > +#define BF_CLKGATE BIT(7)
> > +
> > /**
> > * struct clk_ref - mxs reference clock
> > * @hw: clk_hw for the reference clock
> > @@ -39,7 +41,7 @@ static int clk_ref_enable(struct clk_hw *hw)
> > {
> > struct clk_ref *ref = to_clk_ref(hw);
> >
> > - writel_relaxed(1 << ((ref->idx + 1) * 8 - 1), ref->reg + CLR);
> > + writeb(BF_CLKGATE, ref->reg + ref->idx + CLR);
>
> Should this be writeb_relaxed() maybe ?
>
> > return 0;
> > }
> > @@ -48,7 +50,7 @@ static void clk_ref_disable(struct clk_hw *hw)
> > {
> > struct clk_ref *ref = to_clk_ref(hw);
> >
> > - writel_relaxed(1 << ((ref->idx + 1) * 8 - 1), ref->reg + SET);
> > + writeb(BF_CLKGATE, ref->reg + ref->idx + SET);
>
> Same here and all around the place ?

okay, i will fix it in V2.

>
> Other than that, it looks pretty OK :)

Fine

>
> Best regards,
> Marek Vasut

Best regards
Stefan
