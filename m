Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab3IQPv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:51:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44087 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3IQPvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:51:53 -0400
Date: Tue, 17 Sep 2013 10:48:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: Tony Lindgren <tony@atomide.com>, Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <freemangordon@abv.bg>, <aaro.koskinen@iki.fi>, <pavel@ucw.cz>
Subject: Re: [PATCH 1/4] usb: musb: Call atomic_notifier_call_chain when
 status is changed
Message-ID: <20130917154859.GK15645@radagast>
Reply-To: <balbi@ti.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1378630239-10006-2-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j3zO+32zXj6UcJCE"
Content-Disposition: inline
In-Reply-To: <1378630239-10006-2-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--j3zO+32zXj6UcJCE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 08, 2013 at 10:50:36AM +0200, Pali Roh=E1r wrote:
> More power supply drivers depends on vbus events and without it they not
> working. Power supply drivers using usb_register_notifier, so to deliver
> events it is needed to call atomic_notifier_call_chain.
>=20
> So without atomic notifier power supply driver isp1704 not retrieving
> vbus status and reporting bogus values to userspace and also to board
> platform data functions. Without proper data charger drivers trying to
> charge battery also when charger is disconnected or do not start charging
> when wallcharger connects.
>=20
> Atomic notifier in musb driver was used before v3.5 and was replaced with
> omap mailbox. This patch adding atomic_notifier_call_chain call from
> function omap_musb_set_mailbox.
>=20
> Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> ---
>  drivers/usb/musb/omap2430.c       |    3 +++
>  drivers/usb/phy/phy-twl4030-usb.c |    2 ++
>  2 files changed, 5 insertions(+)
>=20
> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index f44e8b5..5c40252 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -305,6 +305,9 @@ static void omap_musb_set_mailbox(struct omap2430_glu=
e *glue)
>  	default:
>  		dev_dbg(dev, "ID float\n");
>  	}
> +
> +	atomic_notifier_call_chain(&musb->xceiv->notifier,
> +			musb->xceiv->last_event, NULL);

let's add a wrapper for this:

static inline int usb_phy_notify(struct usb phy *x, unsigned val, void *v)
{
	return atomic_notifier_call_chain(&x->notifier, val, v);
}

--=20
balbi

--j3zO+32zXj6UcJCE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOHnrAAoJEIaOsuA1yqRE3VIP/jbnKeeXAnDtgPZnMfhAKijJ
+4+kEFKdF+3vshKJ8uQGnkfGlnk/EO+goAe/Vzydi98O9HyLGzP+Pb3Fee9qkL3j
rd81eUPftksoXItFXpSZSjdQgPMFSGe3SXGyW5Dyv9kIyv2goaKI6XfHbAls/eNn
UD11KyPQcKa2m5DhvsT2H/pFl85+XgNW2kIqEqm7GDeyGWdLVGGx0lTWV8uWV6wR
QbV1lTkWVKPh/Qzhp4pkbR8KnfkrgyVWEpEVXKdVjYJMVDgeWE0dcV7TTaKoiQs2
2XGUur+M8pvhLa8iLqYve46cXY61c3DH5i7srIcwBlq5xyvM5FliXc/Xk7TS4Iv2
p8VIUapepWPiBX5q6hy9Fj4vKFz0Io+HnaYRggWdn9+V+y2VAWPYMHfHB3niX9E8
G6ad8KMDSdIUhYp4tWCB4vvb9hRGkUtmdqMK0QPBJHVuTxe2HqvHFIOhDqFRtmx6
fnltP9CYI69IPkFW2VwMkfHZ++xCpkD0UOUvi5rg+fv1SLTSPqhzxzvEgnR/1I0z
uCPxFBZsrA6DfysPc/N0a8BTsB8MmOhNiVzxgoNpSM7Vo9jqPDZ2cw1ruKa6gcBm
cPMTPKpdJvT+etW6ituHihOzh99TdUq1LMkDyc/zfSzy9qFXzXBr9uMJ5jIjA6Qt
ch/igUK+kF90fa+fRCVF
=MVFx
-----END PGP SIGNATURE-----

--j3zO+32zXj6UcJCE--
