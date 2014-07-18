Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965011AbaGRKDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:03:51 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:42963 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934842AbaGRKDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:03:48 -0400
Date: Fri, 18 Jul 2014 12:03:42 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: caesar <caesar.wang@rock-chips.com>
Cc: Beniamino Galvani <b.galvani@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cf@rock-chips.com,
        addy.ke@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        hj@rock-chips.com
Subject: Re: [PATCH 2/2] pwm: add this series patch to support for rk-pwm and
 vop-pwm.
Message-ID: <20140718100341.GA30497@ulmo>
References: <1405577294-19336-1-git-send-email-caesar.wang@rock-chips.com>
 <1405577294-19336-3-git-send-email-caesar.wang@rock-chips.com>
 <20140717192459.GA4617@gmail.com>
 <53C8AB34.3050102@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <53C8AB34.3050102@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 01:05:56PM +0800, caesar wrote:
> =E4=BA=8E 2014=E5=B9=B407=E6=9C=8818=E6=97=A5 03:24, Beniamino Galvani =
=E5=86=99=E9=81=93:
> >On Thu, Jul 17, 2014 at 02:08:14PM +0800, caesar wrote:
[...]
> >>@@ -119,9 +185,12 @@ static int rockchip_pwm_probe(struct platform_devi=
ce *pdev)
> >>  		return -ENOMEM;
> >>  	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>-	pc->base =3D devm_ioremap_resource(&pdev->dev, r);
> >>-	if (IS_ERR(pc->base))
> >>-		return PTR_ERR(pc->base);
> >>+	pc->base =3D of_iomap(np, 0);
> >>+	if (!pc->base) {
> >>+		dev_err(&pdev->dev, "failed to map controller\n");
> >>+		ret =3D -ENOMEM;
> >>+		goto fail_map;
> >>+	}
> >I think that this change is not needed. devm_ioremap_resource()
> >guarantees an automatic unmapping when the device is destroyed.
> >
> >Moreover, when of_iomap() fails you don't need to call iounmap().
> >
> >Beniamino
> VOP-PWM base has be requested for lcdc.

Why?

> When I use devm_ioremap_resource(), the vop-pwm will request region fail.
>=20
> Example:.931020] rockchip-pwm ff9401a0.pwm: can't request region for
> resource [mem 0xff9401a0-0xff9401af] /pwm@ff9401a0.
> So ,I have to charge it.
>=20
> I will be simplyfied by having:
> - pc->base =3D devm_ioremap_resource(&pdev->dev, r);
> + if (!strcmp(of_id->compatible, "rockchip,vop-pwm"))
> + pc->base =3D devm_ioremap(&pdev->dev, r->start, resource_size(r));
> + else
> + pc->base =3D devm_ioremap_resource(&pdev->dev, r);
>=20
> Maybe, Could you give me better suggestions for it?

The right thing to do is not have two drivers access the same device.
Why does lcdc request the PWM register region?

Thierry

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTyPD9AAoJEN0jrNd/PrOhvSIQAKDzpV/VZlECy5eDVCbH0Lyr
xrQOsIpVSibRNX70vj7GA05XwNXlyaBd6ysHawBA8Q1lVhiCzo5BTqKXK3vLlD/F
sc2s0+0E1pxyjc8OsenfUzppTvpXYlkdLpZMqYqadg2ZEWfPAR+wGdPdHv1odyWi
H3HQQmEoPHEz7de0svfFwxKEUlWCnIKBe7jxrjPgQfzAttohWBgD/038Gu6h5C3K
pW3uDPNEwSbRSrSXQ7LOP/NXlLj8dvRlvhaIZszQFR5U8tSHJ7QW6TLCxr3NFrkF
HB03xkhztj7qptVasTng8wdjcF1XqP0egtWiGvVHThsFWvI35kqAotC8XJcuAH3l
/khEKBvHpxxTSb9cDI+QDdBIe/HvncMC8KSdkKldbfBTKOqNEdJLtvYpiWaMmKqp
MmNXUSTxvpPOPOiambvr5+P0MiWlATalmCaBQ5DN0CuDJL43HcghCGdKugc5Xd3t
rJTW10KOdpsbIpTnLlbokjdhAzu+WUh/eXRXTOGwfyqI0kLhZE5CVQqd6YwPQFU9
qLo9qIaRFlcJgo93DlCzxyNN8oFuEplhEXXpH6waHhWVBr+pFBasB9QeSbb3sKGa
QZH6eNCCf702MTczzhqurk1whfzkMowP6U9/q3+/bMc6pldwKE1MJ5NjBNcYrOZ+
ATpOyk+6eFgf98lYulcx
=qZs/
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
