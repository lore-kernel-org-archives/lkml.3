Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbaDWNb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:31:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51567 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaDWNbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:31:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        andriy.shevchenko@intel.com, Emilio Lopez <emilio@elopez.com.ar>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhuzhenhua@allwinnertech.com, Vinod Koul <vinod.koul@intel.com>,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 3/8] ARM: sunxi: Move the clock protection to machine hooks
Date: Wed, 23 Apr 2014 15:31:06 +0200
Message-ID: <4987444.Zp0Prbn0Y8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140423131720.GS24905@lukather>
References: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com> <201404231439.02913.arnd@arndb.de> <20140423131720.GS24905@lukather>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uFaCufJV0g6DK8mGXni72ZEKMW+yAjCArklVai0SS4E
 RBILcjzh+P1arNpdY/yOrcJ0cKeQfpl/WJfBalhaqq8RciOFRI
 X2ObJgtqr5qzl+gCc4ay0HOfaw3cCyuzn5333WhcoErLt47xxa
 obfNk2NfdYT5tuvghsVA96cyhaTP5xLv/WtCzdXmXl/E+xMn+D
 ciRNyQGhvHMLdaY90RG4Bt03G+FYmlYRWy5iF2h78nENdJQ/6T
 /XwvDkm8zEAmE2a1GcsgX3fnqpTuYY4rn0vx5S1Q9NYoAlg/xu
 XpGv8s1UQ+4LG4gLhzXXmAz4iCVWjtQTO+LPyGIcIuhpXCaFWN
 d+s66iPb6L7lAwjqebHE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2014 15:17:20 Maxime Ripard wrote:
> > > +#include <linux/clk.h>
> > >  #include <linux/init.h>
> > >  #include <linux/of_platform.h>
> > >  
> > > @@ -19,9 +20,17 @@
> > >  
> > >  static void __init sun4i_dt_init(void)
> > >  {
> > > +       struct clk *clk;
> > > +
> > >         sunxi_setup_restart();
> > >  
> > >         of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> > > +
> > > +       /* Make sure the clocks we absolutely need are enabled */
> > > +       /* DDR clock */
> > > +       clk = clk_get(NULL, "pll5_ddr");
> > > +       if (!IS_ERR(clk))
> > > +               clk_prepare_enable(clk);
> > >  }
> > 
> > Isn't there already DT syntax to do the same? If not, should there be?
> 
> I don't think there is, and I gave some thought about it too. But
> something a la regulator-always-on wouldn't work with clocks with
> multiple outputs (like pll5), because you might need to leave only one
> of the output enabled, but not the others, and I couldn't think of a
> nice way to do so.
> 
> If you have one, I'd be happy to implement it.

We had a discussion a while ago about encoding default settings for clock
providers in the clock provider nodes. I don't remember the details
unfortunately.

Mike, can you explain how this should be done?

	Arnd
