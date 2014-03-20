Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbaCTJPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:15:19 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:52489 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292AbaCTJO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:14:28 -0400
X-Greylist: delayed 1101 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 05:14:28 EDT
Date: Thu, 20 Mar 2014 14:25:09 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Mohit Kumar <mohit.kumar@st.com>, Shiraz Hashim <shiraz.hashim@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, spear-devel <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "...)" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] ARM: SPEAr1340: static-ize SATA functions
Message-ID: <20140320085509.GB4607@pratyush-vbox>
References: <1678906.b5uh0Nm7QE@amdc1032>
 <CAOh2x=nr1mrkcFk8nQFwNXxCqMPiN1Hq4=f1wwN=i65StawJ1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOh2x=nr1mrkcFk8nQFwNXxCqMPiN1Hq4=f1wwN=i65StawJ1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-20_02:2014-03-19,2014-03-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 07:00:08PM +0800, Viresh Kumar wrote:
> On Tue, Mar 18, 2014 at 4:28 PM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> > Make sata_miphy_exit(), sata_suspend() and sata_resume() static.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> > Previous submission:
> > https://lkml.org/lkml/2013/10/4/369
> >
> >  arch/arm/mach-spear/spear1340.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm/mach-spear/spear1340.c b/arch/arm/mach-spear/spear1340.c
> > index 3fb6834..e0e4251 100644
> > --- a/arch/arm/mach-spear/spear1340.c
> > +++ b/arch/arm/mach-spear/spear1340.c
> > @@ -93,7 +93,7 @@ static int sata_miphy_init(struct device *dev, void __iomem *addr)
> >         return 0;
> >  }
> >
> > -void sata_miphy_exit(struct device *dev)
> > +static void sata_miphy_exit(struct device *dev)
> >  {
> >         writel(0, SPEAR1340_PCIE_SATA_CFG);
> >         writel(0, SPEAR1340_PCIE_MIPHY_CFG);
> > @@ -107,7 +107,7 @@ void sata_miphy_exit(struct device *dev)
> >         msleep(20);
> >  }
> >
> > -int sata_suspend(struct device *dev)
> > +static int sata_suspend(struct device *dev)
> >  {
> >         if (dev->power.power_state.event == PM_EVENT_FREEZE)
> >                 return 0;
> > @@ -117,7 +117,7 @@ int sata_suspend(struct device *dev)
> >         return 0;
> >  }
> >
> > -int sata_resume(struct device *dev)
> > +static int sata_resume(struct device *dev)
> >  {
> >         if (dev->power.power_state.event == PM_EVENT_THAW)
> >                 return 0;
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

This patch will not be needed any more, since sata platform code has
already been cleaned up.

See:
https://lkml.org/lkml/2014/2/28/174

Regards
Pratyush
