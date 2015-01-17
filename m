Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbbAQVpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 16:45:45 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:65413 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbbAQVpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 16:45:44 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Boyd <sboyd@codeaurora.org>,
        "Stanimir Varbanov" <svarbanov@mm-sol.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <54AAE748.9010200@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, "Tomeu Vizoso" <tomeu.vizoso@collabora.com>
References: <1420473863-30696-1-git-send-email-svarbanov@mm-sol.com>
 <54AAE748.9010200@codeaurora.org>
Message-ID: <20150117214535.22722.64996@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: fix possible null pointer dereference
Date: Sat, 17 Jan 2015 13:45:35 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Boyd (2015-01-05 11:34:32)
> On 01/05/2015 08:04 AM, Stanimir Varbanov wrote:
> > The commit 646cafc6 (clk: Change clk_ops->determine_rate to
> > return a clk_hw as the best parent) opens a possibility for
> > null pointer dereference, fix this.
> >
> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> 
> Yep. Hopefully we can clean this all up soon.
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Applied to clk-fixes.

Regards,
Mike

> 
> > ---
> >  drivers/clk/clk.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> > index f4963b7..d48ac71 100644
> > --- a/drivers/clk/clk.c
> > +++ b/drivers/clk/clk.c
> > @@ -1366,7 +1366,7 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
> >               new_rate = clk->ops->determine_rate(clk->hw, rate,
> >                                                   &best_parent_rate,
> >                                                   &parent_hw);
> > -             parent = parent_hw->clk;
> > +             parent = parent_hw ? parent_hw->clk : NULL;
> >       } else if (clk->ops->round_rate) {
> >               new_rate = clk->ops->round_rate(clk->hw, rate,
> >                                               &best_parent_rate);
> 
> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
