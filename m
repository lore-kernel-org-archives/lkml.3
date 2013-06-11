Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3FKMG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:06:27 -0400
Received: from gloria.sntech.de ([95.129.55.99]:38930 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab3FKMGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:06:25 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v3 1/7] clk: divider: add flag to limit possible dividers to even numbers
Date: Tue, 11 Jun 2013 14:06:14 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
References: <201306111328.52679.heiko@sntech.de> <201306111329.32749.heiko@sntech.de> <CAHp75VcaNkPeUQ=OPY5F7Mqb_cM87xh8A8wUxdCgnRtfjoqoHw@mail.gmail.com>
In-Reply-To: <CAHp75VcaNkPeUQ=OPY5F7Mqb_cM87xh8A8wUxdCgnRtfjoqoHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201306111406.14850.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 11. Juni 2013, 13:51:56 schrieb Andy Shevchenko:
> On Tue, Jun 11, 2013 at 2:29 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > SoCs like the Rockchip Cortex-A9 ones contain divider some clocks
> > that use the regular mechanisms for storage but allow only even
> > dividers and 1 to be used.
> > 
> > Therefore add a flag that lets _is_valid_div limit the valid dividers
> > to these values. _get_maxdiv is also adapted to return even values
> > for the CLK_DIVIDER_ONE_BASED case.
> 
> Just one nitpick below (I'm okay with current implementation, but you
> might find my proposal useful).
> 
> > --- a/drivers/clk/clk-divider.c
> > +++ b/drivers/clk/clk-divider.c
> > 
> > @@ -141,6 +149,8 @@ static bool _is_valid_div(struct clk_divider
> > *divider, unsigned int div)
> > 
> >                 return is_power_of_2(div);
> >         
> >         if (divider->table)
> >         
> >                 return _is_valid_table_div(divider->table, div);
> > 
> > +       if (divider->flags & CLK_DIVIDER_EVEN && div != 1 && (div % 2) !=
> > 0) +               return false;
> > 
> >         return true;
> >  
> >  }
> 
> What if rewrite like
> 
>  if (divider->flags & CLK_DIVIDER_EVEN == 0)
>  return true;
> 
> return div < 2 || div % 2 == 0;

hmm, the current structure is of the form of testing for each feature and 
doing a applicable action if the flag is set. So it also is extensible for 
future flags and checking for the absence of an attribute while the rest of 
the conditionals check for the presence also might make the code harder to 
read.

So for me the current variant somehow looks more intuitive.

But I'll just let the majority decide ;-)


Heiko
