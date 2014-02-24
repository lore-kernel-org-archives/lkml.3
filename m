Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaBXBNm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 20:13:42 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46596 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaBXBNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 20:13:41 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Matt Porter <mporter@linaro.org>, "Alex Elder" <elder@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20140220205615.GF5038@beef>
Cc: bcm@fixthebug.org, "Tim Kryger" <tim.kryger@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1392402560-12929-1-git-send-email-elder@linaro.org>
 <1392402560-12929-3-git-send-email-elder@linaro.org>
 <20140220205615.GF5038@beef>
Message-ID: <20140224011335.22529.77418@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2 2/3] clk: bcm281xx: don't disable unused peripheral clocks
Date: Sun, 23 Feb 2014 17:13:35 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Matt Porter (2014-02-20 12:56:15)
> On Fri, Feb 14, 2014 at 12:29:19PM -0600, Alex Elder wrote:
> > Add the CLK_IGNORE_UNUSED flag when setting up a peripheral clock.
> > This prevents unused clocks from getting disabled, and by doing
> > this we can use the common clock code even before we've resolved
> > all the spots that need to get a reference to their clock.
> > 
> > Signed-off-by: Alex Elder <elder@linaro.org>
> > Reviewed-by: Matt Porter <mporter@linaro.org>
> 
> Mike: if you'll provide your ack on this patch, we would like to take
> the entire series through arm-soc for 3.15 as we originally agreed
> for 3.14. Patches 1 and 3 are the original two you acked for 3.14
> but had to be dropped late in the merge window.

Acked-by: Mike Turquette <mturquette@linaro.org>

> 
> Thanks,
> Matt
> 
> > ---
> >  drivers/clk/bcm/clk-kona-setup.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
> > index f1e88fe..c7607fe 100644
> > --- a/drivers/clk/bcm/clk-kona-setup.c
> > +++ b/drivers/clk/bcm/clk-kona-setup.c
> > @@ -579,7 +579,7 @@ static int peri_clk_setup(struct ccu_data *ccu, struct peri_clk_data *data,
> >                       struct clk_init_data *init_data)
> >  {
> >       init_data->ops = &kona_peri_clk_ops;
> > -     init_data->flags = 0;
> > +     init_data->flags = CLK_IGNORE_UNUSED;
> >  
> >       return clk_sel_setup(data->clocks, &data->sel, init_data);
> >  }
> > -- 
> > 1.7.9.5
> > 
