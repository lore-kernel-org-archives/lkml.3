Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaBUPoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:44:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43495 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaBUPoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:44:11 -0500
Date: Fri, 21 Feb 2014 09:42:44 -0600
From: Felipe Balbi <balbi@ti.com>
To: Michal Simek <monstr@monstr.eu>
CC: Mark Rutland <mark.rutland@arm.com>, Felipe Balbi <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140221154244.GG31902@saruman.home>
Reply-To: <balbi@ti.com>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local>
 <20140220182257.GF23217@saruman.home>
 <20140221120454.GD8783@e106331-lin.cambridge.arm.com>
 <5307576F.5050506@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vbzKE9fGfpHIBC6T"
Content-Disposition: inline
In-Reply-To: <5307576F.5050506@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vbzKE9fGfpHIBC6T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 21, 2014 at 02:41:03PM +0100, Michal Simek wrote:
> >>> +	/* Map the registers */
> >>> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>> +	udc->base_address =3D devm_ioremap_nocache(&pdev->dev, res->start,
> >>> +						 resource_size(res));
> >>
> >> use devm_ioremap_resource() instead.
> >=20
> > Also, res might be NULL. You should check that before dereferencing it.
>=20
> yes it is necessary for both cases with devm_ioremap_nocache
> or with devm_ioremap_resource.

read the source Luke:

| void __iomem *devm_ioremap_resource(struct device *dev, struct resource *=
res)
| {
| 	resource_size_t size;
| 	const char *name;
| 	void __iomem *dest_ptr;
|=20
| 	BUG_ON(!dev);
|=20
| 	if (!res || resource_type(res) !=3D IORESOURCE_MEM) {
            ^^^^
	    already done for you

| 		dev_err(dev, "invalid resource\n");
| 		return ERR_PTR(-EINVAL);
| 	}
|=20
| 	size =3D resource_size(res);
| 	name =3D res->name ?: dev_name(dev);
|=20
| 	if (!devm_request_mem_region(dev, res->start, size, name)) {
| 		dev_err(dev, "can't request region for resource %pR\n", res);
| 		return ERR_PTR(-EBUSY);
| 	}
|=20
| 	if (res->flags & IORESOURCE_CACHEABLE)
| 		dest_ptr =3D devm_ioremap(dev, res->start, size);
| 	else
| 		dest_ptr =3D devm_ioremap_nocache(dev, res->start, size);
|=20
| 	if (!dest_ptr) {
| 		dev_err(dev, "ioremap failed for resource %pR\n", res);
| 		devm_release_mem_region(dev, res->start, size);
| 		dest_ptr =3D ERR_PTR(-ENOMEM);
| 	}
|=20
| 	return dest_ptr;
| }

--=20
balbi

--vbzKE9fGfpHIBC6T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTB3P0AAoJEIaOsuA1yqREXukQAKV+oUFFcb+GuSEeo0cJjyzr
mjxdjft8wE0yqqp4/yqD73m1Wg9hOvD4/JNOYglqcJhRj3JOLmNUPRvAk36EwTI/
Mqq82VTjb46abKovCKoji/Y8KlCN01bM6BjI1LxSxwAwD3w8g7CLnrRkUANeMcXP
UAGAwnrSiADGGF+LKVurNXxPEPx4l2DaYDyOes3515RTsJtXvK9dTXE2umd1EhLZ
nLmiMYo0dckUuoC/97f6pZxqupN9+ww6Ab0xTZISprMGlY4PnTW62iyDLZu9OHDc
FRWwVBbHXuzvLuIa9BGyFu0tcbf9J7ylzQmX0BxzinHbrzfo3+lw8fY9OugT8Xyb
Ck3CEdn0CqFcg/34uLQ1wOwp/RDBwfA2+Jhj8OqQrnxtL71JcXIc0XESufStAGFJ
MR/NdvvL/pqvyfWu6xROnVFwab8qnBeJqDDZQNVoEJqgE3WuSaqwzj5n1O2PWECN
qhTewFiVoJJajCxfhKj8MOTDEMtvvjnUpwc35mxe0RCwDZ3jYimFgR6uTa8EN++V
0INGRXd/+ZD8CqOyDGuhmuE6NDbYIZPfeK0NaBtAmObdaM4xvPGkoEho+QR+C3DS
NICk5NdLIR4TwgZEEq2/rbCTqlXOasPpAYV1XBOArExL0IOXAW5/ShdTM7TtZp5m
AvIXjvKoBzcc+B7e6MJN
=ThyS
-----END PGP SIGNATURE-----

--vbzKE9fGfpHIBC6T--
