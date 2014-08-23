Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbaHWN5N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 09:57:13 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:54644 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaHWN5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 09:57:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 0/7] MIPS: Move device-tree files to a common location
Date: Sat, 23 Aug 2014 15:56:42 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        "Linux-MIPS" <linux-mips@linux-mips.org>,
        Qais Yousef <qais.yousef@imgtec.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, John Crispin <blogic@openwrt.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jayachandran C <jchandra@broadcom.com>,
        Paul Burton <paul.burton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <1408651466-8334-1-git-send-email-abrestic@chromium.org> <CAL1qeaGb-o0P7x4nZPJ+dGfoSKz+2ANrB0gGrBi19TtPxVTAZQ@mail.gmail.com> <20140823063113.GC23715@localhost>
In-Reply-To: <20140823063113.GC23715@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201408231556.42571.arnd@arndb.de>
X-Provags-ID: V02:K0:amijnnnDsKoWdWE8F2RgkY55G2QwEm/B5S9drzsErmJ
 bWRyYLixFA9gAxfuFgiB8wnPNWT0DwainAq1vQMaZFEIACtq/Z
 Z3xPJw1E9yXhpzjaAfFmoBsnt/JR9UbSGsE3woqiGiBcmm4IGI
 Nl8YtviZtdzzYxZMClB3W//HV3DqOgm8YM9BpSmeXYDeXpbLSr
 2RqmDki9v/JadbZJibzkh1tmfc/aZBv40Q7gLBcxSvN4X7w43a
 yc5DntfLl47G9W4wtJbwrIUp6Vtp9vZoR/cUcaR3bq9hQDM5dp
 AbepNbB/GxuxZ/h3vM5TX9IoWYykyia4MCd2U0+PdIF61e7v4y
 Bx7cN+k7MqMnyFT7bq9k=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 August 2014, Olof Johansson wrote:
> On Fri, Aug 22, 2014 at 02:10:23PM -0700, Andrew Bresticker wrote:
> > On Fri, Aug 22, 2014 at 1:42 PM, Florian Fainelli <f.fainelli@gmail.com> wrote:
> > >
> > > On Aug 21, 2014 3:05 PM, "Andrew Bresticker" <abrestic@chromium.org> wrote:
> > > >
> > > > To be consistent with other architectures and to avoid unnecessary
> > > > makefile duplication, move all MIPS device-trees to arch/mips/boot/dts
> > > > and build them with a common makefile.
> > >
> > > I recall reading that the ARM organization for DTS files was a bit unfortunate
> > > and should have been something like:
> > >
> > > arch/arm/boot/dts/<vendor>/
> > >
> > > Is this something we should do for the MIPS and update the other architectures
> > > to follow that scheme?
> > 
> > I recall reading that as well and that it would be adopted for ARM64,
> > but that hasn't seemed to have happened.  Perhaps Olof (CC'ed) will no
> > more.
> 
> Yeah, I highly recommend having a directory per vendor. We didn't on ARM,
> and the amount of files in that directory is becoming pretty
> insane. Moving to a subdirectory structure later gets messy which is
> why we've been holding off on it.

Another argument is that we plan to actually move all the dts files out of
the kernel into a separate project in the future. We really don't want to
have the churn of moving all the files now when they get deleted in one
of the next merge windows.

I don't know if we talked about whether that move should be done for
all architectures at the same time. If that is the plan, I think it
would be best to not move the MIPS files at all but also wait until
they can get removed from the kernel tree.

	Arnd
