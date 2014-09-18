Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbaIRGdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 02:33:36 -0400
Received: from mail-bn1bn0105.outbound.protection.outlook.com ([157.56.110.105]:56242
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752778AbaIRGdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 02:33:32 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        "Aisheng.Dong@freescale.com" <Aisheng.Dong@freescale.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
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
Thread-Index: AQHP0kIqUorD0T+DMkOGT4aDDQhODZwFBqQAgAAntgCAAQgOgIAAMZkAgAAEmqA=
Date: Thu, 18 Sep 2014 06:33:24 +0000
Message-ID: <c93278a6da2b40649089426026a857f7@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
 <20140917085818.GA10285@shlinux1.ap.freescale.net>
 <000401cfd269$922dfc40$b689f4c0$@samsung.com>
 <20140918030552.GA26661@shlinux1.ap.freescale.net>
 <000701cfd306$4d3e8080$e7bb8180$@samsung.com>
In-Reply-To: <000701cfd306$4d3e8080$e7bb8180$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB333;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(377454003)(164054003)(51704005)(189002)(199003)(24454002)(74502003)(106116001)(74316001)(92566001)(77096002)(15202345003)(66066001)(33646002)(31966008)(95666004)(19580395003)(20776003)(99286002)(86362001)(87936001)(105586002)(2656002)(76176999)(4396001)(15975445006)(93886004)(76576001)(74662003)(21056001)(90102001)(99396002)(64706001)(77982003)(107046002)(85306004)(106356001)(54356999)(85852003)(81342003)(79102003)(97736003)(81542003)(83072002)(83322001)(76482002)(50986999)(80022003)(108616004)(46102003)(101416001)(19580405001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB333;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

One more question:
For example:

regmap_read()
    ----> _regmap_read()
        ----> 2112 #ifdef LOG_DEVICE
        ----> 2113                 if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
        ----> 2114                         dev_info(map->dev, "%x => %x\n", reg, *val);
        ----> 2115 #endif 

In dev_name(map->dev) will also encounter the same crash core trace like in
regmap_get_val_endian(dev, ...).

Could there be another method, such as using 'dummy dev' instead of 'NULL dev' ?
Just one suggestion.


BRs
Xiubo


> -----Original Message-----
> From: Pankaj Dubey [mailto:pankaj.dubey@samsung.com]
> Sent: Thursday, September 18, 2014 2:03 PM
> To: Dong Aisheng-B29396
> Cc: linux-arm-kernel@lists.infradead.org; linux-samsung-soc@vger.kernel.org;
> linux-kernel@vger.kernel.org; kgene.kim@samsung.com; linux@arm.linux.org.uk;
> arnd@arndb.de; naushad@samsung.com; tomasz.figa@gmail.com; joshi@samsung.com;
> thomas.ab@samsung.com; vikas.sajjan@samsung.com; chow.kim@samsung.com;
> lee.jones@linaro.org; 'Boris BREZILLON'; Xiubo Li-B47053; 'Geert Uytterhoeven';
> 'Stephen Warren'
> Subject: RE: [PATCH v3] mfd: syscon: Decouple syscon interface from platform
> devices
> 
> Hi,
> 
> Adding CC to Xiubo Li, Geert Uytterhoeven and Stephen Warren.
> 
> On Thursday, September 18, 2014, Dong Aisheng wrote,
> > On Wed, Sep 17, 2014 at 04:50:50PM +0530, Pankaj Dubey wrote:
> > > Hi,
> > >
> > > On Wednesday, September 17, 2014, Dong Aisheng Wrote,
> > > > >
> > > > > +	regmap = regmap_init_mmio(NULL, base,
> &syscon_regmap_config);
> > > >
> > > > Does a NULL device pointer work?
> > >
> > > Yes, it is safe, at least we are able to test on Exynos based SoC.
> > > I have tested it with kgene/for-next kernel on Exynos3250.
> > > Also it has been tested on Exynos5250 based Snow board with 3.17-rc5
> > > based kernel by Vivek Gautam.
> > >
> > > Patch V2 also has been tested by "Borris Brezillon" on AT91 platform.
> > >
> > >
> >
> > The kernel i tested was next-20140915 of linux-next.
> >
> > please see regmap_get_val_endian called in regmap_init function.
> > static enum regmap_endian regmap_get_val_endian(struct device *dev,
> >                                         const struct regmap_bus *bus,
> >                                         const struct regmap_config
> *config) {
> >         struct device_node *np = dev->of_node;
> >         enum regmap_endian endian;
> > ...
> > }
> > It will crash at the first line of dev->of_node if dev is NULL.
> >
> > Can you check if you're using the same code as mine?
> 
> No, it's not same.
> My bad that I was not using linux-next for testing this patch.
> We tested on kgene/for-next where these changes still have not come.
> Just now I checked linux-next and found that it will crash at first line of
> "regmap_get_val_endian" as there is no check for NULL on dev.
> 
> I checked git history of regmap.c file and found recently this file has been
> modified
> for adding DT endianness binding support. Following are set of patches gone
> for this
> 
> cf673fb regmap: Split regmap_get_endian() in two functions
> 5844a8b regmap: Fix handling of volatile registers for format_write() chips
> 45e1a27 regmap: of_regmap_get_endian() cleanup
> ba1b53f regmap: Fix DT endianess parsing logic
> d647c19 regmap: add DT endianness binding support.
> 
> I think there should have been a check for NULL on "dev" in
> "regmap_get_val_endian", so that if dev pointer exist then only it makes
> sense to get
> endianness property from DT.
> 
> I will suggest following fix in regmap.c for this. With following fix I
> tested it and it works well
> on linux-next also. So if you can confirm following fix is working for you
> then I can post this
> patch.
> 
> --------------------------------------------
> Subject: [PATCH] regmap: fix NULL pointer dereference in
>  regmap_get_val_endian
> 
> Recent commits for getting reg endianess causing NULL pointer
> dereference if dev is passed NULL in regmap_init_mmio. This patch
> fixes this issue, and allows to parse reg endianess only if dev
> and dev->of_node exist.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  drivers/base/regmap/regmap.c |   23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index f2281af..455a877 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -477,7 +477,7 @@ static enum regmap_endian regmap_get_val_endian(struct
> device *dev,
>  					const struct regmap_bus *bus,
>  					const struct regmap_config *config)
>  {
> -	struct device_node *np = dev->of_node;
> +	struct device_node *np;
>  	enum regmap_endian endian;
> 
>  	/* Retrieve the endianness specification from the regmap config */
> @@ -487,15 +487,20 @@ static enum regmap_endian regmap_get_val_endian(struct
> device *dev,
>  	if (endian != REGMAP_ENDIAN_DEFAULT)
>  		return endian;
> 
> -	/* Parse the device's DT node for an endianness specification */
> -	if (of_property_read_bool(np, "big-endian"))
> -		endian = REGMAP_ENDIAN_BIG;
> -	else if (of_property_read_bool(np, "little-endian"))
> -		endian = REGMAP_ENDIAN_LITTLE;
> +	/* If the dev and dev->of_node exist try to get endianness from DT
> */
> +	if (dev && dev->of_node) {
> +		np = dev->of_node;
> 
> -	/* If the endianness was specified in DT, use that */
> -	if (endian != REGMAP_ENDIAN_DEFAULT)
> -		return endian;
> +		/* Parse the device's DT node for an endianness
> specification */
> +		if (of_property_read_bool(np, "big-endian"))
> +			endian = REGMAP_ENDIAN_BIG;
> +		else if (of_property_read_bool(np, "little-endian"))
> +			endian = REGMAP_ENDIAN_LITTLE;
> +
> +		/* If the endianness was specified in DT, use that */
> +		if (endian != REGMAP_ENDIAN_DEFAULT)
> +			return endian;
> +	}
> 
>  	/* Retrieve the endianness specification from the bus config */
>  	if (bus && bus->val_format_endian_default)
> --
> 
> Thanks,
> Pankaj Dubey
> 
> > Regards
> > Dong Aisheng
> >
> > >
> > > Thanks,
> > > Pankaj Dubey
> > >
> > > > Regards
> > > > Dong Aisheng
> > > >
> > > > >
> > > > >
> > > > > _______________________________________________
> > > > > linux-arm-kernel mailing list
> > > > > linux-arm-kernel@lists.infradead.org
> > > > > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > >

