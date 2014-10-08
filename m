Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaJHGqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:46:30 -0400
Received: from sauhun.de ([89.238.76.85]:54804 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbaJHGq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:46:28 -0400
Date: Wed, 8 Oct 2014 08:46:59 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Yao Yuan <yao.yuan@freescale.com>
Cc: "marex@denx.de" <marex@denx.de>,
        "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "fugang.duan@freescale.com" <fugang.duan@freescale.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v8 1/2] i2c: imx: add DMA support for freescale i2c driver
Message-ID: <20141008064659.GA1264@katana>
References: <1411632689-31531-1-git-send-email-yao.yuan@freescale.com>
 <1411632689-31531-2-git-send-email-yao.yuan@freescale.com>
 <20141003075441.GA1349@katana>
 <3cd0b028391140b9a75cddf58dbe40b8@DM2PR03MB349.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <3cd0b028391140b9a75cddf58dbe40b8@DM2PR03MB349.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2014 at 06:30:14AM +0000, Yao Yuan wrote:
> > -----Original Message-----
> > From: Wolfram Sang [mailto:wsa@the-dreams.de]
> > Sent: Friday, October 03, 2014 3:55 PM
> > To: Yuan Yao-B46683
> > Cc: marex@denx.de; LW@KARO-electronics.de; mark.rutland@arm.com; Duan
> > Fugang-B38611; shawn.guo@linaro.org; linux-kernel@vger.kernel.org; linu=
x-
> > arm-kernel@lists.infradead.org; linux-i2c@vger.kernel.org
> > Subject: Re: [PATCH v8 1/2] i2c: imx: add DMA support for freescale i2c
> > driver
> > > -#include <linux/init.h>
> > > -#include <linux/kernel.h>
> > > -#include <linux/module.h>
> > > +#include <linux/clk.h>
> > > +#include <linux/completion.h>
> > > +#include <linux/delay.h>
> > > +#include <linux/dma-mapping.h>
> > > +#include <linux/dmaengine.h>
> > > +#include <linux/dmapool.h>
> > >  #include <linux/errno.h>
> > >  #include <linux/err.h>
> > >  #include <linux/interrupt.h>
> > > -#include <linux/delay.h>
> > >  #include <linux/i2c.h>
> > > +#include <linux/init.h>
> > >  #include <linux/io.h>
> > > -#include <linux/sched.h>
> > > -#include <linux/platform_device.h>
> > > -#include <linux/clk.h>
> > > -#include <linux/slab.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > >  #include <linux/of.h>
> > >  #include <linux/of_device.h>
> > > +#include <linux/of_dma.h>
> > >  #include <linux/platform_data/i2c-imx.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/sched.h>
> > > +#include <linux/slab.h>
> >=20
> > This is a seperate patch.
>=20
> [Yuan Yao]=20
> Here I just adjust the order of the include file as alphabetical order.
> If it looks strange I can only add the include files about DMA.

It doesn't look strange, it makes sense to do that. However, this should
be a seperate patch.

a) sort includes
b) add the dma includes in the dma patch

> After DMA callback, I must wait until the last byte transfer completely.
> It's a very short time which less than 10us.
> By the way, how about use udelay(10) instead of schedule()?
> udelay(10) is waiting a appropriate time.
> schedule() is waiting too long for i2c but may be good for whole system.
> Can you give me some suggestion?

It doesn't matter much. Leave it as it is. If somebody wants to change
it, it can be patched.


--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNN3jAAoJEBQN5MwUoCm2tQsP/RSToURuxuC+pyUo4cWcPsM8
xzaq/7HzEanP7a3nzih1aN1UYigWJ9slbxRZ1QOMtZjminJotWhSe37CYziFIRjY
AvS8ptYycv5jBkC/kDeeCrXssT8UI3544KKLbbEHg68C5TAipys4F3NE1ttH9U4m
V+PeJKucCaqhFmveF2oIYODEeMWgDRy1TQyJdrKPZkvX8P5Y6ZCiSU2MSSNUoyKH
IB9b9uxJeIyFhEpMmP+aciOHEgCL4B42TG470/x9gvYTMfbahAL/M9oWB0zpbjxL
p98U0pZY9dcsOZR2IUj3BHHh4opXcSpjKpcT+6cGNqORzF2JRfyKMXbM69ReIOcL
YsV8DvcVhOKJmaHyNIKC3t1GMEkD0kQImqs9LVqYyuX3ZQseDsAAU+6SrHT1McMH
h/W6wGVPG64fsR7w+e4BYkm/Uweewu+IXpSceh31UiH2lWLZlbefihfUHLal50gg
k6KRN7c4199skteAWuIX337f1Wbj/UCZ3dZ/vUhQ8r32CHq/NmvJCHwdGfWnSjFK
jVzMVHQGqBfg7VdXkDfpA1hkNfd8gFv5nyXYntIp+S0cRjLw3jt6WOlTk8TmMyd0
x7I5s1nmoFOwEFMLJT24L1QHexCcOS7b6DnNFyUAO4+T256jzBY8a8iozkXC57QH
ppKYUZWNpnRY2BxGlvBK
=dn7S
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
