Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbaISGMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 02:12:54 -0400
Received: from mail-bn1bn0104.outbound.protection.outlook.com ([157.56.110.104]:44735
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755888AbaISGMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 02:12:52 -0400
Date: Fri, 19 Sep 2014 13:46:04 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Xiubo Li-B47053 <Li.Xiubo@freescale.com>
CC: Dong Aisheng-B29396 <Aisheng.Dong@freescale.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "naushad@samsung.com" <naushad@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "joshi@samsung.com" <joshi@samsung.com>,
        "thomas.ab@samsung.com" <thomas.ab@samsung.com>,
        "vikas.sajjan@samsung.com" <vikas.sajjan@samsung.com>,
        "chow.kim@samsung.com" <chow.kim@samsung.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "'Boris BREZILLON'" <boris.brezillon@free-electrons.com>,
        "'Geert Uytterhoeven'" <geert+renesas@glider.be>,
        "'Stephen Warren'" <swarren@nvidia.com>
Subject: Re: [PATCH v3] mfd: syscon: Decouple syscon interface from
 platform devices
Message-ID: <20140919054602.GC19346@shlinux1.ap.freescale.net>
References: <20140917085818.GA10285@shlinux1.ap.freescale.net>
 <000401cfd269$922dfc40$b689f4c0$@samsung.com>
 <20140918030552.GA26661@shlinux1.ap.freescale.net>
 <000701cfd306$4d3e8080$e7bb8180$@samsung.com>
 <20140918075516.GB15363@shlinux1.ap.freescale.net>
 <000c01cfd324$1f2cd930$5d868b90$@samsung.com>
 <20140918100505.GA19346@shlinux1.ap.freescale.net>
 <48f9f4067cc44ad49297bb4b62c56c88@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <20140919041933.GB19346@shlinux1.ap.freescale.net>
 <8e0ba684d5fe4663a8842336385ed7ad@BY2PR0301MB0613.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8e0ba684d5fe4663a8842336385ed7ad@BY2PR0301MB0613.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(24454002)(164054003)(46406003)(92566001)(97756001)(92726001)(85852003)(50466002)(99396002)(4396001)(105606002)(76176999)(54356999)(31966008)(50986999)(87936001)(23726002)(83072002)(95666004)(106466001)(90102001)(19580395003)(21056001)(15202345003)(83506001)(15975445006)(83322001)(19580405001)(47776003)(64706001)(69596002)(68736004)(44976005)(6806004)(26826002)(97736003)(20776003)(33656002)(81542003)(110136001)(76482002)(80022003)(81342003)(102836001)(74502003)(107046002)(81156004)(79102003)(77982003)(84676001)(104016003)(85306004)(46102003)(93886004)(74662003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB323;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0339F89554
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Aisheng.Dong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 01:20:18PM +0800, Xiubo Li-B47053 wrote:
> [...]
> > >    create child: /dcsr@20000000/dcsr-atbrepl@3a8000
> > >    create child: /dcsr@20000000/dcsr-tsgen-ctrl@3a9000
> > >    create child: /dcsr@20000000/dcsr-tsgen-read@3aa000
> > >    create child: /regulators/regulator@0
> > >    ...
> > >
> > > As default the Linux will create all the platform device for each DT node,
> > which
> > > Can be found from "drivers/of/platform.c".
> > >
> > > So we can get the pdev node using the specified DT node, and feel safe to
> > use
> > > it as Pankaj's patch does.
> > >
> > 
> > I mean before the devices are populated from device tree.
> > For example, we usually call of_platform_populate in .init_machine.
> > Before it, we may not be able to get it's device, isn't it?
> > 
> 
> Yes, right.
> 
> For this case, we'd better create the pdev or dev manually for the first time
> We use it, right ?

Yes, that's my understanding.

Regards
Dong Aisheng

> 
> Thanks,
> 
> BRs
> Xiubo
> 
> 
> > Regards
> > Dong Aisheng
> > 
> > > And also we must make sure that the 'syscon' DT nodes has the compatible
> > prop.
> > >
> > > Thanks,
> > >
> > > BRs
> > > Xiubo
> > >
> > >
> > > > Regards
> > > > Dong Aisheng
> > > >
> > > > > ----
> > > > > static struct syscon *of_syscon_register(struct device_node *np)
> > > > >  {
> > > > > +	struct platform_device *pdev;
> > > > >  	struct syscon *syscon;
> > > > >  	struct regmap *regmap;
> > > > >  	void __iomem *base;
> > > > > @@ -142,7 +144,11 @@ static struct syscon *of_syscon_register(struct
> > > > > device_node *np)
> > > > >  	if (!base)
> > > > >  		return ERR_PTR(-ENOMEM);
> > > > >
> > > > > -	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
> > > > > +	pdev = of_find_device_by_node(np);
> > > > > +	if (!(&pdev->dev))
> > > > > +		return ERR_PTR(-ENODEV);
> > > > > +
> > > > > +	regmap = regmap_init_mmio(&pdev->dev, base,
> > &syscon_regmap_config);
> > > > >  	if (IS_ERR(regmap)) {
> > > > >  		pr_err("regmap init failed\n");
> > > > >  		return ERR_CAST(regmap);
> > > > > -------
> > > > >
> > > > > I have tested this in linux-next and it works well. In this way there
> > won't
> > > > > be any issues of
> > > > > dereferencing NULL pointer in regmap.c and at the same time, if DT has
> > > > > {big,little}-endian
> > > > > optional property in syscon device node, it will be taken care.
> > > > >
> > > > > So I would wait for Arnd's opinion about above mentioned changes and
> > then
> > > > > post a new
> > > > > change after addressing Arnd's minor comment along with this fix in next
> > > > > revision.
> > > > >
> > > > >
> > > > > Thanks,
> > > > > Pankaj Dubey
> > > > > > Maybe we could consider create device structure for each syscon
> > compatible
> > > > > device in
> > > > > > syscon driver in of_syscon_register in first time which seems to be
> > > > > reasonable.
> > > > > >
> > > > > > Regards
> > > > > > Dong Aisheng
> > > > > >
> > > > > > > --------------------------------------------
> > > > > > > Subject: [PATCH] regmap: fix NULL pointer dereference in
> > > > > > > regmap_get_val_endian
> > > > > > >
> > > > > > > Recent commits for getting reg endianess causing NULL pointer
> > > > > > > dereference if dev is passed NULL in regmap_init_mmio. This patch
> > > > > > > fixes this issue, and allows to parse reg endianess only if dev and
> > > > > > > dev->of_node exist.
> > > > > > >
> > > > > > > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > > > > > > ---
> > > > > > >  drivers/base/regmap/regmap.c |   23 ++++++++++++++---------
> > > > > > >  1 file changed, 14 insertions(+), 9 deletions(-)
> > > > > > >
> > > > > > > diff --git a/drivers/base/regmap/regmap.c
> > > > > > > b/drivers/base/regmap/regmap.c index f2281af..455a877 100644
> > > > > > > --- a/drivers/base/regmap/regmap.c
> > > > > > > +++ b/drivers/base/regmap/regmap.c
> > > > > > > @@ -477,7 +477,7 @@ static enum regmap_endian
> > > > > > > regmap_get_val_endian(struct device *dev,
> > > > > > >  					const struct regmap_bus *bus,
> > > > > > >  					const struct regmap_config *config)
> > > > > {
> > > > > > > -	struct device_node *np = dev->of_node;
> > > > > > > +	struct device_node *np;
> > > > > > >  	enum regmap_endian endian;
> > > > > > >
> > > > > > >  	/* Retrieve the endianness specification from the regmap config
> > > > */
> > > > > > > @@ -487,15 +487,20 @@ static enum regmap_endian
> > > > > > > regmap_get_val_endian(struct device *dev,
> > > > > > >  	if (endian != REGMAP_ENDIAN_DEFAULT)
> > > > > > >  		return endian;
> > > > > > >
> > > > > > > -	/* Parse the device's DT node for an endianness specification */
> > > > > > > -	if (of_property_read_bool(np, "big-endian"))
> > > > > > > -		endian = REGMAP_ENDIAN_BIG;
> > > > > > > -	else if (of_property_read_bool(np, "little-endian"))
> > > > > > > -		endian = REGMAP_ENDIAN_LITTLE;
> > > > > > > +	/* If the dev and dev->of_node exist try to get endianness from
> > > > DT
> > > > > > > */
> > > > > > > +	if (dev && dev->of_node) {
> > > > > > > +		np = dev->of_node;
> > > > > > >
> > > > > > > -	/* If the endianness was specified in DT, use that */
> > > > > > > -	if (endian != REGMAP_ENDIAN_DEFAULT)
> > > > > > > -		return endian;
> > > > > > > +		/* Parse the device's DT node for an endianness
> > > > > > > specification */
> > > > > > > +		if (of_property_read_bool(np, "big-endian"))
> > > > > > > +			endian = REGMAP_ENDIAN_BIG;
> > > > > > > +		else if (of_property_read_bool(np, "little-endian"))
> > > > > > > +			endian = REGMAP_ENDIAN_LITTLE;
> > > > > > > +
> > > > > > > +		/* If the endianness was specified in DT, use that */
> > > > > > > +		if (endian != REGMAP_ENDIAN_DEFAULT)
> > > > > > > +			return endian;
> > > > > > > +	}
> > > > > > >
> > > > > > >  	/* Retrieve the endianness specification from the bus config */
> > > > > > >  	if (bus && bus->val_format_endian_default)
> > > > > > > --
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Pankaj Dubey
> > > > > > >
> > > > > > > > Regards
> > > > > > > > Dong Aisheng
> > > > > > > >
> > > > > > > > >
> > > > > > > > > Thanks,
> > > > > > > > > Pankaj Dubey
> > > > > > > > >
> > > > > > > > > > Regards
> > > > > > > > > > Dong Aisheng
> > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > _______________________________________________
> > > > > > > > > > > linux-arm-kernel mailing list
> > > > > > > > > > > linux-arm-kernel@lists.infradead.org
> > > > > > > > > > > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > > > > > > > >
> > > > > > >
> > > > >
