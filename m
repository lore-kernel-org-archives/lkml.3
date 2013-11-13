Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab3KML5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:57:05 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:59839 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756831Ab3KML47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:56:59 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z1039mzbb2dI9371I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh109h2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216hbe9i1155h)
From: Shaohui Xie <Shaohui.Xie@freescale.com>
To: Florian Fainelli <f.fainelli@gmail.com>,
        "shh.xie@gmail.com" <shh.xie@gmail.com>
CC: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Madalin-Cristian Bucur <madalin.bucur@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>
Subject: RE: [PATCH 2/4] phylib: Add generic 10G driver
Thread-Topic: [PATCH 2/4] phylib: Add generic 10G driver
Thread-Index: AQHO3tjzTgQX+U6lMUa4aXTRguqMV5oh4oEAgAEmoCA=
Date: Wed, 13 Nov 2013 11:56:41 +0000
Message-ID: <ED492CCEAF882048BC2237DE806547C915128553@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1384168049-2899-1-git-send-email-shh.xie@gmail.com>
 <CAGVrzcZa2-yduRDxwGnYeoLJcRFjDr9OHtkUReAPF0cDseamJg@mail.gmail.com>
In-Reply-To: <CAGVrzcZa2-yduRDxwGnYeoLJcRFjDr9OHtkUReAPF0cDseamJg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.53]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rADBvQD3032208

Hello, Florian,

Thank you for reviewing the patches!
Please see my comments inline.

Best Regards, 
Shaohui Xie


> -----Original Message-----
> From: Florian Fainelli [mailto:f.fainelli@gmail.com]
> Sent: Wednesday, November 13, 2013 1:54 AM
> To: shh.xie@gmail.com
> Cc: linuxppc-dev; linux-kernel@vger.kernel.org; Bucur Madalin-Cristian-
> B32716; Kanetkar Shruti-B44454; Xie Shaohui-B21989
> Subject: Re: [PATCH 2/4] phylib: Add generic 10G driver
> 
> Hello Shaohui,
> 
> 2013/11/11  <shh.xie@gmail.com>:
> > From: Andy Fleming
> >
> > Very incomplete, but will allow for binding an ethernet controller to
> > it.
> >
> > Also, Add XGMII interface type
> 
> So that should be two separate patches, and
> drivers/of/of_net.c::of_get_phy_mode() must be updated to know about
> XMGII.
> 
> >
> > Signed-off-by: Andy Fleming
> 
> Missing Andy's Signed-off-by tag.
[S.H] Will add in next version, I removed it to make git work since Andy's e-mail address is not valid.

> 
> > Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
> > ---
> >  drivers/net/phy/phy_device.c | 101
> ++++++++++++++++++++++++++++++++++++++++++-
> >  include/linux/phy.h          |   1 +
> >  2 files changed, 101 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/phy/phy_device.c
> > b/drivers/net/phy/phy_device.c index 74630e9..30bf2d5 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/module.h>
> >  #include <linux/mii.h>
> >  #include <linux/ethtool.h>
> > +#include <linux/mdio.h>
> >  #include <linux/phy.h>
> >
> >  #include <asm/io.h>
> > @@ -689,6 +690,13 @@ static int genphy_config_advert(struct phy_device
> *phydev)
> >         return changed;
> >  }
> >
> > +int gen10g_config_advert(struct phy_device *dev) {
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(gen10g_config_advert);
> > +
> > +
> >  /**
> >   * genphy_setup_forced - configures/forces speed/duplex from @phydev
> >   * @phydev: target phy_device struct
> > @@ -742,6 +750,12 @@ int genphy_restart_aneg(struct phy_device
> > *phydev)  }  EXPORT_SYMBOL(genphy_restart_aneg);
> >
> > +int gen10g_restart_aneg(struct phy_device *phydev) {
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(gen10g_restart_aneg);
> > +
> >
> >  /**
> >   * genphy_config_aneg - restart auto-negotiation or write BMCR @@
> > -784,6 +798,13 @@ int genphy_config_aneg(struct phy_device *phydev)  }
> > EXPORT_SYMBOL(genphy_config_aneg);
> >
> > +int gen10g_config_aneg(struct phy_device *phydev) {
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(gen10g_config_aneg);
> > +
> > +
> >  /**
> >   * genphy_update_link - update link status in @phydev
> >   * @phydev: target phy_device struct
> > @@ -913,6 +934,35 @@ int genphy_read_status(struct phy_device *phydev)
> > }  EXPORT_SYMBOL(genphy_read_status);
> >
> > +int gen10g_read_status(struct phy_device *phydev) {
> > +       int devad, reg;
> > +       u32 mmd_mask = phydev->c45_ids.devices_in_package;
> > +
> > +       phydev->link = 1;
> > +
> > +       /* For now just lie and say it's 10G all the time */
> > +       phydev->speed = 10000;
> 
> Can you at least make this a little more proof? Something along:
> 
> if (phydev->supported & (SUPPORTED_10000baseT_Full))
>             phydev->speed = SPEED_10000; else if (phydev->supported &
> (SUPPORTED_1000baseT_Full)
>             phydev->speed = SPEED_1000;
[S.H] some 10G PHY only support 10G speed.

> 
> Although ideally we should be reading the relevant registers to figure
> out what to do.
[S.H] Yes, code below will try to read the mmds to get status.

> 
> > +       phydev->duplex = DUPLEX_FULL;
> > +
> > +       for (devad = 0; mmd_mask; devad++, mmd_mask = mmd_mask >> 1) {
> > +               if (!(mmd_mask & 1))
> > +                       continue;
> > +
> > +               /* Read twice because link state is latched and a
> > +                * read moves the current state into the register
> > +                */
> > +               phy_read_mmd(phydev, devad, MDIO_STAT1);
> > +               reg = phy_read_mmd(phydev, devad, MDIO_STAT1);
> > +               if (reg < 0 || !(reg & MDIO_STAT1_LSTATUS))
> > +                       phydev->link = 0;
> > +       }
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(gen10g_read_status);
> > +
> > +
> >  static int genphy_config_init(struct phy_device *phydev)  {
> >         int val;
> > @@ -959,6 +1009,15 @@ static int genphy_config_init(struct phy_device
> > *phydev)
> >
> >         return 0;
> >  }
> > +
> > +static int gen10g_config_init(struct phy_device *phydev) {
> > +       /* Temporarily just say we support everything */
> > +       phydev->supported = phydev->advertising =
> > +SUPPORTED_10000baseT_Full;
> 
> For consistency you should set SUPPORTED_TP, 1000baseT_Full does not make
> sense for anything but twisted pairs AFAIR.
[S.H] OK.

> 
> > +
> > +       return 0;
> > +}
> > +
> >  int genphy_suspend(struct phy_device *phydev)  {
> >         int value;
> > @@ -974,6 +1033,13 @@ int genphy_suspend(struct phy_device *phydev)  }
> > EXPORT_SYMBOL(genphy_suspend);
> >
> > +int gen10g_suspend(struct phy_device *phydev) {
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(gen10g_suspend);
> > +
> > +
> >  int genphy_resume(struct phy_device *phydev)  {
> >         int value;
> > @@ -989,6 +1055,13 @@ int genphy_resume(struct phy_device *phydev)  }
> > EXPORT_SYMBOL(genphy_resume);
> >
> > +int gen10g_resume(struct phy_device *phydev) {
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(gen10g_resume);
> > +
> > +
> >  /**
> >   * phy_probe - probe and init a PHY device
> >   * @dev: device to probe and init
> > @@ -1129,6 +1202,20 @@ static struct phy_driver genphy_driver = {
> >         .driver         = {.owner= THIS_MODULE, },
> >  };
> >
> > +static struct phy_driver gen10g_driver = {
> > +       .phy_id         = 0xffffffff,
> > +       .phy_id_mask    = 0xffffffff,
> > +       .name           = "Generic 10G PHY",
> > +       .config_init    = gen10g_config_init,
> > +       .features       = 0,
> 
> This should be updated to be PHY_10GBIT_FEATURES where
> PHY_10GBIT_FEATURES is defined to contain at least PHY_GBIT_FEATURES.
[S.H] for a generic 10G PHY, what is the feature should be supported?

> 
> > +       .config_aneg    = gen10g_config_aneg,
> > +       .read_status    = gen10g_read_status,
> > +       .suspend        = gen10g_suspend,
> > +       .resume         = gen10g_resume,
> > +       .driver         = {.owner = THIS_MODULE, },
> > +};
> > +
> > +
> >  static int __init phy_init(void)
> >  {
> >         int rc;
> > @@ -1139,13 +1226,25 @@ static int __init phy_init(void)
> >
> >         rc = phy_driver_register(&genphy_driver);
> >         if (rc)
> > -               mdio_bus_exit();
> > +               goto genphy_register_failed;
> > +
> > +       rc = phy_driver_register(&gen10g_driver);
> > +       if (rc)
> > +               goto gen10g_register_failed;
> > +
> > +       return rc;
> > +
> > +gen10g_register_failed:
> > +       phy_driver_unregister(&genphy_driver);
> > +genphy_register_failed:
> > +       mdio_bus_exit();
> 
> As a subsequent patch you could use phy_drivers_register()
[S.H] you mean like phy_drivers_register(gen10g_driver, ARRAY_SIZE(gen10g_driver))?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
