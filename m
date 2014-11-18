Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaKRUTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:19:38 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59565 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753829AbaKRUTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:19:37 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Kevin Hilman <khilman@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is selected (was: Re: [PATCH] PM / domains: Kconfig: always enable PM_RUNTIME when genpd enabled)
Date: Tue, 18 Nov 2014 21:40:41 +0100
Message-ID: <3083002.vigHFXKN0z@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141118083411.GB4059@amd>
References: <1415917702-6742-1-git-send-email-khilman@kernel.org> <1452958.d0yJE5gVgq@vostro.rjw.lan> <20141118083411.GB4059@amd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 18, 2014 09:34:11 AM Pavel Machek wrote:
> On Tue 2014-11-18 01:39:06, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > The number of and dependencies between high-level power management
> > Kconfig options make life much harder than necessary.  Several
> > conbinations of them have to be tested and supported, even though
> > some of those combinations are very rarely used in practice (it
> > they are used in practice at all).  Moreover, the fact that we
> > have separate independent Kconfig options for runtime PM and
> > system suspend is a serious obscacle for integration between
> > the two frameworks.
> > 
> > To overcome these difficulties, always select PM_RUNTIME if PM_SLEEP
> > is set.  Among other things, this will allow system suspend callbacks
> > provided by bus types and device drivers to rely on the runtime PM
> > framework regardless of the kernel configuration.
> 
> 3.18-rc5 still has:
> 
> config PM_RUNTIME
>         bool "Run-time PM core functionality"
>         depends on !IA64_HP_SIM
>         ---help---
> 
> So I assume this patch is against tree where PM_RUNTIME does not
> depend on anything?

Yes.

> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> > 
> > As a follow up.
> > 
> > Note that we won't need the patch making genpd select PM_RUNTIME with this,
> > because genpd already depends on PM.
> 
> Looking through the config file, there are more config options that
> should be stripped.
> 
> config SUSPEND_FREEZER
>         bool "Enable freezer for suspend to RAM/standby" \
> "Turning OFF this setting is NOT recommended! If in doubt, say Y."

Yeah, I'll gladly apply a patch removing this one. :-)

> config HIBERNATE_CALLBACKS
>        bool
> 
> ...can we just use CONFIG_HIBERNATE, instead?

We do, but in addition.

HIBERNATE_CALLBACKS is used by Xen IIRC and they don't want to build in the
whole hibernation image creation etc code (which they never use anyway).

Rafael

