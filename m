Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaA3MVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:21:06 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:36795 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180AbaA3MVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:21:04 -0500
Date: Thu, 30 Jan 2014 17:45:14 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Mohit KUMAR DCG <Mohit.KUMAR@st.com>, "arnd@arndb.de" <arnd@arndb.de>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH V3 4/8] phy: Initialize phy core with subsys_initcall
Message-ID: <20140130121514.GA1857@pratyush-vbox>
References: <cover.1391077731.git.mohit.kumar@st.com>
 <6f2dbd4fcb99a070c07b39545d98eca58101daa0.1391077731.git.mohit.kumar@st.com>
 <52EA3AE9.3030000@ti.com>
 <20140130115212.GA1171@pratyush-vbox>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140130115212.GA1171@pratyush-vbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 07:52:12PM +0800, Pratyush ANAND wrote:
> On Thu, Jan 30, 2014 at 07:43:37PM +0800, Kishon Vijay Abraham I wrote:
> > Hi,
> > 
> > On Thursday 30 January 2014 04:18 PM, Mohit Kumar wrote:
> > > From: Pratyush Anand <pratyush.anand@st.com>
> > > 
> > > PCIe RC drivers are initialized with subsys_initcall. Few PCIe drivers
> > > like SPEAr13xx needs phy drivers to be initialized.
> > 
> > Instead change PCIe RC drivers to module init. Phy drivers should be loaded
> > very early otherwise. (Hint: drivers/Makefile).

>From hint, you mean that if makefile has pci entry (and hence RC
driver entry) before card drivers entry, then it insures that rc
driver's probe is called before card driver's probe?
I think, yes.
And if yes, then what you say is acceptable :)

Regards
Pratyush
> 
> I think PCIe RC driver can not be made module init. Bjorn can comment
> better.
> 
> All PCIe card drivers are initialized with module init. RC driver must
> have been initialized before any card driver initialization.
> Currently, card drivers does not have deferred probe concept, so I am
> not sure if keeping RC driver as module init will work always.
> 
> By the way, is there any side effect of loading phy driver very early?
> 
> Regards
> Pratyush
> > 
> > Thanks
> > Kishon
> > > 
> > > Therefore initialize phy core driver with subsys_initcall to avoid
> > > calling of phy_get before phy_class is created.
> > > 
> > > Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
> > > Cc: Mohit Kumar <mohit.kumar@st.com>
> > > Cc: Kishon Vijay Abraham I <kishon@ti.com>
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > Cc: spear-devel@list.st.com
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> > >  drivers/phy/phy-core.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> > > index 03cf8fb..fa73101 100644
> > > --- a/drivers/phy/phy-core.c
> > > +++ b/drivers/phy/phy-core.c
> > > @@ -685,7 +685,7 @@ static int __init phy_core_init(void)
> > >  
> > >  	return 0;
> > >  }
> > > -module_init(phy_core_init);
> > > +subsys_initcall(phy_core_init);
> > >  
> > >  static void __exit phy_core_exit(void)
> > >  {
> > > 
> > 
