Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864Ab3FCUHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:07:31 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61576 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab3FCUH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:07:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <201306032133.20039.heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
References: <1370281990-15090-1-git-send-email-mturquette@linaro.org>
 <1370281990-15090-3-git-send-email-mturquette@linaro.org>
 <201306032133.20039.heiko@sntech.de>
Message-ID: <20130603200722.6077.85426@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RFC 2/3] clk: dt: binding for basic multiplexor clock
Date: Mon, 03 Jun 2013 13:07:22 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Heiko Stübner (2013-06-03 12:33:19)
> Hi Mike,
> 
> I think it's a multiplexEr clock in the patch title, and see below
> 

Doh, you are right.  But "xor" is so much cooler looking than "xer"...

> 
> Am Montag, 3. Juni 2013, 19:53:09 schrieb Mike Turquette:
> > Device Tree binding for the basic clock multiplexor, plus the setup
> > function to register the clock.  Based on the existing fixed-clock
> > binding.
> > 
> > Also relocate declaration of of_fixed_factor_clk_setup to keep things
> > tidy.
> > 
> > Signed-off-by: Mike Turquette <mturquette@linaro.org>
> 
> [...]
> 
> > +
> > +     reg = of_iomap(node, 0);
> > +     pr_err("%s: reg is 0x%p\n", __func__, reg);
> > +
> > +     if (of_property_read_u32(node, "mask", &mask)) {
> > +             pr_err("%s: missing mask property for %s\n", __func__, node->name);
> > +             return;
> > +     }
> > +
> > +     if (of_property_read_u32(node, "shift", &shift))
> > +             pr_debug("%s: missing shift property defaults to zero for %s\n",
> > +                             __func__, node->name);
> > +
> > +     if (of_property_read_bool(node, "index_one"))
> > +             clk_mux_flags |= CLK_MUX_INDEX_ONE;
> > +
> > +     clk = clk_register_mux_table(NULL, clk_name, parent_names, num_parents,
> > +                     0, reg, 0, mask, clk_mux_flags,
> 
>                       ^- should probably be shift
> 
> 
> Otherwise looks cool and I'm currently trying it with my Rockchip code.
> 

Right again.  My test platform seems to not shift the mask at all so
this did not cause a visible bug for me.

Thanks for the review,
Mike

> 
> Heiko
