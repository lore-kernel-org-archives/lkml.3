Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbaFKQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:16:58 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59136 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbaFKQQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:16:57 -0400
Date: Wed, 11 Jun 2014 18:16:52 +0200
From: Levente Kurusa <levex@linux.com>
To: David Rientjes <rientjes@google.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Masanari Iida <standby24x7@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8821ae: rtl8821ae: hw.c:  Cleaning up if
 statement that always evaluates to false
Message-ID: <20140611161652.GA23026@linux.com>
References: <1402191812-26264-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <alpine.DEB.2.02.1406081336080.19183@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406081336080.19183@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 08, 2014 at 01:37:43PM -0700, David Rientjes wrote:
> >  drivers/staging/rtl8821ae/rtl8821ae/hw.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hw.c b/drivers/staging=
/rtl8821ae/rtl8821ae/hw.c
> > index 1b8583b..52322e3 100644
> > --- a/drivers/staging/rtl8821ae/rtl8821ae/hw.c
> > +++ b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
> > @@ -1623,7 +1623,7 @@ static int _rtl8821ae_set_media_status(struct iee=
e80211_hw *hw,
> > =20
> >  	rtl_write_byte(rtlpriv, (MSR), bt_msr);
> >  	rtlpriv->cfg->ops->led_control(hw, ledaction);
> > -	if ((bt_msr & ~0xfc) =3D=3D MSR_AP)
> > +	if ((bt_msr & MSR_AP) =3D=3D MSR_AP)

I changed this line from '0xfc' to '~0xfc', and looking at the defines
it must have been the way your patch does, so:

Acked-by: Levente Kurusa <levex@linux.com>

if it wasn't applied yet, and you fix the problems David pointed out
with the commit message.

Thanks,
    Levente Kurusa

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJTmIDzAAoJELBqK2lO9dZBvsgIAJ4MNOv1LbUdY96pkIqncIzV
E0WkI+TSrY47GCqjOwsL9i3xI/xmmnyKBBW9bjYH1iD5/qDc7abR0HwN0AJVDI+d
l6ExTxUXo+kTMNtINdFpKGkYcLT3sU8SzX0TCAz3XHmoCeUxZmThvPKkZ1XaowKV
PUlLeqLz9lMB9e9wHeEW7SJyc8yIAp7+d1rN44gQfq3Ed5UWTdnj+oeSLy44Qszl
sUoOylfIYdzAWgKk4hweQ/ykiltXsVwndKXtLPV/0HT+tQ9NZSqWAaTW4BQVogX5
3BnaMYWUPaFT9XbE6yOBX7I91hYftJV5olgwtdm7eXrBnmAmUYnfusVSDk54gAY=
=Rfoo
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
