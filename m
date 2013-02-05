Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3BENAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:00:52 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:55891 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3BENAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:00:50 -0500
MIME-Version: 1.0
In-Reply-To: <A4887BF146CD57468F700B415D2F47015828C7@DBDE01.ent.ti.com>
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
	<1359445134-13323-2-git-send-email-manishv.b@ti.com>
	<CACRpkdbf7TwrjfT2rhqQFGc3yh_Nt117RtzQO2y6g5Ddx5Ay_w@mail.gmail.com>
	<20130201170906.GE22517@atomide.com>
	<20130201171124.GF22517@atomide.com>
	<A4887BF146CD57468F700B415D2F47015828C7@DBDE01.ent.ti.com>
Date: Tue, 5 Feb 2013 14:00:48 +0100
Message-ID: <CACRpkdYUBGkRRF_nDbn5tGmtZC_Wucqxz_PjWo0xX_KbnQJ5cw@mail.gmail.com>
Subject: Re: [PATCH V2 1/6] pinctrl: pinctrl-single: use arch_initcall and module_exit
From: Linus Walleij <linus.walleij@linaro.org>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 7:36 AM, Vishwanathrao Badarkhe, Manish
<manishv.b@ti.com> wrote:

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

This is based on some old code that I wrote ages ago. Check the
pinctrl tree or linux-next for the latest core pin grabbing code.
Use that instead.

Yours,
Linus Walleij
