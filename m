Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaI3Q6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:58:12 -0400
Received: from gloria.sntech.de ([95.129.55.99]:51461 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbaI3Q6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:58:11 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>, linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: rk808: Fix min_uV for DCDC1 & DCDC2
Date: Tue, 30 Sep 2014 18:57:51 +0200
Message-ID: <1716911.pj5CzLpxUR@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAD=FV=XViSBFyMEY9kQBMggnn+uA0wYarbseFOuZeakzBxZeqA@mail.gmail.com>
References: <1412070294-5535-1-git-send-email-zyw@rock-chips.com> <CAD=FV=XViSBFyMEY9kQBMggnn+uA0wYarbseFOuZeakzBxZeqA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 30. September 2014, 09:43:47 schrieb Doug Anderson:
> Chris,
> 
> On Tue, Sep 30, 2014 at 2:44 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> > The min_uv in DCDC1 & DCDC2 should be 712.5mv
> > 
> > Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> > 
> > ---
> > 
> >  drivers/regulator/rk808-regulator.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/regulator/rk808-regulator.c
> > b/drivers/regulator/rk808-regulator.c index e305416..196a5c8 100644
> > --- a/drivers/regulator/rk808-regulator.c
> > +++ b/drivers/regulator/rk808-regulator.c
> > @@ -44,7 +44,7 @@ static const int rk808_buck_config_regs[] = {
> > 
> >  };
> >  
> >  static const struct regulator_linear_range rk808_buck_voltage_ranges[] =
> >  {
> > 
> > -       REGULATOR_LINEAR_RANGE(700000, 0, 63, 12500),
> > +       REGULATOR_LINEAR_RANGE(712500, 0, 63, 12500),
> > 
> >  };
> 
> I have no problem with this (and the current "dts" file I see don't go
> this low anyway), but it doesn't match the datasheet I have right now
> which says "0.700 V" is the min.

Then it would be problem.

The original statement above says, that a register value of "0" equals 700mV, 
so changing this in this way would mean everything runs 12.5mV above the 
target voltage.

And I can confirm, that the current datasheet lists 700mV as equallying 
register value 0.


