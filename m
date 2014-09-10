Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaIJPwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:52:07 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58135 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaIJPwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:52:03 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCH] clk: fractional-divider: cast parent_rate to u64 before multiplying
Date: Wed, 10 Sep 2014 17:54:16 +0200
Message-ID: <1689033.QyEHbUY0c9@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1585132.bTTmCCK9Ot@diego>
References: <3033670.TV3SpkKZGq@diego> <20140902002629.5251.42667@quantum> <1585132.bTTmCCK9Ot@diego>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Am Dienstag, 2. September 2014, 09:33:21 schrieb Heiko Stübner:
> Am Montag, 1. September 2014, 17:26:29 schrieb Mike Turquette:
> > Quoting Heiko Stübner (2014-08-28 03:46:10)
> > 
> > > On 32bit architectures, like ARM calculating the fractional rate will
> > > do the multiplication before converting the value to u64 when it gets
> > > assigned to ret, which can produce overflows.
> > > 
> > > The error in question happened with a parent_rate of 386MHz, m = 3000,
> > > n = 60000, which resulted in a wrong rate value of 15812Hz.
> > > 
> > > Therefore cast parent_rate to u64 to make sure the multiplication
> > > happens in a 64bit space and produces the correct 192MHz in the example.
> > > 
> > > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > 
> > Looks good to me. Have you observed this issue using the vanilla
> > kernel.org sources or on a downstream tree? I'm trying to decide if I
> > should take this into clk-fixes or clk-next.
> > 
> > If this doesn't happen in practice on any merged platform then I'll take
> > it for 3.18.
> 
> It happens on the Rockchip platform with the newly added fractional branches
> you just applied ... so it doesn't look like anybody else is affected right
> now.

will you take this one into clk-next?


Thanks
Heiko


> 
> 
> Heiko
> 
> > Regards,
> > Mike
> > 
> > > ---
> > > 
> > >  drivers/clk/clk-fractional-divider.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/clk/clk-fractional-divider.c
> > > b/drivers/clk/clk-fractional-divider.c index ede685c..82a59d0 100644
> > > --- a/drivers/clk/clk-fractional-divider.c
> > > +++ b/drivers/clk/clk-fractional-divider.c
> > > @@ -36,7 +36,7 @@ static unsigned long clk_fd_recalc_rate(struct clk_hw
> > > *hw,>
> > > 
> > >         m = (val & fd->mmask) >> fd->mshift;
> > >         n = (val & fd->nmask) >> fd->nshift;
> > > 
> > > -       ret = parent_rate * m;
> > > +       ret = (u64)parent_rate * m;
> > > 
> > >         do_div(ret, n);
> > >         
> > >         return ret;

