Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaA2Odx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:33:53 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:56250 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbaA2Odw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:33:52 -0500
Date: Wed, 29 Jan 2014 19:47:48 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: Query: Phy: How to find consumer device on dt platform
Message-ID: <20140129141747.GB2287@pratyush-vbox>
References: <20140128141356.GC3519@pratyush-vbox>
 <52E894A4.8050303@ti.com>
 <20140129095031.GA2287@pratyush-vbox>
 <201401291524.36131.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201401291524.36131.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 10:24:35PM +0800, Arnd Bergmann wrote:
> On Wednesday 29 January 2014, Pratyush Anand wrote:
> > On Wed, Jan 29, 2014 at 01:41:56PM +0800, Kishon Vijay Abraham I wrote:
> > > > 
> > > > I would instead recommend making the mode of the PHY device the
> > > > argument to the phy handle in DT, so that the sata node uses
> > > > 
> > > > 	phys = <&phyA 0>;
> > > > 
> > > > and the PCIe node uses
> > > > 
> > > > 	phys = <&phyB 1>;
> > > > 
> > > > Then the binding for the phy defines that an argument of '0' means sata mode,
> > > > while '1' means pcie mode, plus you should define all other valid modes.
> > 
> > Probably, it may  not help in this case. How would *phys* defining as
> > above with PCIe/SATA node help phy driver to decide whether current
> > phy instance is associated with PCIe or SATA. Actually, there is no
> > way to pass information from phy consumer driver(pcie/sata driver in
> > this case) to phy driver.
> 
> I don't understand what is unclear about my example where I do just that.
> The argument (0 or 1) gets passed into the driver's xlate function
> when the consumer calls of_phy_get().

May be I did not understand this mechanism earlier.
I got it now. 

Will do this way :)

Thanks for explaining it.

Regards
Pratyush

> 
> > > Anyway phyA and phyB points to different nodes and just from phyA and phyB we
> > > should be able to tell whether it is sata or pcie.
> > 
> > We have multiple instances (say 3) of same phy, which can be
> > programmed either for pcie or for sata. We have multiple instances of
> > ahci and pcie controller. phy_n will be connected to either ahci_n or
> > pcie_n.
> > 
> > What Kishon has suggested here is exactly what I was thinking.
> > I think, we should go with this.
> 
> I still find it highly inconsistent.
> 
> 	Arnd
