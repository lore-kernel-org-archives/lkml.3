Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3JEWgE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 18:36:04 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51883 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752312Ab3JEWgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 18:36:01 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        fei.li@intel.com
Subject: Re: [PATCH] PCI/PM: Removing the function pci_pm_complete()
Date: Sun, 06 Oct 2013 00:47:36 +0200
Message-ID: <4130856.aaSGkRrri4@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAErSpo6Sm1hDWRFaMYtiZN6_KJ8N05eiRHj_GKJ6AhMjdR91Bw@mail.gmail.com>
References: <1378809966.26153.23.camel@cliu38-desktop-build> <CAErSpo6Sm1hDWRFaMYtiZN6_KJ8N05eiRHj_GKJ6AhMjdR91Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 04, 2013 11:47:25 AM Bjorn Helgaas wrote:
> On Tue, Sep 10, 2013 at 4:46 AM, Chuansheng Liu
> <chuansheng.liu@intel.com> wrote:
> >
> > Commit(88d2613) removed the pm_runtime_put_sync() from pci_pm_complete()
> > to PM core code device_complete().
> >
> > Here the pci_pm_complete() is doing the same work which can be done in
> > device_complete(), so we can remove it directly.
> >
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> >  drivers/pci/pci-driver.c |    9 ---------
> >  1 files changed, 0 insertions(+), 9 deletions(-)
> 
> This looks correct to me, but I'd like Rafael to ack it before I apply it.

Yes, it should work, so ACK.

Sorry for the delay.

> > diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> > index 98f7b9b..736ef3f 100644
> > --- a/drivers/pci/pci-driver.c
> > +++ b/drivers/pci/pci-driver.c
> > @@ -599,18 +599,10 @@ static int pci_pm_prepare(struct device *dev)
> >         return error;
> >  }
> >
> > -static void pci_pm_complete(struct device *dev)
> > -{
> > -       struct device_driver *drv = dev->driver;
> > -
> > -       if (drv && drv->pm && drv->pm->complete)
> > -               drv->pm->complete(dev);
> > -}
> >
> >  #else /* !CONFIG_PM_SLEEP */
> >
> >  #define pci_pm_prepare NULL
> > -#define pci_pm_complete        NULL
> >
> >  #endif /* !CONFIG_PM_SLEEP */
> >
> > @@ -1123,7 +1115,6 @@ static int pci_pm_runtime_idle(struct device *dev)
> >
> >  const struct dev_pm_ops pci_dev_pm_ops = {
> >         .prepare = pci_pm_prepare,
> > -       .complete = pci_pm_complete,
> >         .suspend = pci_pm_suspend,
> >         .resume = pci_pm_resume,
> >         .freeze = pci_pm_freeze,
> > --
> > 1.7.0.4

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
