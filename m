Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbaEOHoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:44:13 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:60259 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaEOHoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:44:10 -0400
Date: Thu, 15 May 2014 09:42:04 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rahul Sharma <rahul.sharma@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        sunil joshi <joshi@samsung.com>, Rahul Sharma <r.sh.open@gmail.com>
Subject: Re: [PATCH v3 1/3] phy: Add exynos-simple-phy driver
Message-ID: <20140515074203.GD5952@ulmo>
References: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
 <1400095043-685-2-git-send-email-rahul.sharma@samsung.com>
 <20140514221423.GC6215@mithrandir>
 <CAPdUM4NaLpN99JCJH3qMakSO3OG6ASjEuvvr_CnKv=gOiqfzMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tNQTSEo8WG/FKZ8E"
Content-Disposition: inline
In-Reply-To: <CAPdUM4NaLpN99JCJH3qMakSO3OG6ASjEuvvr_CnKv=gOiqfzMQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tNQTSEo8WG/FKZ8E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 10:49:37AM +0530, Rahul Sharma wrote:
> Hi Thierry,
>=20
> On 15 May 2014 03:44, Thierry Reding <thierry.reding@gmail.com> wrote:
> > On Thu, May 15, 2014 at 12:47:21AM +0530, Rahul Sharma wrote:
[...]
> >> +#define HDMI_PHY     0
> >> +#define DAC_PHY      1
> >> +#define ADC_PHY      2
> >> +#define PCIE_PHY     3
> >> +#define SATA_PHY     4
> >
> > Perhaps these should be namespaced somehow to avoid potential conflicts
> > with other PHY providers?
>=20
> How about XXX_SIMPLE_PHY?

The indices are specific to the Exynos PHY device, so why not
PHY_EXYNOS_SIMPLE_XXX (or any variation thereof)?

> >> +#define PHY_NR       5
> >
> > I'm not sure that this belongs here either. It's not a value that will
> > ever appear in a DT source file.
>=20
> I want it to grow along with new additions in the phy list else
> catastrophic. This will look unrelated in driver.

But this is in no way growing automatically as it is. Whoever adds a new
type of PHY will need to manually increment this define. Furthermore the
driver will need to be updated to cope with this anyway.

I think this is even a reason to have this only in the driver. Otherwise
you could have a situation where somebody upgrades the binding (and this
file along with it) but not update the driver with the necessary support.
But the driver will still pick up the PHY_NR change and will accept the
new PHY type as valid, even though it has no code to handle it. If you
have this in the driver, however, then as long as the driver has not yet
been updated it will reject requests for the new PHY type. And that's
exactly what it should be doing since it doesn't know how to handle it.

Thierry

--tNQTSEo8WG/FKZ8E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTdG/LAAoJEN0jrNd/PrOhxcsP/RdR01ceQtmbqBx/1om+YSe9
0ekVajz9CMbe4n4nc6/TlxLoNJlDQXNoLYrLyj9sNz9K0uZNkjaW0RStKETYtgl2
e0/m0MVRo53rT4iosefV3qsPCBeU1eAwHdCbGrnmb00z+fE+K1rPd+oMqs3ZS05a
uFgzt/3s3E9Kg6HdDrGMg7YGj00fSQhw+1otnmLN+t+pP0w6A9Z2mAMhLihXY1FR
sB1P9NmYZdwKDdRS5423355hH5eNAE8xXv/EzA/mb+WPLGTtyjlNMxgFzso3bww1
3n9l/ZscwXlq+XjHekZHXra50YlM4J4SBeHbbrArObkTGFWEjzm0pJ8An9hssh1l
lMiGeZ61FUplxTtXnYI/0C8alxJGG/1tS3BlPtBL9Wqog1XV0OIQdUByU8APCNzU
CVW68BVu8gteKJjtzGTAWHWMq4BDU7vDOqTIhThLnxTtxQAW0H4L4TCZXJ0GdqL2
QFlormg5wW2x8ArSJYc8HlRKr2FbD86mr+FMOZiPh7wIg2L5McvQl4r/fVUF7PID
pUemvq9TbH02yvFPuyyV3bcKJjMDcEW5+mJsBqjcbJurM0GuKU1WgTUWSDGRlup5
CUKDbn0iavAosRn8muzQeH+Gy9rA9MFhoY0nG7tmHOV+xMWlr3smSFuxMi6pQBnx
sqWv6AENtahVIWeL32ze
=vRlj
-----END PGP SIGNATURE-----

--tNQTSEo8WG/FKZ8E--
