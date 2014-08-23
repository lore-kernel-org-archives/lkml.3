Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaHWQPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 12:15:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52701 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaHWQPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 12:15:17 -0400
Date: Sat, 23 Aug 2014 09:14:56 -0700
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        Qais Yousef <qais.yousef@imgtec.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, John Crispin <blogic@openwrt.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jayachandran C <jchandra@broadcom.com>,
        Paul Burton <paul.burton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 0/7] MIPS: Move device-tree files to a common location
Message-ID: <20140823161456.GA2758@localhost>
References: <1408651466-8334-1-git-send-email-abrestic@chromium.org>
 <CAL1qeaGb-o0P7x4nZPJ+dGfoSKz+2ANrB0gGrBi19TtPxVTAZQ@mail.gmail.com>
 <20140823063113.GC23715@localhost>
 <201408231556.42571.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201408231556.42571.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 03:56:42PM +0200, Arnd Bergmann wrote:
> On Saturday 23 August 2014, Olof Johansson wrote:
> > On Fri, Aug 22, 2014 at 02:10:23PM -0700, Andrew Bresticker wrote:
> > > On Fri, Aug 22, 2014 at 1:42 PM, Florian Fainelli <f.fainelli@gmail.com> wrote:
> > > >
> > > > On Aug 21, 2014 3:05 PM, "Andrew Bresticker" <abrestic@chromium.org> wrote:
> > > > >
> > > > > To be consistent with other architectures and to avoid unnecessary
> > > > > makefile duplication, move all MIPS device-trees to arch/mips/boot/dts
> > > > > and build them with a common makefile.
> > > >
> > > > I recall reading that the ARM organization for DTS files was a bit unfortunate
> > > > and should have been something like:
> > > >
> > > > arch/arm/boot/dts/<vendor>/
> > > >
> > > > Is this something we should do for the MIPS and update the other architectures
> > > > to follow that scheme?
> > > 
> > > I recall reading that as well and that it would be adopted for ARM64,
> > > but that hasn't seemed to have happened.  Perhaps Olof (CC'ed) will no
> > > more.
> > 
> > Yeah, I highly recommend having a directory per vendor. We didn't on ARM,
> > and the amount of files in that directory is becoming pretty
> > insane. Moving to a subdirectory structure later gets messy which is
> > why we've been holding off on it.
> 
> Another argument is that we plan to actually move all the dts files out of
> the kernel into a separate project in the future. We really don't want to
> have the churn of moving all the files now when they get deleted in one
> of the next merge windows.

To be honest, I don't see that happening within the forseeable
future. Some of us maintainers like talking about this, but everyone who
actually develops have nightmares about this scenario. Nobody knows how
it'll be done without causing some real serious impact on productivity.

> I don't know if we talked about whether that move should be done for
> all architectures at the same time. If that is the plan, I think it
> would be best to not move the MIPS files at all but also wait until
> they can get removed from the kernel tree.

If MIPS can restructure now before things start growing, then I'd really
recommend that they do so and not hold off waiting on some event that
might never happen. :)


-Olof
