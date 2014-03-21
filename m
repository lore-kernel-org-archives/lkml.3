Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036AbaCUAO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:14:29 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58165 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966188AbaCUAJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20140305112828.GN24917@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
References: <1389885175-14174-1-git-send-email-s.hauer@pengutronix.de>
 <20140305112828.GN24917@pengutronix.de>
Message-ID: <20140321000930.21989.11808@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: turn rate change failed warning into pr_debug
Date: Thu, 20 Mar 2014 17:09:30 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sascha Hauer (2014-03-05 03:28:28)
> Mike,
> 
> Any objections to this patch?

None at all. Taken into clk-next.

Thanks,
Mike

> 
> Sascha
> 
> On Thu, Jan 16, 2014 at 04:12:55PM +0100, Sascha Hauer wrote:
> > If a rate change failed it's the opportunity of the caller to handle
> > this. Do not spam the log with a message.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Mike Turquette <mturquette@linaro.org>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/clk/clk.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> > index 2cf2ea6..f0124d4 100644
> > --- a/drivers/clk/clk.c
> > +++ b/drivers/clk/clk.c
> > @@ -1460,7 +1460,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
> >       /* notify that we are about to change rates */
> >       fail_clk = clk_propagate_rate_change(top, PRE_RATE_CHANGE);
> >       if (fail_clk) {
> > -             pr_warn("%s: failed to set %s rate\n", __func__,
> > +             pr_debug("%s: failed to set %s rate\n", __func__,
> >                               fail_clk->name);
> >               clk_propagate_rate_change(top, ABORT_RATE_CHANGE);
> >               ret = -EBUSY;
> > -- 
> > 1.8.5.2
> > 
> > 
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
