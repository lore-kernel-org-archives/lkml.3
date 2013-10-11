Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab3JKPsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:48:15 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27237 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758410Ab3JKPsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:48:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19oSpKaeOgcWpSAU8j/7vir
Date: Fri, 11 Oct 2013 08:48:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: Balaji T K <balajitk@ti.com>
Cc: Roger Quadros <rogerq@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
Message-ID: <20131011154804.GP29913@atomide.com>
References: <20131003054104.8941.88857.stgit@localhost>
 <20131003054221.8941.87801.stgit@localhost>
 <5256AA7F.8030005@ti.com>
 <20131010160018.GA29913@atomide.com>
 <CACRpkdaG-PQA39XSjKUgM9TyeD7srgm_8s+NazrDKJ0gmNLcwg@mail.gmail.com>
 <20131010162015.GC29913@atomide.com>
 <CACRpkdYF83ghUf60Wmrti53UJ1bWV30GW_P9GjWnsOcZHbsv+Q@mail.gmail.com>
 <5257BD3E.5000707@ti.com>
 <20131011153654.GN29913@atomide.com>
 <52581CA7.20606@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52581CA7.20606@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balaji T K <balajitk@ti.com> [131011 08:51]:
> On Friday 11 October 2013 09:06 PM, Tony Lindgren wrote:
> >>>What the pin control driver should do is control the pins. Whether the registers
> >>>are spread out in the entire IO-memory does not matter. We did have one system
> >>>which placed the IO-muxing together with each peripheral (!) and I did
> >>>still want
> >>>that to be handled by a single pinctrl driver picking out windows to all these
> >>>IO-ranges.
> >>>
> >>>Things like the PRM which has (my guess) a gazillion registers related to its
> >>>deep-core SoC stuff should be handled by things like
> >>>drivers/mfd/syscon.c, which means it is dead simple for some other driver
> >>>using "just this one register" in that range to get a handle at it and poke it
> >>>using syscon_node_to_regmap() (just derference an ampersand ref)
> >>>syscon_regmap_lookup_by_compatible() (use a compatible string)
> >>>all returning a regmap * that you can use to poke these registers.
> >>
> >>The register handling is fine. But how do we deal with resource handling?
> >>e.g. the block that has the deep-core registers might need to be clocked or powered
> >>before the registers can be accessed.
> >
> >Right, that's the key issue here. The register access would have to be conditional
> >based on the hardware modules PM state. Otherwise we'll have hard to trace hangs
> >and oopses.
> >
> Hi Tony,
> 
> How are the clocks/power state currently handled in case of omap4_pmx_core,
> omap4_pmx_wkup register access via pinctrl-single ?

It's currently always on during runtime and managed in for the whole SCM
by mach-omap2/control.c. Then there's a separate SCM register that triggers
the save and restore of the padconf registers in hardware for off-idle
along with other SCM related things, see the *_control_save/restore_context()
functions.

Regards,

Tony
