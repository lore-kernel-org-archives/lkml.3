Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbaIRKqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 06:46:37 -0400
Received: from mail-bl2on0148.outbound.protection.outlook.com ([65.55.169.148]:62400
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755755AbaIRKqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:46:35 -0400
Date: Thu, 18 Sep 2014 18:05:10 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
CC: "'Xiubo Li'" <Li.Xiubo@freescale.com>, <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kgene.kim@samsung.com>, <linux@arm.linux.org.uk>,
        <naushad@samsung.com>, <tomasz.figa@gmail.com>, <joshi@samsung.com>,
        <thomas.ab@samsung.com>, <vikas.sajjan@samsung.com>,
        <chow.kim@samsung.com>, <lee.jones@linaro.org>,
        "'Boris BREZILLON'" <boris.brezillon@free-electrons.com>,
        "'Geert Uytterhoeven'" <geert+renesas@glider.be>,
        "'Stephen Warren'" <swarren@nvidia.com>
Subject: Re: [PATCH v3] mfd: syscon: Decouple syscon interface from
 platform devices
Message-ID: <20140918100505.GA19346@shlinux1.ap.freescale.net>
References: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
 <20140917085818.GA10285@shlinux1.ap.freescale.net>
 <000401cfd269$922dfc40$b689f4c0$@samsung.com>
 <20140918030552.GA26661@shlinux1.ap.freescale.net>
 <000701cfd306$4d3e8080$e7bb8180$@samsung.com>
 <20140918075516.GB15363@shlinux1.ap.freescale.net>
 <000c01cfd324$1f2cd930$5d868b90$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <000c01cfd324$1f2cd930$5d868b90$@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(164054003)(24454002)(52604005)(51704005)(189002)(31966008)(92726001)(102836001)(26826002)(84676001)(104016003)(4396001)(15975445006)(105606002)(76176999)(97756001)(85306004)(33656002)(54356999)(110136001)(87936001)(99396002)(20776003)(90102001)(106466001)(21056001)(74502003)(64706001)(93886004)(83322001)(95666004)(23726002)(92566001)(6806004)(97736003)(107046002)(19580395003)(77982003)(85852003)(50986999)(19580405001)(44976005)(83506001)(50466002)(79102003)(74662003)(46406003)(81542003)(81342003)(15202345003)(47776003)(80022003)(76482002)(46102003)(68736004)(83072002)(21314002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0610;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Aisheng.Dong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 03:06:59PM +0530, Pankaj Dubey wrote:
> Hi,
> 
> On September 18, 2014 1:26, Dong Aisheng wrote
> > On Thu, Sep 18, 2014 at 11:33:26AM +0530, Pankaj Dubey wrote:
> > > Hi,
> > >
> > > Adding CC to Xiubo Li, Geert Uytterhoeven and Stephen Warren.
> > >
> > > On Thursday, September 18, 2014, Dong Aisheng wrote,
> > > > On Wed, Sep 17, 2014 at 04:50:50PM +0530, Pankaj Dubey wrote:
> > > > > Hi,
> > > > >
> > > > > On Wednesday, September 17, 2014, Dong Aisheng Wrote,
> > > > > > >
> > > > > > > +	regmap = regmap_init_mmio(NULL, base,
> > > &syscon_regmap_config);
> > > > > >
> > > > > > Does a NULL device pointer work?
> > > > >
> > > > > Yes, it is safe, at least we are able to test on Exynos based SoC.
> > > > > I have tested it with kgene/for-next kernel on Exynos3250.
> > > > > Also it has been tested on Exynos5250 based Snow board with
> > > > > 3.17-rc5 based kernel by Vivek Gautam.
> > > > >
> > > > > Patch V2 also has been tested by "Borris Brezillon" on AT91
> platform.
> > > > >
> > > > >
> > > >
> > > > The kernel i tested was next-20140915 of linux-next.
> > > >
> > > > please see regmap_get_val_endian called in regmap_init function.
> > > > static enum regmap_endian regmap_get_val_endian(struct device *dev,
> > > >                                         const struct regmap_bus *bus,
> > > >                                         const struct regmap_config
> > > *config) {
> > > >         struct device_node *np = dev->of_node;
> > > >         enum regmap_endian endian;
> > > > ...
> > > > }
> > > > It will crash at the first line of dev->of_node if dev is NULL.
> > > >
> > > > Can you check if you're using the same code as mine?
> > >
> > > No, it's not same.
> > > My bad that I was not using linux-next for testing this patch.
> > > We tested on kgene/for-next where these changes still have not come.
> > > Just now I checked linux-next and found that it will crash at first
> > > line of "regmap_get_val_endian" as there is no check for NULL on dev.
> > >
> > > I checked git history of regmap.c file and found recently this file
> > > has been modified for adding DT endianness binding support. Following
> > > are set of patches gone for this
> > >
> > > cf673fb regmap: Split regmap_get_endian() in two functions 5844a8b
> > > regmap: Fix handling of volatile registers for format_write() chips
> > > 45e1a27 regmap: of_regmap_get_endian() cleanup ba1b53f regmap: Fix DT
> > > endianess parsing logic
> > > d647c19 regmap: add DT endianness binding support.
> > >
> > > I think there should have been a check for NULL on "dev" in
> > > "regmap_get_val_endian", so that if dev pointer exist then only it
> > > makes sense to get endianness property from DT.
> > >
> > > I will suggest following fix in regmap.c for this. With following fix
> > > I tested it and it works well on linux-next also. So if you can
> > > confirm following fix is working for you then I can post this patch.
> > >
> > 
> > I tested the patch work.
> 
> Thanks for testing. In that case I will post this change, as I feel this
> should be
> fixed irrespective of my syscon patch.
> 
> > But as Xiubo pointed in another mail, it may still cause other issues.
> > Looking at regmap.c, there're still some other places using the device
> pointer, e.g.
> > dev_xxx debug information and some tracepoints also take device pointer as
> > parameter(not sure if it will break if dev is NULL).
> > Another thing is that if dev is NULL, we may not be able to use regmap
> debugfs
> > feature which seems also not as our expected.
> > 
> 
> I would have preferred to check dev for NULL, as it's only at two places and
> we could
> still have debug prints for NULL dev, as normal pr_info instead of dev_info.
> 
> But Xiubo also pointed out that his patch [1] which updates syscon binding
> information
> will be useless if we pass NULL dev in regmap_init_mmio, which he posted
> today,
> and it requires dev pointer in "regmap_get_val_endian" function to read DT
> property.
> 
> [1]: [PATCH] mfd: syscon: binding: Add syscon endianness support
>       https://lkml.org/lkml/2014/9/18/67
> 
> So instead of adding dummy device or creating device structure, I would
> prefer to get actual
> device pointer corresponding to "np" passed in of_syscon_register function
> as shown below:
> 

I wonder this may not work at early stage before the devices are populated
from device tree.
My initial understanding that one important thing for your patch is
to address this issue, isn't it?
Many people have asked for this feature before.

Regards
Dong Aisheng

> ----
> static struct syscon *of_syscon_register(struct device_node *np)
>  {
> +	struct platform_device *pdev;
>  	struct syscon *syscon;
>  	struct regmap *regmap;
>  	void __iomem *base;
> @@ -142,7 +144,11 @@ static struct syscon *of_syscon_register(struct
> device_node *np)
>  	if (!base)
>  		return ERR_PTR(-ENOMEM);
>  
> -	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
> +	pdev = of_find_device_by_node(np);
> +	if (!(&pdev->dev))
> +		return ERR_PTR(-ENODEV);
> +
> +	regmap = regmap_init_mmio(&pdev->dev, base, &syscon_regmap_config);
>  	if (IS_ERR(regmap)) {
>  		pr_err("regmap init failed\n");
>  		return ERR_CAST(regmap);
> -------
> 
> I have tested this in linux-next and it works well. In this way there won't
> be any issues of 
> dereferencing NULL pointer in regmap.c and at the same time, if DT has
> {big,little}-endian
> optional property in syscon device node, it will be taken care.
> 
> So I would wait for Arnd's opinion about above mentioned changes and then
> post a new
> change after addressing Arnd's minor comment along with this fix in next
> revision.
> 
> 
> Thanks,
> Pankaj Dubey
> > Maybe we could consider create device structure for each syscon compatible
> device in
> > syscon driver in of_syscon_register in first time which seems to be
> reasonable.
> > 
> > Regards
> > Dong Aisheng
> > 
> > > --------------------------------------------
> > > Subject: [PATCH] regmap: fix NULL pointer dereference in
> > > regmap_get_val_endian
> > >
> > > Recent commits for getting reg endianess causing NULL pointer
> > > dereference if dev is passed NULL in regmap_init_mmio. This patch
> > > fixes this issue, and allows to parse reg endianess only if dev and
> > > dev->of_node exist.
> > >
> > > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > > ---
> > >  drivers/base/regmap/regmap.c |   23 ++++++++++++++---------
> > >  1 file changed, 14 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/base/regmap/regmap.c
> > > b/drivers/base/regmap/regmap.c index f2281af..455a877 100644
> > > --- a/drivers/base/regmap/regmap.c
> > > +++ b/drivers/base/regmap/regmap.c
> > > @@ -477,7 +477,7 @@ static enum regmap_endian
> > > regmap_get_val_endian(struct device *dev,
> > >  					const struct regmap_bus *bus,
> > >  					const struct regmap_config *config)
> {
> > > -	struct device_node *np = dev->of_node;
> > > +	struct device_node *np;
> > >  	enum regmap_endian endian;
> > >
> > >  	/* Retrieve the endianness specification from the regmap config */
> > > @@ -487,15 +487,20 @@ static enum regmap_endian
> > > regmap_get_val_endian(struct device *dev,
> > >  	if (endian != REGMAP_ENDIAN_DEFAULT)
> > >  		return endian;
> > >
> > > -	/* Parse the device's DT node for an endianness specification */
> > > -	if (of_property_read_bool(np, "big-endian"))
> > > -		endian = REGMAP_ENDIAN_BIG;
> > > -	else if (of_property_read_bool(np, "little-endian"))
> > > -		endian = REGMAP_ENDIAN_LITTLE;
> > > +	/* If the dev and dev->of_node exist try to get endianness from DT
> > > */
> > > +	if (dev && dev->of_node) {
> > > +		np = dev->of_node;
> > >
> > > -	/* If the endianness was specified in DT, use that */
> > > -	if (endian != REGMAP_ENDIAN_DEFAULT)
> > > -		return endian;
> > > +		/* Parse the device's DT node for an endianness
> > > specification */
> > > +		if (of_property_read_bool(np, "big-endian"))
> > > +			endian = REGMAP_ENDIAN_BIG;
> > > +		else if (of_property_read_bool(np, "little-endian"))
> > > +			endian = REGMAP_ENDIAN_LITTLE;
> > > +
> > > +		/* If the endianness was specified in DT, use that */
> > > +		if (endian != REGMAP_ENDIAN_DEFAULT)
> > > +			return endian;
> > > +	}
> > >
> > >  	/* Retrieve the endianness specification from the bus config */
> > >  	if (bus && bus->val_format_endian_default)
> > > --
> > >
> > > Thanks,
> > > Pankaj Dubey
> > >
> > > > Regards
> > > > Dong Aisheng
> > > >
> > > > >
> > > > > Thanks,
> > > > > Pankaj Dubey
> > > > >
> > > > > > Regards
> > > > > > Dong Aisheng
> > > > > >
> > > > > > >
> > > > > > >
> > > > > > > _______________________________________________
> > > > > > > linux-arm-kernel mailing list
> > > > > > > linux-arm-kernel@lists.infradead.org
> > > > > > > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > > > >
> > >
> 
