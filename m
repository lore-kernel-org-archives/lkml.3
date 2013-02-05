Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3BEL2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:28:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35587 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3BEL2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:28:02 -0500
Date: Tue, 5 Feb 2013 11:27:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Linus Walleij <linus.walleij@linaro.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "hs@denx.de" <hs@denx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 1/6] pinctrl: pinctrl-single: use arch_initcall and
	module_exit
Message-ID: <20130205112731.GK17786@n2100.arm.linux.org.uk>
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com> <1359445134-13323-2-git-send-email-manishv.b@ti.com> <CACRpkdbf7TwrjfT2rhqQFGc3yh_Nt117RtzQO2y6g5Ddx5Ay_w@mail.gmail.com> <20130201170906.GE22517@atomide.com> <20130201171124.GF22517@atomide.com> <A4887BF146CD57468F700B415D2F47015828C7@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A4887BF146CD57468F700B415D2F47015828C7@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 06:36:34AM +0000, Vishwanathrao Badarkhe, Manish wrote:
> I made following changes, in order to update "dip->p" pointer with 
> correct value:
> 
> -       if (!dpi->p) {
> +       if (IS_ERR_OR_NULL(dpi->p)) {
>                 dpi->p = devm_pinctrl_get(dev);
> -               if (IS_ERR_OR_NULL(dpi->p)) {
> -                       int ret = PTR_ERR(dpi->p);
> -
> -                       dev_dbg(dev, "no pinctrl handle\n");
> -                       /* Only return deferrals */
> -                       if (ret == -EPROBE_DEFER)
> -                               return ret;
> -                       return 0;
> -               }
> +               ret = PTR_ERR(dpi->p);
> +               dev_dbg(dev, "no pinctrl handle\n");
> +               /* Only return deferrals */
> +               if (ret == -EPROBE_DEFER)
> +                       return ret;
> +               return 0;
> 
> Is this intended change?

The above looks totally broken to me.

Oh, it's using IS_ERR_OR_NULL(), so it's bound to be broken.
