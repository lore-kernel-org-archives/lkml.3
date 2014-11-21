Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbaKUPDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:03:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48303 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaKUPDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:03:15 -0500
Date: Fri, 21 Nov 2014 09:03:31 -0600
From: Felipe Balbi <balbi@ti.com>
To: Arjun Sreedharan <arjun024@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb:phy: propagate __of_usb_find_phy()'s error on failure
Message-ID: <20141121150331.GB7508@saruman>
Reply-To: <balbi@ti.com>
References: <1416498816-3292-1-git-send-email-arjun024@gmail.com>
 <20141120193949.GC23217@saruman>
 <CAJFMrCGbUQar751mOZOJ5Fy=HEDb+L7XjQypJxzyE72T=qoDmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <CAJFMrCGbUQar751mOZOJ5Fy=HEDb+L7XjQypJxzyE72T=qoDmw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 12:19:42PM +0530, Arjun Sreedharan wrote:
> On 21 November 2014 01:09, Felipe Balbi <balbi@ti.com> wrote:
>=20
> > On Thu, Nov 20, 2014 at 09:23:36PM +0530, Arjun Sreedharan wrote:
> > > When __of_usb_find_phy() fails, it returns -ENODEV - its
> > > error code has to be returned by devm_usb_get_phy_by_phandle().
> > > Only when the former function succeeds and try_module_get()
> > > fails should -EPROBE_DEFER be returned.
> > >
> > > Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> > > ---
> > >  drivers/usb/phy/phy.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
> > > index 045cd30..0310112 100644
> > > --- a/drivers/usb/phy/phy.c
> > > +++ b/drivers/usb/phy/phy.c
> > > @@ -191,7 +191,9 @@ struct usb_phy *devm_usb_get_phy_by_phandle(struct
> > device *dev,
> > >
> > >       phy =3D __of_usb_find_phy(node);
> > >       if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> > > -             phy =3D ERR_PTR(-EPROBE_DEFER);
> > > +             if (!IS_ERR(phy))
> > > +                     phy =3D ERR_PTR(-EPROBE_DEFER);
> > > +
> >
> > trailing whitespace here. I'll fix it myself this time, but next time be
> > more careful.
> >
>=20
> sorry about that. my bloody vi. thanks

add these to your .vimrc :-)

" Highlight redundant whitespaces
highlight RedundantWhitespace ctermbg=3Dred guibg=3Dred
match RedundantWhitespace /\s\+$\| \+\ze\t/

--=20
balbi

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUb1RDAAoJEIaOsuA1yqREaWsP/j1fqDrpjxfmiUksq48xQAMa
oacPJrRs0CF7i4gzzlPj/kHAkFKIuUxt6U3kG4MykaU/FbKxBqnV+p9ukC399M1N
38CGoU1ytYEBfv7wfR0JL9t/T+ey3/PHQ8Ucpl6+VBnWxQieiW3gJxbsq8wYpZ2q
aG38hUMr7qEmRb327sF5MVFRNj11s0WamRFBwnBw7tvjrRxQfUeB+ffQzK4AGxTe
Fg7YT59v3chjBUOprOP2wxo+EkFbv1zd6rmfJs1e8n5lhx1620iqaLAq8z/PMoh0
x3/oDlAc6Mgrl3eurxrc0zwTk2bviAWht6+J2Uvv7fRe4M1MRy0hPjucrU++3el7
ktvaZtwxpTNIGMwm8QQx2997tI3bX0BTomreIH5JkGjKX5lVHdWzuIY32YlKp5ml
iqsWPf50LDnlWs1XLYHUyWX8PkIUftUKJcbKiQhubkvSnmcBD5Wx+G2Joc90gX4s
ZSHGP6uvRWnf3EsXMXmBFNbkSriCa48zvR6jMiQX/H3K0X9UHgeGOh95pTJk5ZE7
EBoji5V+6JzjH9BOhhHVKESsHklKfAkap/v0uG0fGuXWYll3zeB5tOmd11nxpnzd
WGyQYLcUTS2VIJLJL/WeIma0Isr+Uc5MiMxvRoQVql6Rt1VtfbcHgGrcJMmruLIe
K95EEfhUTTvpBxGugr4C
=uPVB
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
