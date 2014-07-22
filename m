Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbaGVUoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:44:38 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53198 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaGVUog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:44:36 -0400
Date: Tue, 22 Jul 2014 13:44:31 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Matt Porter <mporter@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, Gregory Fong <gregory.0xf0@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH v8 00/11] ARM: brcmstb: Add Broadcom STB SoC support
Message-ID: <20140722204431.GG28323@ld-irv-0074>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
 <5675728.WLk3P96IBM@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5675728.WLk3P96IBM@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Sebastian

On Tue, Jul 22, 2014 at 09:35:45AM +0200, Arnd Bergmann wrote:
> On Monday 21 July 2014 14:07:55 Brian Norris wrote:
> > I'm taking over the latest resubmission of this patch series.
> > There are a few moderate changes for v8 (noted below), but we
> > are waiting mostly for an Ack for the reboot driver.
> > 
> > This patchset contains the board support package for the
> > Broadcom BCM7445 ARM-based SoC [1]. These changes contain a
> > minimal set of code needed for a BCM7445-based board to boot
> > the Linux kernel.
> > 
> > These changes heavily leverage the OF/devicetree framework. The
> > machine is also built into the multi-platform ARMv7 image.
> > 
> > Changes are also available here:
> > 
> >   https://github.com/brcm/linux/tree/brcmstb-v8
> >   git://github.com/brcm/linux.git +brcmstb-v8
> 
> Whole series
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks!

> I think we should try to get this merged into 3.17, it's already
> taken too long and the patches look good.

Yes, it's about time.

> Please add the core architecture patches for arch/arm into Russell's
> patch tracker http://www.arm.linux.org.uk/developer/patches/.

OK, that's unfamiliar to me, but I'll try that out.

> For the platform changes in the first patch, I would prefer to have
> Matt pick up the first patch, but we can also apply it directly into
> arm-soc if he prefers that.

That brings up a question related to PATCH 11 in the series (MAINTAINERS
update); who will be maintaining arch/arm/mach-bcm/*brcmstb*, and how
will code go upstream? It seems like Matt and Christian are officially
mach-bcm maintainers, although I don't know if Christian is still
involved.

Also, BCM7xxx shares little in common with the rest of mach-bcm, except
a company name, so we'd really like at least the 'Maintainer' entries
for the CC. I was planning on a separate git tree too, although it could
have conflicts if we touch arch/arm/mach-bcm/{Makefile,Kconfig}.

So would we send a separate arm-soc pull request for the arm-soc
targeted changes (and all future development)?

> The reset driver can ideally go through the drivers/power/ maintainers,
> but if they are not interested in merging it, we can also take that
> through arm-soc.

I don't see much activity from the drivers/power/ maintainers on the
mailing lists, and I know David Woodhouse at least has been severely
distracted (I took over for him on driver/mtd/ recently), so I don't
expect much. (EDIT: I see [1]. Nice!)

> See also my one comment on that driver.

I proposed an additional diff on that patch in response.

I can strip the drivers/power/reboot/ driver out and send it separately
to our new drivers/power/ maintainer (thanks Sebastian!), and hope that
it gets through for 3.17.

For the reset of mach-bcm stuff, I'll just send an arm-soc pull request
soon enough, unless Matt/Arnd/Olof object.

Thanks,
Brian

[1] https://lkml.org/lkml/2014/7/16/539
