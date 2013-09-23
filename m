Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3IWS4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:56:19 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61705 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab3IWS4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:56:18 -0400
Date: Mon, 23 Sep 2013 11:56:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Fan Rong <cinifr@gmail.com>, coosty@163.com, daniel.lezcano@linaro.org,
        linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/3] Add smp support for Allwinner A20(sunxi 7i).
Message-ID: <20130923185613.GA30198@roeck-us.net>
References: <1379768716-11672-1-git-send-email-cinifr@gmail.com>
 <1379768716-11672-2-git-send-email-cinifr@gmail.com>
 <20130921140059.GA2779@lukather>
 <523FB773.4050408@roeck-us.net>
 <20130923181917.GS2779@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923181917.GS2779@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 09:19:17PM +0300, Maxime Ripard wrote:
> Hi Guenter,
> 
> On Sun, Sep 22, 2013 at 08:37:23PM -0700, Guenter Roeck wrote:
> > On 09/21/2013 07:00 AM, Maxime Ripard wrote:
> > 
> > [ ... ]
> > 
> > >>+	/* assert cpu core reset */
> > >>+	writel(0, sunxi7i_cc_base + CPUX_RESET_CTL(cpu));
> > >>+	/* L1RSTDISABLE hold low */
> > >>+	pwr_reg = readl(sunxi7i_cc_base + AW_CPUCFG_GENCTL);
> > >>+	pwr_reg &= ~(1<<cpu);
> > >>+	writel(pwr_reg, sunxi7i_cc_base + AW_CPUCFG_GENCTL);
> > >>+	/* DBGPWRDUP hold low */
> > >>+	pwr_reg = readl(sunxi7i_cc_base + AW_CPUCFG_DBGCTL1);
> > >>+	pwr_reg &= ~(1<<cpu);
> > >
> > >Use BIT(cpu) here. And you should run scripts/checkpatch.pl on your
> > >patches before sending them.
> > >
> > 
> > For the record:
> > 
> > $ scripts/checkpatch.pl --strict allwinner.patch
> > total: 0 errors, 0 warnings, 0 checks, 527 lines checked
> > 
> > allwinner.patch has no obvious style problems and is ready for submission.
> > 
> > This is on top of "v3.12-rc1-336-gd8524ae".
> > 
> > checkpatch.pl does not complain as long as the number of spaces before
> > and after an operator is the same. There is a patch pending to change
> > this with the --strict option, but it will still not complain in 'normal'
> > operation.
> 
> Hmmm, ok. Somehow, I was convinced that it was triggering a warning.
> Thanks for the heads up :)
> 
Yes, me too until I realized that it doesn't :(.

Guenter
