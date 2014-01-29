Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaA2OYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:24:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49629 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaA2OYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:24:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pratyush Anand <pratyush.anand@st.com>
Subject: Re: Query: Phy: How to find consumer device on dt platform
Date: Wed, 29 Jan 2014 15:24:35 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel@list.st.com
References: <20140128141356.GC3519@pratyush-vbox> <52E894A4.8050303@ti.com> <20140129095031.GA2287@pratyush-vbox>
In-Reply-To: <20140129095031.GA2287@pratyush-vbox>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401291524.36131.arnd@arndb.de>
X-Provags-ID: V02:K0:9RTx/1//Jv6RPYJ8BRUkaIoAYN0ZrGAzeYp50i4I4zB
 jJ3A+05oZy2z069seXPT0g4o6oKK8LWOnfo7aUgb2A7Y3MhSMZ
 yy/TUnu9vJ53xyimtvYsl7hLTB8MmmD23jzJoaISRZs7QOYAB+
 AN1N/lAjeOk7vFy9aVnTjQSlKQsaE7bNqbhLc68E/t87S/bySY
 Tg7psMLQWEfM4+as7iAz4jpghqiGG/1wYY5J+GKZkxjFZhJHTa
 OeVUErxZymLCmDZoEFzkCg2Rf27EkhFdKTOckC8nkwmwAQNTJa
 zUAv1zSWZecsJJHegIzXu3JdFIT2yNThWgBosgitkhTe2d6ibM
 OSjxEs4Owv9z7RWcq1Ft/IU0uQO/EWjChS/26I9lj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 January 2014, Pratyush Anand wrote:
> On Wed, Jan 29, 2014 at 01:41:56PM +0800, Kishon Vijay Abraham I wrote:
> > > 
> > > I would instead recommend making the mode of the PHY device the
> > > argument to the phy handle in DT, so that the sata node uses
> > > 
> > > 	phys = <&phyA 0>;
> > > 
> > > and the PCIe node uses
> > > 
> > > 	phys = <&phyB 1>;
> > > 
> > > Then the binding for the phy defines that an argument of '0' means sata mode,
> > > while '1' means pcie mode, plus you should define all other valid modes.
> 
> Probably, it may  not help in this case. How would *phys* defining as
> above with PCIe/SATA node help phy driver to decide whether current
> phy instance is associated with PCIe or SATA. Actually, there is no
> way to pass information from phy consumer driver(pcie/sata driver in
> this case) to phy driver.

I don't understand what is unclear about my example where I do just that.
The argument (0 or 1) gets passed into the driver's xlate function
when the consumer calls of_phy_get().

> > Anyway phyA and phyB points to different nodes and just from phyA and phyB we
> > should be able to tell whether it is sata or pcie.
> 
> We have multiple instances (say 3) of same phy, which can be
> programmed either for pcie or for sata. We have multiple instances of
> ahci and pcie controller. phy_n will be connected to either ahci_n or
> pcie_n.
> 
> What Kishon has suggested here is exactly what I was thinking.
> I think, we should go with this.

I still find it highly inconsistent.

	Arnd
