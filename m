Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3IYFj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 01:39:27 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:45167 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3IYFjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 01:39:25 -0400
Date: Wed, 25 Sep 2013 14:39:22 +0900
From: Simon Horman <horms@verge.net.au>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Magnus Damm <magnus.damm@gmail.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, openezx-devel@lists.openezx.org,
        linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/10] pwm-backlight: Add GPIO and power supply support
Message-ID: <20130925053922.GE1916@verge.net.au>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
 <20130924081446.GA11981@verge.net.au>
 <20130924090023.GA13971@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924090023.GA13971@ulmo>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 11:00:24AM +0200, Thierry Reding wrote:
> On Tue, Sep 24, 2013 at 05:14:46PM +0900, Simon Horman wrote:
> > [ Cc: Olof Johansson, Kevin Hilman and Arnd Bergman: arm-soc maintainers ]
> > 
> > On Mon, Sep 23, 2013 at 11:40:57PM +0200, Thierry Reding wrote:
> > > This series adds the ability to specify a GPIO and a power supply to
> > > enable a backlight.
> > > 
> > > Patch 1 refactors the power on and power off sequences into separate
> > > functions in preparation for subsequent patches.
> > > 
> > > Patch 2 adds an optional GPIO to enable a backlight. This patch only
> > > includes the field within the platform data so that it can be properly
> > > setup before actually being put to use.
> > > 
> > > Patches 3 to 7 convert all users of the pwm-backlight driver to use the
> > > new field. For most of them, this just initializes the field to -1,
> > > marking the field as unused.
> > >
> > > Patch 8 uses the new field within the pwm-backlight driver and at the
> > > same time allows it to be parsed from device tree.
> > > 
> > > Patch 9 implements support for an optional power supply. This relies on
> > > the regulator core to return a dummy regulator when no supply has been
> > > otherwise setup so the driver doesn't have to handle that specially nor
> > > require all users to be updated.
> > > 
> > > Patch 10 adds a way to keep a backlight turned off at boot. This is
> > > useful when hooking up a backlight with a subsystem such as DRM which
> > > has more explicit semantics as to when a backlight should be turned on.
> > > 
> > > Due to the dependencies within the series, I propose to take all these
> > > patches through the PWM tree, so I'll need acks from OMAP, PXA, Samsung,
> > > shmobile and Unicore32 maintainers.
> > 
> > I received some feedback regarding shmobile conflicts when
> > arm-soc was merged between v3.11 and v3.12-rc1. With this
> > in mind I now have a strong preference for changes inside
> > arch/arm/mach-shmobile/ to be taken through my renesas
> > tree and thus more importantly through arm-soc if possible.
> 
> I understand. Unfortunately the nature of patche series such as this is
> that they require the whole series to be applied atomically (or at least
> in a very specific order). So the patch that uses the new enable_gpio
> field can only be applied after all previous patches. The only
> reasonable way to ensure that is to take all of the patches through one
> tree. Furthermore this patch is tiny (it adds a single line) and touches
> code that's unlikely to be modified by anyone else.
> 
> But if it makes you more comfortable, I could provide a stable branch
> that contains this series for you to merge into the shmobile tree. That
> should enable you to handle all conflict resolution prior to submitting
> to arm-soc.

After some further thought I have reasoned that:

1. It is only a one line change on the shmobile side
2. It is to a file that is not seeing much chainge and in
   a block of code that is seeing even less change.

And thus the chance of a conflict is small.

With this in mind I will ack the shmobile patch.

