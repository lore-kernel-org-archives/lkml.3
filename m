Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab3BARLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 12:11:32 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:43611 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756673Ab3BARL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 12:11:29 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+GmV18yzNlJk+/Gr2RcCoQ
Date: Fri, 1 Feb 2013 09:11:24 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        sameo@linux.intel.com, linux-doc@vger.kernel.org,
        khilman@deeprootsystems.com, devicetree-discuss@lists.ozlabs.org,
        broonie@opensource.wolfsonmicro.com, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com, hs@denx.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 1/6] pinctrl: pinctrl-single: use arch_initcall and
 module_exit
Message-ID: <20130201171124.GF22517@atomide.com>
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
 <1359445134-13323-2-git-send-email-manishv.b@ti.com>
 <CACRpkdbf7TwrjfT2rhqQFGc3yh_Nt117RtzQO2y6g5Ddx5Ay_w@mail.gmail.com>
 <20130201170906.GE22517@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201170906.GE22517@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [130201 09:12]:
> * Linus Walleij <linus.walleij@linaro.org> [130129 03:03]:
> > On Tue, Jan 29, 2013 at 8:38 AM, Vishwanathrao Badarkhe, Manish
> > <manishv.b@ti.com> wrote:
> > 
> > > Currently, I2C driver gets probed before pinctrl driver.
> > > To achieve I2C pin muxing via pinctrl driver before I2C
> > > probe get called, register pinctrl driver in arch_initcall.
> > > Also, add module_exit to unregister pinctrl driver.
> > >
> > > Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> > 
> > So your I2C driver is not returning -EPROBE_DEFER
> > if it cannot find its pins?
> > 
> > Hm, well I can live with this, if Tony ACKs it.
> 
> Hmm pinctrl is before i2c in drivers/Makefile.
> Making initcalls happen earlier and earlier is usually the
> wrong way to go. Sounds like there's some other issue here
> that needs to be fixed instead.

Let me guess: The i2c driver is wrongly set to run with
arch_initcall?
 
> Regards,
> 
> Tony
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
