Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaDYUxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:53:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43453 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbaDYUxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:53:38 -0400
Date: Fri, 25 Apr 2014 15:53:31 -0500
From: Felipe Balbi <balbi@ti.com>
To: Fabio Estevam <festevam@gmail.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v7 05/20] usb: phy: msm: Migrate to Managed Device
 Resource allocation
Message-ID: <20140425205331.GM29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
 <1398354495-20782-6-git-send-email-iivanov@mm-sol.com>
 <CAOMZO5COKimLjC0oYqgwSaEvSBUpoy9aP_P-ScU+ozh0KpsCoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eB5okr78BIEWepnS"
Content-Disposition: inline
In-Reply-To: <CAOMZO5COKimLjC0oYqgwSaEvSBUpoy9aP_P-ScU+ozh0KpsCoA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eB5okr78BIEWepnS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 01:49:38PM -0300, Fabio Estevam wrote:
> On Thu, Apr 24, 2014 at 12:48 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wro=
te:
>=20
> > +       motg->vddcx =3D devm_regulator_get(motg->phy.dev, "HSUSB_VDDCX"=
);
> > +       if (IS_ERR(motg->vddcx)) {
> > +               dev_err(motg->phy.dev, "unable to get hsusb vddcx\n");
> > +               return PTR_ERR(motg->vddcx);
> > +       }
> > +
> > +       motg->v3p3 =3D devm_regulator_get(motg->phy.dev, "HSUSB_3p3");
> > +       if (IS_ERR(motg->v3p3)) {
> > +               dev_err(motg->phy.dev, "unable to get hsusb 3p3\n");
> > +               return PTR_ERR(motg->v3p3);
> > +       }
> > +
> > +       motg->v1p8 =3D devm_regulator_get(motg->phy.dev, "HSUSB_1p8");
> > +       if (IS_ERR(motg->v1p8)) {
> > +               dev_err(motg->phy.dev, "unable to get hsusb 1p8\n");
> > +               return PTR_ERR(motg->v1p8);
> > +       }
>=20
> It seems that calling devm_regulator_bulk_get() here would simplify
> the code here.

any comments here ?? Should I expect a new version ?

--=20
balbi

--eB5okr78BIEWepnS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWstKAAoJEIaOsuA1yqREZUIQAImC033s54Bz3kNIomkCaAz3
f971XPqJHK+VlgzBxOi4YFcDZKsAk7kRTnqLb8LY4NmpbswBlQ3bQWbQNF4IkZIl
uicaehpxgpHcblmG7rKHQI4A4j0Yg0oSfmh6zxp2qwMjPwxht0A+PuGQp8zvLifL
fwWdgvzz+92xP+4hIsYz2Oip6NPCeQoTMP7rvX7t2efPsdLYQ9w+IlBSXgoHBNbR
rVtcIQ/VdbdEaYmJx1S2kUYCDuBh1XjBgnxZC0UwlFvG2bgLYpnH9GK38oFWZvhN
SPqEFKYEBy0KLUjgH4kPzjr5yu8BPOoDYKajwBC71QhcFj4UEg26qlHbsquX11o+
S2ytlRdV8qayg2OHpGJKBlB9o3FCUIa/7UW7fbNQikvSJO5qyk3yE0+7KoJJ72/4
ptU9hfyYRMwc88Zpk3VK1+rHrRG0tyvDl4RmqdME0ZMx6/9YUQQdsixTP30Vkihj
JDrXKFHG7yvMAWb0g4A+eXBDTNfICaPuTTpFDBxX9f2ZJm/w3NQGwuFDzs6e2XB4
pLIEkFV3N3fGvRo+SeKTBRQQKqT/VF8uxsv4UgMAd923TPage4J2pkxR+9HMdBvv
d8X1hsgiy2Ne0BSNYvQtpKzRe4hO60sqXhZvIjhNefa76fEj1OBtjNFLMrzJ5CKo
m5HvbfHBkQRnf9c0kcom
=2dUZ
-----END PGP SIGNATURE-----

--eB5okr78BIEWepnS--
