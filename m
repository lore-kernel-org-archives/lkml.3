Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbaCTQIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:08:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44542 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757174AbaCTQIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:08:16 -0400
Date: Thu, 20 Mar 2014 11:06:25 -0500
From: Felipe Balbi <balbi@ti.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform
 device id
Message-ID: <20140320160625.GC32692@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394719531-27062-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152628.GI4599@saruman.home>
 <71f42b215c58414d8bfa7efb968dadbf@BN1PR03MB251.namprd03.prod.outlook.com>
 <20140315014015.GD31520@saruman.home>
 <bb1e5245113c424abd45e6dad2d0cba4@BN1PR03MB251.namprd03.prod.outlook.com>
 <20140319165138.GC27142@kroah.com>
 <8e9307819fbe4cb589a2b58ac8296230@BN1PR03MB251.namprd03.prod.outlook.com>
 <20140320160252.GA18120@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Content-Disposition: inline
In-Reply-To: <20140320160252.GA18120@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 20, 2014 at 09:02:52AM -0700, gregkh@linuxfoundation.org wrote:
> On Thu, Mar 20, 2014 at 03:01:56PM +0000, suresh.gupta@freescale.com wrot=
e:
> > > > > > > @@ -2654,6 +2654,8 @@ static const struct platform_device_id
> > > > > fsl_udc_devtype[] =3D {
> > > > > > >  	}, {
> > > > > > >  		.name =3D "imx-udc-mx51",
> > > > > > >  	}, {
> > > > > > > +		.name =3D "fsl-usb2-udc",
> > > > > >
> > > > > > why aren't you just using chipidea ?
> > > > > > [SuresH] This is our legacy driver for all previous and existing
> > > > > > ppc socs. Many of our customers are already using this, and we
> > > > > > need to support them on this driver. We do have plans to shift =
to
> > > > > > chipidea, but after some time.
> > > > >
> > > > > cool, you already have plans, so we will see a new glue layer for
> > > > > v3.16 right ? Which means I don't need to take this patch either.
> > > > >
> > > > we do have plans, but in remote future. Right now, we need to suppo=
rt
> > > > customers on the present legacy driver. We'll phase out this driver
> > > > slowly when we integrate chipidea. At this time I would request you=
 to
> > > > please accept this patch
> > >=20
> > > Even if Felipe takes the patch, I'll reject it as you should be doing=
 the
> > > correct thing here, and if it's accepted, it will never be changed...
> >=20
> > Hi Greg, I agree that moving to the chipidea driver is the right thing =
to do.
> > However, does this mean that companies have to phase out their current =
legacy=20
> > drivers as soon as a new controller specific driver is introduced in ke=
rnel ??
>=20
> If their drivers aren't merged upstream, then yes they do, we can't have
> duplicate drivers controlling the same hardware blobs.
>=20
> > Can't they decide their own schedule based on their own requirements. O=
ur only=20
> > concern is to keep supporting our customers till we move to the new dri=
ver.=20
>=20
> Your support issues / requirements is not any of our business, we just
> can't accept duplicate code, which I'm sure you can understand.
>=20
> > I would really appreciate if you could accept this as this would give u=
s=20
> > some time to move to chipidea driver.
>=20
> What is preventing you from doing this within a week or so?  Is it
> really that hard of a transistion?  If so, is this a problem with the
> chipidea driver or something else?

Greg, many other freescale SoCs are *already* using chipidea driver. I
suppose 1 week effort is overestimation, it shouldn't take much more
than a couple days.

If there are any bugs in chipidea, let's find them and fix them up. We
really cannot continue with code duplication in the tree, it's just
moronic to do so, it's an unnecessary maintenance burden, extra review
time, same fixes having to written for separate drivers, and so on.

--=20
balbi

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTKxIBAAoJEIaOsuA1yqREA1IP/RjPJ9AllepYW4+teb9cgOuG
Q9wWgoHVnitUBQyg6/ev1iaK09YjKT+D+CTiRoJ4J5Z8ZPbHqr87dsFbIqVQ/fX7
AWcN1IGtvVQ2jb2cdScNUA1JCAxkmk3VQBZs8fjqeVa3ygfjTQbAeHVacVCuyk1n
6JC4nL9/ic+tCRGbHrSA7k6BoQxW0AFPfAtz5C5hLr+2MwJZGd2OgbrLlPOO72Nv
cJqawd/1Uh/gMaA08Sgvihyvi8l5qV9SdXNiEch98eupApBGAsitH8ohO5EKhD/N
n0hjYh7Z6R0nr/iaf1YpdNcuG3EvLbXtevibgKCFTPeeLRcgVOwAloJoV9hd0NKH
5s+l5vWXmiDdxZ/eBbd5bp2qSVtZV4REOAmBHvKPxY3nvs7aUwPMpZICMrbdqWlh
euyZVHVFoIEYsiKusIlpP03p697GiUKdY+wEnfDGdMAWOdgK1+3yIZWVWCegDl8W
CBUuxRGSyRROGCn+toMXWoPZq7ahaRRthJdyaEzmR3Bzxbv82UjyBgmQyhjJ15tE
fGl5JAV9K7VlpS+SzyGWM8wh5CtwXm0bWP03PbsyL7enduPpR+Hc1QZ+Q+cZ1gsb
vaIoUxGh9joU1BF/r70U+Uqj5uN/MNWGkR1/d+3Ug/Olk7eOfLLDBH8bxe3QSvdU
z4gzQSxv80ZCTUDco7mQ
=/hzz
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
