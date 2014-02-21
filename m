Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbaBUQCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:02:30 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55235 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932637AbaBUQC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:02:26 -0500
Date: Fri, 21 Feb 2014 10:00:58 -0600
From: Felipe Balbi <balbi@ti.com>
To: Michal Simek <monstr@monstr.eu>
CC: <balbi@ti.com>, Mark Rutland <mark.rutland@arm.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140221160058.GK31902@saruman.home>
Reply-To: <balbi@ti.com>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local>
 <20140220182257.GF23217@saruman.home>
 <20140221120454.GD8783@e106331-lin.cambridge.arm.com>
 <5307576F.5050506@monstr.eu>
 <20140221154244.GG31902@saruman.home>
 <530775EB.6030004@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jcwRHPSxFqmwpRFb"
Content-Disposition: inline
In-Reply-To: <530775EB.6030004@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jcwRHPSxFqmwpRFb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2014 at 04:51:07PM +0100, Michal Simek wrote:
> On 02/21/2014 04:42 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Feb 21, 2014 at 02:41:03PM +0100, Michal Simek wrote:
> >>>>> +	/* Map the registers */
> >>>>> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>>>> +	udc->base_address =3D devm_ioremap_nocache(&pdev->dev, res->start,
> >>>>> +						 resource_size(res));
> >>>>
> >>>> use devm_ioremap_resource() instead.
> >>>
> >>> Also, res might be NULL. You should check that before dereferencing i=
t.
> >>
> >> yes it is necessary for both cases with devm_ioremap_nocache
> >> or with devm_ioremap_resource.
> >=20
> > read the source Luke:
> >=20
> > | void __iomem *devm_ioremap_resource(struct device *dev, struct resour=
ce *res)
> > | {
> > | 	resource_size_t size;
> > | 	const char *name;
> > | 	void __iomem *dest_ptr;
> > |=20
> > | 	BUG_ON(!dev);
> > |=20
> > | 	if (!res || resource_type(res) !=3D IORESOURCE_MEM) {
> >             ^^^^
> > 	    already done for you
> >=20
> > | 		dev_err(dev, "invalid resource\n");
> > | 		return ERR_PTR(-EINVAL);
> > | 	}
> > |=20
> > | 	size =3D resource_size(res);
> > | 	name =3D res->name ?: dev_name(dev);
> > |=20
> > | 	if (!devm_request_mem_region(dev, res->start, size, name)) {
> > | 		dev_err(dev, "can't request region for resource %pR\n", res);
> > | 		return ERR_PTR(-EBUSY);
> > | 	}
> > |=20
> > | 	if (res->flags & IORESOURCE_CACHEABLE)
> > | 		dest_ptr =3D devm_ioremap(dev, res->start, size);
> > | 	else
> > | 		dest_ptr =3D devm_ioremap_nocache(dev, res->start, size);
>=20
> I have read it just not sure if IORESOURCE_CACHEABLE is setup by default
> or not.
> If yes, then you have to setup res->flags in your driver and have to
> check it.

you don't need IORESOURCe_CACHEABLE. It's fine the way it is, just use
the helper function ;-).

--=20
balbi

--jcwRHPSxFqmwpRFb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTB3g6AAoJEIaOsuA1yqREEqkP/AyHedwQ1Z7jp4vkMWhLWPbT
X1NzQxnFr1X+G3TQuKkNLhT47y8/IsdKLivYPm/V41RIkSZWz1bAWy93emIVyl20
oEdWGRJW54szfkndMvP9ZNuiBiRFnKI/XlACBIdXlU/uw97ooGiKeV3P9hnQc5Oi
i6P7tvMsL3PWkyDDOh7EBUALPLZhwp4XpQJX3TGblQUZkCP0vi2SZOo/nfHC71tO
nwrzp/cKq/RuKAZJrKlhC5YN2+fltcL3I8hXa2+XgaMS9qMDGfHOZ2i1ea9AbQSn
n/NdjfojSIJ5lD/pbkNeXxk7kA99T2mFR/h/whkwdiybZ1HWKcr9mXlbYgDR2skM
L9Gg6Zerj6b4dJoxIknvMn7ZR641b0/73CsSqF3Q2tb4sShiG4j2+FxjqfG8WT0m
hiNLrfxEbWIO8FNArgOtpmtYCBDLfFWNzca6NJK68AQ+BoU0WV4ieWrNlrAO3qTw
wsXJU1AvSgBpzabGP/xilqdekYRIWayLI63/rTN7iryLes34pIQD+N6Sy8MxqXl8
yqAbyK6AFEe6HbTwoaKAkQLPJf0aZdCIf3DJd0ShfQVtB5kCT09CyIPBOpGtNowW
WFLTISR9u5/Q5aNlt2HZ00PWQ/dJThUfpGuEHwnP815xdv5eXsVPfuEt4WyyueNf
5m93ixqjmmiSqGXOPmI9
=Z9dj
-----END PGP SIGNATURE-----

--jcwRHPSxFqmwpRFb--
