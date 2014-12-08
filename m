Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaLHGlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:41:01 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:15589 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaLHGk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:40:59 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Florian Fainelli <f.fainelli@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-arm-kernel-bounces@lists.infradead.org" 
	<linux-arm-kernel-bounces@lists.infradead.org>,
        "johan@kernel.org" <johan@kernel.org>
Subject: RE: [PATCH] net: phy: micrel: workaround to NAND_Tree# incorrectly
 strapp-in during the reset period.
Thread-Topic: [PATCH] net: phy: micrel: workaround to NAND_Tree# incorrectly
 strapp-in during the reset period.
Thread-Index: AQHQEpi2ZrVwxvEhKUOCazJULNL57pyEntQAgACe+IA=
Date: Mon, 8 Dec 2014 06:38:55 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFCB355F@penmbx01>
References: <1418009740-27384-1-git-send-email-wenyou.yang@atmel.com>
 <54853268.6030701@gmail.com>
In-Reply-To: <54853268.6030701@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB86fBKQ023390



> -----Original Message-----
> From: Florian Fainelli [mailto:f.fainelli@gmail.com]
> Sent: Monday, December 08, 2014 1:09 PM
> To: Yang, Wenyou
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Ferre, Nicolas; linux-
> arm-kernel-bounces@lists.infradead.org; johan@kernel.org
> Subject: Re: [PATCH] net: phy: micrel: workaround to NAND_Tree# incorrectly
> strapp-in during the reset period.
> 
> Le 07/12/2014 19:35, Wenyou Yang a Ã©crit :
> > Appearance: On some boards, after power up, the Ethernet doesn't work.
> >
> > Reason: On the SAMA5D4EK, the PIOE2 pin is connected to the NAND_Tree#
> > of KSZ8081, But it outputs LOW during the reset period, which cause the
> NAND_Tree# enabled.
> >
> > Workaround: In the .config_init(), add code to disable NAND_Tree# by
> > operating Operation Mode Strap Override(i.e. Register 16h).
> 
> Your patch won't apply cleanly to the net-next tree where the PHY drivers
> development is happening, especially not after Johan's recent changes.
> 
> Is not what you are looking for a phy_fixup() rather than clearing this bit for all
> Micrel PHYs?
Thanks, I will go in this direction.

> 
> >
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > ---
> >  drivers/net/phy/micrel.c |    8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c index
> > 8c2a29a..11d72cb 100644
> > --- a/drivers/net/phy/micrel.c
> > +++ b/drivers/net/phy/micrel.c
> > @@ -31,6 +31,7 @@
> >  /* Operation Mode Strap Override */
> >  #define MII_KSZPHY_OMSO				0x16
> >  #define KSZPHY_OMSO_B_CAST_OFF			(1 << 9)
> > +#define KSZPHY_OMSO_NAND_TREE_OVERRIDE		(1 << 5)
> >  #define KSZPHY_OMSO_RMII_OVERRIDE		(1 << 1)
> >  #define KSZPHY_OMSO_MII_OVERRIDE		(1 << 0)
> >
> > @@ -180,7 +181,12 @@ static int kszphy_setup_led(struct phy_device
> > *phydev,
> >
> >  static int kszphy_config_init(struct phy_device *phydev)  {
> > -	return 0;
> > +	int rc;
> > +
> > +	phy_write(phydev, MII_KSZPHY_OMSO, phy_read(phydev,
> MII_KSZPHY_OMSO)
> > +			& (~KSZPHY_OMSO_NAND_TREE_OVERRIDE));
> > +	rc = ksz_config_flags(phydev);
> > +	return rc < 0 ? rc : 0;
> >  }
> >
> >  static int kszphy_config_init_led8041(struct phy_device *phydev)
> >

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
