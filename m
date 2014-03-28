Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaC1Hve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:51:34 -0400
Received: from mail-bn14138.inbound.protection.outlook.com ([207.46.163.138]:46259
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751057AbaC1Hvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:51:32 -0400
From: "qiang.zhao@freescale.com" <qiang.zhao@freescale.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mugunthanvnm@ti.com" <mugunthanvnm@ti.com>,
        "zonque@gmail.com" <zonque@gmail.com>,
        "helmut.schaa@googlemail.com" <helmut.schaa@googlemail.com>,
        Xiaobo Xie <X.Xie@freescale.com>
Subject: RE: [PATCH] phy/at8031: enable at8031 to work on interrupt mode
Thread-Topic: [PATCH] phy/at8031: enable at8031 to work on interrupt mode
Thread-Index: AQHPSYTCRpBkEkjFkUekHqGZQg7LGpr00wqAgAFJ7sA=
Date: Fri, 28 Mar 2014 07:36:11 +0000
Message-ID: <0ca1e7910cd247c4aebe4cbd48a633cb@BLUPR03MB341.namprd03.prod.outlook.com>
References: <1395901116-16034-1-git-send-email-B45475@freescale.com>
 <53341101.9000404@cogentembedded.com>
In-Reply-To: <53341101.9000404@cogentembedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01644DCF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377424004)(377454003)(189002)(199002)(13464003)(45984002)(24454002)(86362001)(2201001)(59766001)(93136001)(74316001)(77982001)(92566001)(74706001)(76786001)(76576001)(53806001)(76796001)(90146001)(33646001)(63696002)(20776003)(98676001)(49866001)(56816005)(97336001)(74366001)(47736001)(47976001)(50986001)(4396001)(66066001)(65816001)(80022001)(51856001)(87936001)(93516002)(46102001)(83072002)(85852003)(2656002)(85306002)(87266001)(76482001)(54356001)(94946001)(81686001)(81816001)(74502001)(56776001)(54316002)(81542001)(81342001)(69226001)(94316002)(47446002)(83322001)(74662001)(19580395003)(79102001)(19580405001)(74876001)(97186001)(31966008)(95666003)(80976001)(95416001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB389;H:BLUPR03MB341.namprd03.prod.outlook.com;FPR:520ED946.1E23B50D.68E71796.92A66A69.20287;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 27, 2014 7:53 PM, Sergei Shtylyov wrote:
> -----Original Message-----
> From: Sergei Shtylyov [mailto:sergei.shtylyov@cogentembedded.com]
> Sent: Thursday, March 27, 2014 7:53 PM
> To: Zhao Qiang-B45475; linuxppc-dev@lists.ozlabs.org;
> netdev@vger.kernel.org; Wood Scott-B07421
> Cc: linux-kernel@vger.kernel.org; davem@davemloft.net;
> mugunthanvnm@ti.com; zonque@gmail.com; helmut.schaa@googlemail.com; Xie
> Xiaobo-R63061
> Subject: Re: [PATCH] phy/at8031: enable at8031 to work on interrupt mode
> 
> Hello.
> 
> On 27-03-2014 10:18, Zhao Qiang wrote:
> 
> > The at8031 can work on polling mode and interrupt mode.
> > Add ack_interrupt and config intr funcs to enable interrupt mode for
> > it.
> 
> > Signed-off-by: Zhao Qiang <B45475@freescale.com>
> > ---
> >   drivers/net/phy/at803x.c | 30 ++++++++++++++++++++++++++++++
> >   1 file changed, 30 insertions(+)
> 
> > diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c index
> > bc71947..d034ef5 100644
> > --- a/drivers/net/phy/at803x.c
> > +++ b/drivers/net/phy/at803x.c
> [...]
> > @@ -191,6 +194,31 @@ static int at803x_config_init(struct phy_device
> *phydev)
> >   	return 0;
> >   }
> >
> > +static int at803x_ack_interrupt(struct phy_device *phydev) {
> > +	int err;
> > +
> > +	err = phy_read(phydev, AT803X_INSR);
> 
>     Could make this an initializer...

Thank you very much. However I have no idea about "make this an initializer".

> 
> > +
> > +	return (err < 0) ? err : 0;
> > +}
> > +
> > +static int at803x_config_intr(struct phy_device *phydev) {
> > +	int err;
> > +	int value;
> > +
> > +	value = phy_read(phydev, AT803X_INER);
> > +
> > +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> > +		err = phy_write(phydev, AT803X_INER,
> > +				(value | AT803X_INER_INIT));
> 
>     Inner parens not needed.
> 
> > +	else
> > +		err = phy_write(phydev, AT803X_INER, value);
> 
>     Why are you not clearing the bits here? Why write back what has been
> read at all?
> 
> WBR, Sergei
> 
> 

