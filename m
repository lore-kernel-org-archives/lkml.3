Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaIHHOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 03:14:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40822 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaIHHOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 03:14:18 -0400
Date: Mon, 8 Sep 2014 09:14:09 +0200
From: Robert Richter <rric@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>
Subject: Re: [PATCH 2/6] dts, kbuild: Factor out dtbs install rules to
 Makefile.dtbinst
Message-ID: <20140908071409.GV4703@rric.localhost>
References: <1409899692-1455-1-git-send-email-rric@kernel.org>
 <1409899692-1455-3-git-send-email-rric@kernel.org>
 <CAL_Jsq+NYU9c0Jw8DX_iH6G5_9tom9DGcP548q4tKQsdkb-s0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+NYU9c0Jw8DX_iH6G5_9tom9DGcP548q4tKQsdkb-s0A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.09.14 07:48:30, Rob Herring wrote:
> On Fri, Sep 5, 2014 at 1:48 AM, Robert Richter <rric@kernel.org> wrote:
> > From: Robert Richter <rrichter@cavium.com>
> >
> > Move dtbs install rules to Makefile.dtbinst. This change is needed to
> > implement support for dts vendor subdirs. The change makes Makefiles
> > easier and smaller as no longer the dtbs_install rule needs to be
> > defined. Another advantage is that install goals are not encoded in
> > targets anymore (%.dtb_dtbinst_).
> >
> > Signed-off-by: Robert Richter <rrichter@cavium.com>
> > ---
> >  arch/arm/Makefile            |  6 +++++-
> >  arch/arm/boot/dts/Makefile   |  2 --
> >  arch/arm64/Makefile          |  6 +++++-
> >  arch/arm64/boot/dts/Makefile |  2 --
> >  scripts/Kbuild.include       |  6 ++++++
> >  scripts/Makefile.dtbinst     | 38 ++++++++++++++++++++++++++++++++++++++
> >  scripts/Makefile.lib         | 12 ------------
> >  7 files changed, 54 insertions(+), 18 deletions(-)
> >  create mode 100644 scripts/Makefile.dtbinst
> >
> > diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> > index 0ce9d0f71f2a..1963d9a9a2c4 100644
> > --- a/arch/arm/Makefile
> > +++ b/arch/arm/Makefile
> > @@ -313,9 +313,13 @@ $(BOOT_TARGETS): vmlinux
> >         $(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $(boot)/dts/$@
> >
> >  PHONY += dtbs dtbs_install
> > -dtbs dtbs_install: prepare scripts
> > +
> > +dtbs: prepare scripts
> >         $(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $@
> >
> > +dtbs_install:
> > +       $(Q)$(MAKE) $(dtbinst)=$(boot)/dts MACHINE=$(MACHINE)
> 
> Can't you get rid of MACHINE here, too?

I moved this change to the end of this patch series to let maintainers
the choise to drop the change if they are not fine with it.

-Robert
