Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbaKQWxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:53:19 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60301 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752657AbaKQWxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:53:18 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@linaro.org>
Subject: Re: linux-next: build warning after merge of the pm tree
Date: Tue, 18 Nov 2014 00:14:19 +0100
Message-ID: <1721522.tICxlGjU6i@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416223903.22252.11.camel@x220>
References: <20141117134414.7f4d8d21@canb.auug.org.au> <1416223903.22252.11.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 17, 2014 12:31:43 PM Paul Bolle wrote:
> On Mon, 2014-11-17 at 13:44 +1100, Stephen Rothwell wrote:
> > Hi Rafael,
> > 
> > After merging the pm tree, today's linux-next build (arm multi_v7_defconfig)
> > produced this warning:
> > 
> > kernel/power/Kconfig:132:error: recursive dependency detected!
> > kernel/power/Kconfig:132:	symbol PM_RUNTIME is selected by PM_GENERIC_DOMAINS
> > kernel/power/Kconfig:272:	symbol PM_GENERIC_DOMAINS is selected by PM_RUNTIME
> > 
> > Caused by commit 9cdd5fd742e6 ("PM / domains: Kconfig: always enable
> > PM_RUNTIME when genpd enabled").
> 
> This error also popped up when I fiddled with omap2plus_defconfig on top
> of next-20141117. Note that I ended up with a .config which has
> CONFIG_ARCH_MULTI_V7 set. The error appears to be triggered by the
> Kconfig entry for ARCH_EXYNOS (in arch/arm/mach-exynos/Kconfig). It
> contains
>         select PM_GENERIC_DOMAINS if PM_RUNTIME
> 
> (Perhaps the :272: line needs rephrasing in the error Stephen quoted. It
> confused me quite a bit.)
> 
> Naively dropping that select statement from ARCH_EXYNOS triggered yet
> another error:
>     kernel/power/Kconfig:145:error: recursive dependency detected!
>     kernel/power/Kconfig:145:	symbol PM depends on PM_RUNTIME
>     kernel/power/Kconfig:132:	symbol PM_RUNTIME is selected by PM_GENERIC_DOMAINS
>     kernel/power/Kconfig:272:	symbol PM_GENERIC_DOMAINS is selected by PM
> 
> After that I admitted defeat.

I'll drop the commit for now, but this looks strange.

Had you cleaned up the kernel configuration after dropping the PM_RUNTIME select
from ARCH_EXYNOS?

Rafael

