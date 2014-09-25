Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaIYT1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:27:24 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:57026 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaIYT1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:27:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/6] pci, thunder: Add PCIe host controller devicetree bindings
Date: Thu, 25 Sep 2014 21:26:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Sunil Kovvuri <sunil.kovvuri@gmail.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Robert Richter <rric@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>,
        Sunil Goutham <sgoutham@cavium.com>
References: <1411573068-12952-1-git-send-email-rric@kernel.org> <8057985.kyfsioKAVy@wuerfel> <CAErSpo4oFLKbtddzVoXBN-1dXZn5C4pmzY_QiFMwV+RWtmtjiQ@mail.gmail.com>
In-Reply-To: <CAErSpo4oFLKbtddzVoXBN-1dXZn5C4pmzY_QiFMwV+RWtmtjiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201409252126.38945.arnd@arndb.de>
X-Provags-ID: V02:K0:fWyJg0fp/hYDClMqH5r1GgyN4McmSPumU2bHZhdzO0t
 Qxk/uZgo8MelslchNfhs0G6nGjb6aJQHyTBfMFnz+yk3IAi0Ks
 AWm7dU99+Smk7qvhvso8y3h6t7bqsP923dMEpKlVPCvAJdfK9m
 BZbbp6Ygc1WygNGLHnN9F1NOFVTAXhMlyBG0WV2fPXQ32t9zAp
 8HeL4dfrQtQEOX07FSEvtydZTOPEema9G2sowk6btBcG8HqEsF
 8D/+WXC7hl7xsx+B27TCXAvEL/5SjcJZ353YFJYMGnb6VO4JDk
 0ur3HBdjSOT4zISPQGOQamemM533jntoviJKHFAjA0McYC7Yoc
 fwq29xsB8N9jbSc0vnj0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2014, Bjorn Helgaas wrote:
> On Thu, Sep 25, 2014 at 1:31 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 25 September 2014 00:37:00 Sunil Kovvuri wrote:
> >> On Thu, Sep 25, 2014 at 12:04 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > On Wednesday 24 September 2014 23:34:04 Sunil Kovvuri wrote:
> 
> >> >> All on-board PCI devices connected to this PCI controller have fixed resources
> >> >> and doesn't have to be allocated/reassigned. Some of these devices are
> >> >> SRIOV based.
> >> >
> >> > I think you need to mark the ones that are nonrelocatable with flag
> >> > 0x80000000, otherwise the PCI core might decide to reassign them.
> >>
> >> Is this flag part of DT pci node properties ?
> >> I am using IORESOURCE_PCI_FIXED flag. Its there in other patches of
> >> the same series.
> >
> > Ah, right. I checked the source code again and it seems that we don't handle
> > this right at the moment. I think a range that has the nonrelocatable
> > flag set should be used for IORESOURCE_PCI_FIXED mappings without any
> > host specific code, but that needs to be implemented in common code.
> 
> What connection do you envision between nonrelocatable ranges and
> IORESOURCE_PCI_FIXED?  I don't know what a nonrelocatable range is,
> but for IORESOURCE_PCI_FIXED, all I intend is that the PCI core should
> not try to assign a different address, e.g., because the BAR is
> read-only or because it's a legacy IDE/VGA/etc. range for which there
> is no BAR at all.

I think that is exactly the definition of the nonrelocatable flag
in http://www.openfirmware.org/1275/bindings/pci/pci2_1.pdf

The example given in section 11.1.2 is for a VGA device that has some
relocatable BARs and some nonrelocatable BARs.

	Arnd
