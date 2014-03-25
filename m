Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaCYTop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:44:45 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:37063 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaCYTon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:44:43 -0400
Date: Tue, 25 Mar 2014 20:43:59 +0100
From: Beniamino Galvani <b.galvani@gmail.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: rockchip: fix offset of mux registers for rk3188
Message-ID: <20140325194357.GA27520@gmail.com>
References: <1395700561-3793-1-git-send-email-b.galvani@gmail.com>
 <2790002.5U2DHYmUbK@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2790002.5U2DHYmUbK@diego>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 12:14:42AM +0100, Heiko Stübner wrote:
> Am Montag, 24. März 2014, 23:36:01 schrieb Beniamino Galvani:
> > The correct value of .mux_offset for rk3188 seems to be 0x60
> > instead of 0x68.
> 
> Executive summary: the offset-change itself is correct, therefore
> 
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> 
> That is what one gets when the only source is a vendor tree.
> I've looked it up again, and it seems you're right with the offset, but there 
> seems to be more to it ;-)
> 
> GPIO0 only has the second two IOMUX registers:
> - GRF_GPIO0C_IOMUX at 0x68
> - GRF_GPIO0D_IOMUX at 0x6c
> which I guess is where my mistake comes from.
> 
> It looks like there does no iomux register exist at all for the first 16 pins.
> 
> In any case, the current number is wrong, and the 0x60 offset is the correct 
> one, but I guess we need to determine what the affected pins do - do they 
> always have a gpio mux or such?

On radxa rock schematic pins GPIO0A* and GPIO0B* are labeled only as
gpios, without alternate functions like other pins; my guess is that
on rk3188 they can only act as gpios and so mux registers are not
needed for them.

Beniamino

> 
> Thanks for catching the mistake.
> 
> Heiko
> 
> > Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> > ---
> >  drivers/pinctrl/pinctrl-rockchip.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pinctrl/pinctrl-rockchip.c
> > b/drivers/pinctrl/pinctrl-rockchip.c index 46dddc1..23e8812 100644
> > --- a/drivers/pinctrl/pinctrl-rockchip.c
> > +++ b/drivers/pinctrl/pinctrl-rockchip.c
> > @@ -1534,7 +1534,7 @@ static struct rockchip_pin_ctrl rk3188_pin_ctrl = {
> >  		.nr_banks		= ARRAY_SIZE(rk3188_pin_banks),
> >  		.label			= "RK3188-GPIO",
> >  		.type			= RK3188,
> > -		.mux_offset		= 0x68,
> > +		.mux_offset		= 0x60,
> >  		.pull_calc_reg		= rk3188_calc_pull_reg_and_bit,
> >  };
> 
