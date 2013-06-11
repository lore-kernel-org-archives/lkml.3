Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3FKLwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:52:00 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:61336 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab3FKLv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:51:57 -0400
MIME-Version: 1.0
In-Reply-To: <201306111329.32749.heiko@sntech.de>
References: <201306111328.52679.heiko@sntech.de>
	<201306111329.32749.heiko@sntech.de>
Date: Tue, 11 Jun 2013 14:51:56 +0300
Message-ID: <CAHp75VcaNkPeUQ=OPY5F7Mqb_cM87xh8A8wUxdCgnRtfjoqoHw@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] clk: divider: add flag to limit possible dividers
 to even numbers
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 2:29 PM, Heiko Stübner <heiko@sntech.de> wrote:
> SoCs like the Rockchip Cortex-A9 ones contain divider some clocks
> that use the regular mechanisms for storage but allow only even
> dividers and 1 to be used.
>
> Therefore add a flag that lets _is_valid_div limit the valid dividers
> to these values. _get_maxdiv is also adapted to return even values
> for the CLK_DIVIDER_ONE_BASED case.

Just one nitpick below (I'm okay with current implementation, but you
might find my proposal useful).

> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c

> @@ -141,6 +149,8 @@ static bool _is_valid_div(struct clk_divider *divider, unsigned int div)
>                 return is_power_of_2(div);
>         if (divider->table)
>                 return _is_valid_table_div(divider->table, div);
> +       if (divider->flags & CLK_DIVIDER_EVEN && div != 1 && (div % 2) != 0)
> +               return false;
>         return true;
>  }

What if rewrite like

 if (divider->flags & CLK_DIVIDER_EVEN == 0)
 return true;

return div < 2 || div % 2 == 0;


--
With Best Regards,
Andy Shevchenko
