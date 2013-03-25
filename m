Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab3CYJPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:15:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53070 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072Ab3CYJPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:15:41 -0400
Date: Mon, 25 Mar 2013 10:15:34 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Murray <andrew.murray@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] PCI: Introduce MSI chip infrastructure
Message-ID: <20130325091534.GA21054@avionic-0098.mockup.avionic-design.de>
References: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de>
 <20130322093027.GA521@arm.com>
 <20130324120649.6fb8c05d@skate>
 <20130325075810.GA28935@avionic-0098.mockup.avionic-design.de>
 <20130325093847.7474dc0e@skate>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20130325093847.7474dc0e@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:NsT70C4C7lBgpOcDCDg+yN7lVTqVYeBSw57ZZO3BdJd
 20n3ajfw1n0Y6nCIXxzBN/AWFdFTxykkEpE5xxUmK7HwRpOUDw
 k5nZgNfUv5PBHf7QlBSbziyHd8qUcLaf6lSs3arFKfc5akeTZK
 yIzximkuC8RO+H7Sjda/YapPC7cZ4BOONOI5Ag4UvgUVJaW44/
 kjURm47XWUMK0Fa37kokWrGgaOVU46pn7KDjuFsnVjKT5HYdH9
 ZlM2incRq9s6ZzehmfAtErglq13DnpNyx7QXdlA3kvHFboOMHr
 wkhnVd93VkTtjZh2vNPO37fb69U6ShKU2NUXCe2g2dx6pxPobr
 SOpA+v2XXfnRAI3aMmFO+RgVLemnfyI1kkYitRrVaKcK4lPO2C
 ymU/zS1tsf8qkBrgnzGaBaWuHmNaKFHX1o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2013 at 09:38:47AM +0100, Thomas Petazzoni wrote:
> Dear Thierry Reding,
>=20
> Thanks for your feedback!
>=20
> On Mon, 25 Mar 2013 08:58:10 +0100, Thierry Reding wrote:
>=20
> > That sounds very much like one of the use-cases that were discussed. The
> > easiest solution would probably be to add an API to look up an MSI chip
> > from a DT phandle, so that the PCIe controller's device node could have
> > it as a property, somewhat like this:
> >=20
> > 	msi: interrupt-controller {
> > 	};
> >=20
> > 	pcie-controller {
> > 		...
> > 		marvell,msi =3D <&msi>;
> > 		...
> > 	};
>=20
> I'm not sure how to handle this msi interrupt controller with the main
> interrupt controller. For now, I have:
>=20
>         mpic: interrupt-controller@d0020000 {
>               reg =3D <0xd0020a00 0x2d0>,
>                     <0xd0021070 0x58>;
>         };
>=20
> 	[...]
>=20
> 	soc {
>                 interrupt-parent =3D <&mpic>;
> 		[...]
> 	};
>=20
> And the MSI interrupt controller shares the same registers as the MPIC.
> So should it be something like:
>=20
> 	interrupt-controller {
> 		reg =3D <0xd0020a00 0x2d0>,
>                     <0xd0021070 0x58>;
>=20
> 		mpic {
> 			/* Not sure what to have here */
> 		};
>=20
> 		msi {
>=20
> 			/* Here either */
> 		};
> 	};
>=20
> 	soc {
>                 interrupt-parent =3D <&mpic>;
>=20
> 		pcie-controller {
> 			marvell,msi =3D <&msi>;
> 		};
> 	};
>=20
> Or some other idea?

I think you can just make this:

	mpic: interrupt-controller@d0020000 {
		...
	};

	...

	soc {
		pcie-controller {
			marvell,msi =3D <&mpic>;
		};
	};

And everything else should just work given the APIs I mentioned. But as
you said it'd be good if somebody else could share their opinion about
this.

Thierry

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRUBW2AAoJEN0jrNd/PrOhlUgP/1lyP8ei3IS0VzjybCcXZ1Wm
UnJQ+u9wT45cuYiP+Cew6uXR2hVuAfY/1jEgW0TafBS/CN9z/40WmkHC4R9fbyL/
UVWyhT+6iiOAC5xWKUXScpDmgjOF2umJcq08CO/P08r2VLRm4wsuYp7SJiV+ERZr
hCLqcQ+s0t0nyxUPSTjFdOiuDeK5KMl4zBVNHO/Q5nU4DtjvkVzkb0hmKmqAQ+gj
xUIFS+v1n9JePfr6zQpBu6305o8a2WELI1CZSDKfb3rNbL7xeL6XSxjQB77HrB0v
ACKtOxf9HFHUeErDPn3MnNqa8Xr+yFNnvTiAUVhA6tsVd30GlnffceFtu3ywZm8s
ssSmvfeBgIJBuWTrjbkO5KwBf73djahMq7NpQjmkKJFEQYXoesdN3Qiy+k2caJCb
gHxHn3nk1xmRUlSz7NglWOAceYAUuc0uv0CeiXJLBO1HUYm6Jt8CS7t6k0ro818+
ClwZ8tY4516MkCRTk2WRVW0/BsWFjxkH9fDH06AJI9XqmJvPBsHtwuAQiP67QhEp
7Aqb+7NRsPh8UXNroiNc/Z43JJqRO2gXnGM35g/B3z3JuKKYNa3gZjEnww3vDNYn
4KlRdNmS7jK7gYH43etc4m7fjfBWXfGoqbAvVnbCAw42TpOU7d9MUPZ4VQzOUKLg
r2rNTUn6Ryi/iZV+jrg1
=GSB1
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
