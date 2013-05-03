Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875Ab3ECJDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:03:42 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:61995 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762852Ab3ECJDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:03:15 -0400
Date: Fri, 3 May 2013 11:03:05 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] clk: ux500: clk-sysctrl: handle clocks with no parents
Message-ID: <20130503090305.GA17733@balto.lan>
References: <1367325906-23045-1-git-send-email-fabio.baltieri@linaro.org>
 <CAPDyKFpZ+-6b3kPyNacPQ33=Ssdjs=fvFxkr4iSUT_hm1YzVTg@mail.gmail.com>
 <CAPDyKFq6iQ21QosEH_WqGCetXfaO1uecvK7+WzjZJDkK8r3SxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFq6iQ21QosEH_WqGCetXfaO1uecvK7+WzjZJDkK8r3SxA@mail.gmail.com>
X-Operating-System: Linux balto 3.9.0-rc8-00030-g4cbbd1d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 10:54:09AM +0200, Ulf Hansson wrote:
> On 3 May 2013 10:51, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> > On 30 April 2013 14:45, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> >> Fix clk_reg_sysctrl() to set main clock registers of new struct
> >> clk_sysctrl even if the registered clock has no parents.
> >>
> >> This fixes an issue where "ulpclk" was registered with all clk->reg_*
> >> fields uninitialized, causing a -EINVAL error from clk_prepare().
> >>
> >> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> >> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> >> ---
> >>  drivers/clk/ux500/clk-sysctrl.c | 8 +++++++-
> >>  1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/clk/ux500/clk-sysctrl.c b/drivers/clk/ux500/clk-sysctrl.c
> >> index bc7e9bd..e364c9d 100644
> >> --- a/drivers/clk/ux500/clk-sysctrl.c
> >> +++ b/drivers/clk/ux500/clk-sysctrl.c
> >> @@ -145,7 +145,13 @@ static struct clk *clk_reg_sysctrl(struct device *dev,
> >>                 return ERR_PTR(-ENOMEM);
> >>         }
> >>
> >> -       for (i = 0; i < num_parents; i++) {
> >> +       /* set main clock registers */
> >> +       clk->reg_sel[0] = reg_sel[0];
> >> +       clk->reg_bits[0] = reg_bits[0];
> >> +       clk->reg_mask[0] = reg_mask[0];
> >> +
> >> +       /* handle clocks with more than one parent */
> >> +       for (i = 1; i < num_parents; i++) {
> >>                 clk->reg_sel[i] = reg_sel[i];
> >>                 clk->reg_bits[i] = reg_bits[i];
> >>                 clk->reg_mask[i] = reg_mask[i];
> >> --
> >> 1.8.2
> >>
> >
> > Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> >
> > This is bugfix, should go "stable" as well?
> 
> Stable means 3.10 rcs, since the abx500 clk tree was added for 3.10.

Thanks!  Yes, it would be great if this could be queued up for an -rc.

Fabio

-- 
Fabio Baltieri
