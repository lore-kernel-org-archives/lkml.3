Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbaISDiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 23:38:11 -0400
Received: from mail-bn1on0118.outbound.protection.outlook.com ([157.56.110.118]:63277
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751294AbaISDiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 23:38:08 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "Aisheng.Dong@freescale.com" <Aisheng.Dong@freescale.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
CC: "arnd@arndb.de" <arnd@arndb.de>,
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
Subject: RE: [PATCH v3] mfd: syscon: Decouple syscon interface from platform
 devices
Thread-Topic: [PATCH v3] mfd: syscon: Decouple syscon interface from platform
 devices
Thread-Index: AQHP0kIqUorD0T+DMkOGT4aDDQhODZwFBqQAgAAntgCAAQgOgIAAMZkAgAAfVACAABxWgIAAB+AAgAEKw2A=
Date: Fri, 19 Sep 2014 03:38:03 +0000
Message-ID: <48f9f4067cc44ad49297bb4b62c56c88@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
 <20140917085818.GA10285@shlinux1.ap.freescale.net>
 <000401cfd269$922dfc40$b689f4c0$@samsung.com>
 <20140918030552.GA26661@shlinux1.ap.freescale.net>
 <000701cfd306$4d3e8080$e7bb8180$@samsung.com>
 <20140918075516.GB15363@shlinux1.ap.freescale.net>
 <000c01cfd324$1f2cd930$5d868b90$@samsung.com>
 <20140918100505.GA19346@shlinux1.ap.freescale.net>
In-Reply-To: <20140918100505.GA19346@shlinux1.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(52604005)(164054003)(189002)(199003)(2656002)(106356001)(83322001)(99286002)(20776003)(90102001)(15975445006)(64706001)(76176999)(87936001)(101416001)(77096002)(74316001)(50986999)(85306004)(97736003)(108616004)(15202345003)(81342003)(99396002)(54356999)(46102003)(85852003)(105586002)(66066001)(33646002)(106116001)(79102003)(76576001)(31966008)(95666004)(19580395003)(21056001)(76482002)(74662003)(4396001)(86362001)(80022003)(92566001)(19580405001)(74502003)(77982003)(81542003)(107046002)(93886004)(83072002)(21314002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB330;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Thanks for testing. In that case I will post this change, as I feel this
> > should be
> > fixed irrespective of my syscon patch.
> >
> > > But as Xiubo pointed in another mail, it may still cause other issues.
> > > Looking at regmap.c, there're still some other places using the device
> > pointer, e.g.
> > > dev_xxx debug information and some tracepoints also take device pointer as
> > > parameter(not sure if it will break if dev is NULL).
> > > Another thing is that if dev is NULL, we may not be able to use regmap
> > debugfs
> > > feature which seems also not as our expected.
> > >
> >
> > I would have preferred to check dev for NULL, as it's only at two places and
> > we could
> > still have debug prints for NULL dev, as normal pr_info instead of dev_info.
> >
> > But Xiubo also pointed out that his patch [1] which updates syscon binding
> > information
> > will be useless if we pass NULL dev in regmap_init_mmio, which he posted
> > today,
> > and it requires dev pointer in "regmap_get_val_endian" function to read DT
> > property.
> >
> > [1]: [PATCH] mfd: syscon: binding: Add syscon endianness support
> >       https://lkml.org/lkml/2014/9/18/67
> >
> > So instead of adding dummy device or creating device structure, I would
> > prefer to get actual
> > device pointer corresponding to "np" passed in of_syscon_register function
> > as shown below:
> >
> 
> I wonder this may not work at early stage before the devices are populated
> from device tree.
> My initial understanding that one important thing for your patch is
> to address this issue, isn't it?
> Many people have asked for this feature before.
> 

My boot log:

   ...
of_platform_bus_create() - skipping /chosen, no compatible prop
of_platform_bus_create() - skipping /aliases, no compatible prop
of_platform_bus_create() - skipping /memory, no compatible prop
of_platform_bus_create() - skipping /cpus, no compatible prop
   create child: /soc/smmu@1200000
   create child: /soc/smmu@1280000
   create child: /soc/smmu@1300000
   create child: /soc/smmu@1380000
   create child: /soc/interrupt-controller@1400000
   create child: /soc/tzasc@1500000
of_platform_bus_create() - skipping /soc/tzasc@1500000, no compatible prop
   create child: /soc/ifc@1530000
   create child: /soc/ifc@1530000/nor@0,0
   create child: /soc/ifc@1530000/board-control@2,0
   create child: /soc/dcfg@1ee0000
syscon 1ee0000.dcfg: regmap [mem 0x01ee0000-0x01eeffff] registered
   create child: /soc/quadspi@1550000
   create child: /soc/esdhc@1560000
   create child: /soc/scfg@1570000
   create child: /soc/crypto@1700000
   create child: /soc/sfp@1e80000
of_platform_bus_create() - skipping /soc/sfp@1e80000, no compatible prop
   create child: /soc/snvs@1e90000
of_platform_bus_create() - skipping /soc/snvs@1e90000, no compatible prop
   create child: /soc/serdes1@1ea0000
of_platform_bus_create() - skipping /soc/serdes1@1ea0000, no compatible prop
   create child: /soc/clocking@1ee1000
   create child: /soc/rcpm@1ee2000
   create child: /soc/dspi@2100000
   create child: /soc/dspi@2110000
   create child: /soc/i2c@2180000
   create child: /soc/i2c@2190000
   create child: /soc/i2c@21a0000
   create child: /soc/serial@21c0500
   create child: /soc/serial@21c0600
   create child: /soc/serial@21d0500
   create child: /soc/serial@21d0600
   create child: /soc/gpio@2300000
   create child: /soc/gpio@2310000
   create child: /soc/gpio@2320000
   create child: /soc/gpio@2330000
   create child: /soc/uqe@2400000
   create child: /soc/uqe@2400000/qeic@80
   create child: /soc/uqe@2400000/ucc@2000
irq: no irq domain found for /soc/uqe@2400000/qeic@80 !
   create child: /soc/uqe@2400000/ucc@2200
irq: no irq domain found for /soc/uqe@2400000/qeic@80 !
   create child: /soc/uqe@2400000/muram@10000
   create child: /soc/uqe@2400000/si@700
   create child: /soc/uqe@2400000/siram@1000
   create child: /soc/serial@2950000
   create child: /soc/serial@2960000
   create child: /soc/serial@2970000
   create child: /soc/serial@2980000
   create child: /soc/serial@2990000
   create child: /soc/serial@29a0000
   create child: /soc/ftm0_1@29d0000
   create child: /soc/ftm@29f0000
of_platform_bus_create() - skipping /soc/ftm@29f0000, no compatible prop
   create child: /soc/ftm@2a00000
   create child: /soc/ftm@2a10000
of_platform_bus_create() - skipping /soc/ftm@2a10000, no compatible prop
   create child: /soc/ftm@2a20000
of_platform_bus_create() - skipping /soc/ftm@2a20000, no compatible prop
   create child: /soc/ftm@2a30000
   create child: /soc/ftm@2a40000
   create child: /soc/wdog@2ad0000
   create child: /soc/sai@2b60000
   create child: /soc/edma@2c00000
   create child: /soc/dcu@2ce0000
   create child: /soc/mdio@2d24000
   create child: /soc/ptp_clock@2d10e00
   create child: /soc/ethernet@2d10000
   create child: /soc/ethernet@2d50000
   create child: /soc/ethernet@2d90000
   create child: /soc/usb@8600000
   create child: /soc/usb3@3100000
   create child: /soc/can@2a70000
   create child: /soc/can@2a80000
   create child: /soc/can@2a90000
   create child: /soc/can@2aa0000
   create child: /soc/pcie@3400000
   create child: /soc/pcie@3500000
   create child: /dcsr@20000000/dcsr-epu@0
   create child: /dcsr@20000000/dcsr-gdi@100000
   create child: /dcsr@20000000/dcsr-dddi@120000
   create child: /dcsr@20000000/dcsr-dcfg@220000
   create child: /dcsr@20000000/dcsr-clock@221000
   create child: /dcsr@20000000/dcsr-rcpm@222000
   create child: /dcsr@20000000/dcsr-ccp@225000
   create child: /dcsr@20000000/dcsr-fusectrl@226000
   create child: /dcsr@20000000/dcsr-dap@300000
   create child: /dcsr@20000000/dcsr-cstf@350000
   create child: /dcsr@20000000/dcsr-a7rom@360000
   create child: /dcsr@20000000/dcsr-a7cpu@370000
   create child: /dcsr@20000000/dcsr-a7cti@378000
   create child: /dcsr@20000000/dcsr-etm@37c000
   create child: /dcsr@20000000/dcsr-hugorom@3a0000
   create child: /dcsr@20000000/dcsr-etf@3a1000
   create child: /dcsr@20000000/dcsr-etr@3a3000
   create child: /dcsr@20000000/dcsr-cti@3a4000
   create child: /dcsr@20000000/dcsr-atbrepl@3a8000
   create child: /dcsr@20000000/dcsr-tsgen-ctrl@3a9000
   create child: /dcsr@20000000/dcsr-tsgen-read@3aa000
   create child: /regulators/regulator@0
   ...

As default the Linux will create all the platform device for each DT node, which
Can be found from "drivers/of/platform.c".

So we can get the pdev node using the specified DT node, and feel safe to use
it as Pankaj's patch does.

And also we must make sure that the 'syscon' DT nodes has the compatible prop.

Thanks,

BRs
Xiubo


> Regards
> Dong Aisheng
> 
> > ----
> > static struct syscon *of_syscon_register(struct device_node *np)
> >  {
> > +	struct platform_device *pdev;
> >  	struct syscon *syscon;
> >  	struct regmap *regmap;
> >  	void __iomem *base;
> > @@ -142,7 +144,11 @@ static struct syscon *of_syscon_register(struct
> > device_node *np)
> >  	if (!base)
> >  		return ERR_PTR(-ENOMEM);
> >
> > -	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
> > +	pdev = of_find_device_by_node(np);
> > +	if (!(&pdev->dev))
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	regmap = regmap_init_mmio(&pdev->dev, base, &syscon_regmap_config);
> >  	if (IS_ERR(regmap)) {
> >  		pr_err("regmap init failed\n");
> >  		return ERR_CAST(regmap);
> > -------
> >
> > I have tested this in linux-next and it works well. In this way there won't
> > be any issues of
> > dereferencing NULL pointer in regmap.c and at the same time, if DT has
> > {big,little}-endian
> > optional property in syscon device node, it will be taken care.
> >
> > So I would wait for Arnd's opinion about above mentioned changes and then
> > post a new
> > change after addressing Arnd's minor comment along with this fix in next
> > revision.
> >
> >
> > Thanks,
> > Pankaj Dubey
> > > Maybe we could consider create device structure for each syscon compatible
> > device in
> > > syscon driver in of_syscon_register in first time which seems to be
> > reasonable.
> > >
> > > Regards
> > > Dong Aisheng
> > >
> > > > --------------------------------------------
> > > > Subject: [PATCH] regmap: fix NULL pointer dereference in
> > > > regmap_get_val_endian
> > > >
> > > > Recent commits for getting reg endianess causing NULL pointer
> > > > dereference if dev is passed NULL in regmap_init_mmio. This patch
> > > > fixes this issue, and allows to parse reg endianess only if dev and
> > > > dev->of_node exist.
> > > >
> > > > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > > > ---
> > > >  drivers/base/regmap/regmap.c |   23 ++++++++++++++---------
> > > >  1 file changed, 14 insertions(+), 9 deletions(-)
> > > >
> > > > diff --git a/drivers/base/regmap/regmap.c
> > > > b/drivers/base/regmap/regmap.c index f2281af..455a877 100644
> > > > --- a/drivers/base/regmap/regmap.c
> > > > +++ b/drivers/base/regmap/regmap.c
> > > > @@ -477,7 +477,7 @@ static enum regmap_endian
> > > > regmap_get_val_endian(struct device *dev,
> > > >  					const struct regmap_bus *bus,
> > > >  					const struct regmap_config *config)
> > {
> > > > -	struct device_node *np = dev->of_node;
> > > > +	struct device_node *np;
> > > >  	enum regmap_endian endian;
> > > >
> > > >  	/* Retrieve the endianness specification from the regmap config
> */
> > > > @@ -487,15 +487,20 @@ static enum regmap_endian
> > > > regmap_get_val_endian(struct device *dev,
> > > >  	if (endian != REGMAP_ENDIAN_DEFAULT)
> > > >  		return endian;
> > > >
> > > > -	/* Parse the device's DT node for an endianness specification */
> > > > -	if (of_property_read_bool(np, "big-endian"))
> > > > -		endian = REGMAP_ENDIAN_BIG;
> > > > -	else if (of_property_read_bool(np, "little-endian"))
> > > > -		endian = REGMAP_ENDIAN_LITTLE;
> > > > +	/* If the dev and dev->of_node exist try to get endianness from
> DT
> > > > */
> > > > +	if (dev && dev->of_node) {
> > > > +		np = dev->of_node;
> > > >
> > > > -	/* If the endianness was specified in DT, use that */
> > > > -	if (endian != REGMAP_ENDIAN_DEFAULT)
> > > > -		return endian;
> > > > +		/* Parse the device's DT node for an endianness
> > > > specification */
> > > > +		if (of_property_read_bool(np, "big-endian"))
> > > > +			endian = REGMAP_ENDIAN_BIG;
> > > > +		else if (of_property_read_bool(np, "little-endian"))
> > > > +			endian = REGMAP_ENDIAN_LITTLE;
> > > > +
> > > > +		/* If the endianness was specified in DT, use that */
> > > > +		if (endian != REGMAP_ENDIAN_DEFAULT)
> > > > +			return endian;
> > > > +	}
> > > >
> > > >  	/* Retrieve the endianness specification from the bus config */
> > > >  	if (bus && bus->val_format_endian_default)
> > > > --
> > > >
> > > > Thanks,
> > > > Pankaj Dubey
> > > >
> > > > > Regards
> > > > > Dong Aisheng
> > > > >
> > > > > >
> > > > > > Thanks,
> > > > > > Pankaj Dubey
> > > > > >
> > > > > > > Regards
> > > > > > > Dong Aisheng
> > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > _______________________________________________
> > > > > > > > linux-arm-kernel mailing list
> > > > > > > > linux-arm-kernel@lists.infradead.org
> > > > > > > > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > > > > >
> > > >
> >
