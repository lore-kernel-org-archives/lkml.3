Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaKFAF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 19:05:59 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:53404 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaKFAFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 19:05:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Date: Thu, 06 Nov 2014 01:05:48 +0100
Message-ID: <2659321.LYB03rL97X@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141105233921.GJ6168@google.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <2148776.X8NPqiYA6S@wuerfel> <20141105233921.GJ6168@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WW2Gg33OZZLai5TPOZNHUB8C0qWqVIQ99jF+ea0j5D9
 jK7OgC0VFcHSkuAbFyddH+COCcBHiSiDHPejPsYPa04c891sGC
 ekCgEU3htu4zDpzSLUXp6ecxewBQiF/M7Yefs3yqiHOm4+ZEPE
 LQfOF2iOI0m0grcBw3Yvr4eRSt+fQUW57O8nml/zM06fRIjByJ
 9tNX5RJcDQ0pvfGpqXPY23+LNEVWaAEwaz0CcTVBfDjerQm8oy
 MNneuUlLRWsebILgh4RYqNDtlg4g+H8NSV9918nfBtNPF35iOU
 duGP0Nwm9CfVx7VQhRtAgX9R7Fh3E4EOvsTfmTWR8q/Lk5JNyY
 +TOQqBGeGsaNEI2puCk8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 November 2014 16:39:21 Bjorn Helgaas wrote:
> On Wed, Oct 22, 2014 at 10:52:19PM +0200, Arnd Bergmann wrote:
> > On Wednesday 22 October 2014 16:59:14 Lorenzo Pieralisi wrote:
> > > On Wed, Oct 01, 2014 at 10:38:45AM +0100, Arnd Bergmann wrote:
> > > 
> > > [...]
> > > 
> > > > The arm32 implementations of pci_domain_nr/pci_proc_domain can probably be
> > > > removed if we change the arm32 pcibios_init_hw function to call the new
> > > > interfaces that set the domain number.
> > > 
> > > I wished, but it is a bit more complicated than I thought unfortunately,
> > > mostly because some drivers, eg cns3xxx set the domain numbers
> > > statically in pci_sys_data and this sets a chain of dependency that is
> > > not easy to untangle. I think cns3xxx is the only legacy driver that "uses"
> > > the domain number (in pci_sys_data) in a way that clashes with the
> > > generic domain_nr implementation, I need to give it more thought.
> > 
> > Just had a look at that driver, shouldn't be too hard to change, see below.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> This patch is in my patchwork, but it lacks a topic & changelog and I'm not
> sure of its state, so I'm going to drop it for now.  Please post it again
> if you want me to do something with it.  I guess it only touches arch/arm,
> so it would probably be merged via your tree anyway.

Lorenzo has posted an updated version as

"arm: cns3xxx: pci: remove artificial dependency on pci_sys_data domain",
and a second patch that depends on it. That is the version we should be
merging, though I'm not sure through which tree.

	Arnd
