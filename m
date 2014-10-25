Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaJYTrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:47:32 -0400
Received: from lug-owl.de ([195.71.106.12]:33589 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbaJYTra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:47:30 -0400
X-Greylist: delayed 4199 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Oct 2014 15:47:29 EDT
Date: Sat, 25 Oct 2014 14:39:40 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: vsxxxaa - fix code dropping bytes from queue
Message-ID: <20141025123939.GW28215@lug-owl.de>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20141024223846.GA1914@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V2AZ19bMCakBLong"
Content-Disposition: inline
In-Reply-To: <20141024223846.GA1914@dtor-ws>
X-Operating-System: Linux mail 3.2.0-4-686-pae 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear
 warfare test the bombastical terror of flooding the spy listeners explosion
 sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare
 test the bombastical terror of flooding the spy listeners explosion sex
 drugs and rock'n'roll
X-message-flag: Please send plain text messages only. Do not send HTML
 emails. Thank you. 
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V2AZ19bMCakBLong
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-10-24 15:38:46 -0700, Dmitry Torokhov <dmitry.torokhov@gmail.c=
om> wrote:
> I believe the intent of the code was to drop oldest bytes from the queue,
> not the latest if we drop one byte and both latest and some oldest of we
> are dropping more than one.
>=20
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/mouse/vsxxxaa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/input/mouse/vsxxxaa.c b/drivers/input/mouse/vsxxxaa.c
> index 3829823..abd4944 100644
> --- a/drivers/input/mouse/vsxxxaa.c
> +++ b/drivers/input/mouse/vsxxxaa.c
> @@ -128,7 +128,7 @@ static void vsxxxaa_drop_bytes(struct vsxxxaa *mouse,=
 int num)
>  	if (num >=3D mouse->count) {
>  		mouse->count =3D 0;
>  	} else {
> -		memmove(mouse->buf, mouse->buf + num - 1, BUFLEN - num);
> +		memmove(mouse->buf, mouse->buf + num, BUFLEN - num);
>  		mouse->count -=3D num;
>  	}
>  }

Good catch!  I fucked up the error recovery path.

Acked-by: Jan-Benedict Glaw <jbglaw@lug-owl.de>

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:                     Eine Freie Meinung in einem Freien Kopf
the second  :                   f=C3=BCr einen Freien Staat voll Freier B=
=C3=BCrger.

--V2AZ19bMCakBLong
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRLmgsACgkQHb1edYOZ4bsKmgCfaJNOVJd9WnpoPOBiuUPMy3Sa
yOcAnRMTgtDyrKFicBixYs0oyDOKPpC8
=sd+8
-----END PGP SIGNATURE-----

--V2AZ19bMCakBLong--
