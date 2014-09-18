Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaIRIWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:22:17 -0400
Received: from mail-bl2on0107.outbound.protection.outlook.com ([65.55.169.107]:11584
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754135AbaIRIWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:22:11 -0400
Date: Thu, 18 Sep 2014 15:55:34 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kgene.kim@samsung.com>, <linux@arm.linux.org.uk>, <arnd@arndb.de>,
        <naushad@samsung.com>, <tomasz.figa@gmail.com>, <joshi@samsung.com>,
        <thomas.ab@samsung.com>, <vikas.sajjan@samsung.com>,
        <chow.kim@samsung.com>, <lee.jones@linaro.org>,
        "'Boris BREZILLON'" <boris.brezillon@free-electrons.com>,
        "'Xiubo Li'" <Li.Xiubo@freescale.com>,
        "'Geert Uytterhoeven'" <geert+renesas@glider.be>,
        "'Stephen Warren'" <swarren@nvidia.com>
Subject: Re: [PATCH v3] mfd: syscon: Decouple syscon interface from
 platform devices
Message-ID: <20140918075516.GB15363@shlinux1.ap.freescale.net>
References: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
 <20140917085818.GA10285@shlinux1.ap.freescale.net>
 <000401cfd269$922dfc40$b689f4c0$@samsung.com>
 <20140918030552.GA26661@shlinux1.ap.freescale.net>
 <000701cfd306$4d3e8080$e7bb8180$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <000701cfd306$4d3e8080$e7bb8180$@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(164054003)(199003)(189002)(51704005)(76176999)(84676001)(92566001)(80022003)(54356999)(77982003)(64706001)(6806004)(105606002)(87936001)(50466002)(46102003)(90102001)(83072002)(92726001)(74662003)(19580405001)(44976005)(4396001)(85306004)(97736003)(81542003)(20776003)(33656002)(83322001)(85852003)(102836001)(93886004)(50986999)(19580395003)(81342003)(104016003)(106466001)(76482002)(47776003)(15975445006)(83506001)(31966008)(46406003)(23726002)(74502003)(99396002)(107046002)(21056001)(97756001)(26826002)(95666004)(15202345003)(79102003)(110136001)(68736004)(21314002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0612;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Aisheng.Dong@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0754;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 11:33:26AM +0530, Pankaj Dubey wrote:
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

I tested the patch work.
But as Xiubo pointed in another mail, it may still cause other issues.
Looking at regmap.c, there're still some other places using the device pointer,
e.g. dev_xxx debug information and some tracepoints also take device pointer
as parameter(not sure if it will break if dev is NULL).
Another thing is that if dev is NULL, we may not be able to use regmap debugfs
feature which seems also not as our expected.

Maybe we could consider create device structure for each syscon compatible
device in syscon driver in of_syscon_register in first time which seems to
be reasonable.

Regards
Dong Aisheng

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
> 
