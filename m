Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbaGRAum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:50:42 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56166 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759051AbaGRAuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:50:40 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Quentin Armitage <quentin@armitage.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: kirkwood: Reinstate cpufreq driver for ARCH_KIRKWOOD
Date: Fri, 18 Jul 2014 03:08:57 +0200
Message-ID: <5801914.DoQzr9v8uz@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140710135859.GL21833@lunn.ch>
References: <1404987355.23201.65.camel@samson1.armitage.org.uk> <20140710135859.GL21833@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 10, 2014 03:58:59 PM Andrew Lunn wrote:
> On Thu, Jul 10, 2014 at 11:15:55AM +0100, Quentin Armitage wrote:
> > Commit ff1f0018cf66080d8e6f59791e552615648a033a ("drivers: Enable
> > building of Kirkwood drivers for mach-mvebu") added Kirkwood into
> > mach-mvebu, adding MACH_KIRKWOOD to ARCH_KIRKWOOD in the KConfig files.
> > 
> > The change for ARM_KIRKWOOD_CPUFREQ replaced ARCH_KIRKWOOD with
> > MACH_KIRKWOOD, whereas all the other changes were ARCH_KIRKWOOD ||
> > MACH_KIRKWOOD.
> > 
> > As a consequence of this change, the cpufreq driver is no longer enabled
> > for ARCH_KIRKWOOD. This patch reinstates ARM_KIRKWOOD_CPUFREQ for
> > ARCH_KIRKWOOD.
> > 
> > Signed-off-by: Quentin Armitage <quentin@armitage.org.uk>
> > ---
> > diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> > index ebac671..24778f0 100644
> > --- a/drivers/cpufreq/Kconfig.arm
> > +++ b/drivers/cpufreq/Kconfig.arm
> > @@ -118,7 +118,7 @@ config ARM_INTEGRATOR
> >           If in doubt, say Y.
> > 
> >  config ARM_KIRKWOOD_CPUFREQ
> > -       def_bool MACH_KIRKWOOD
> > +       def_bool ARCH_KIRKWOOD || MACH_KIRKWOOD
> >         help
> >           This adds the CPUFreq driver for Marvell Kirkwood
> >           SoCs.
> 
> Acked-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!

