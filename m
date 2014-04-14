Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaDNViA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:38:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48783 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbaDNVhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:37:50 -0400
Date: Mon, 14 Apr 2014 16:35:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: Mathias Krause <minipli@googlemail.com>
CC: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>,
        PaX Team <pageexec@freemail.hu>, Felipe Balbi <balbi@ti.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: Re: [PATCH 2/2] pda_power: Unregister USB notifier in
 pda_power_remove()
Message-ID: <20140414213504.GB22607@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396186455-3276-1-git-send-email-minipli@googlemail.com>
 <1396186455-3276-3-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <1396186455-3276-3-git-send-email-minipli@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 30, 2014 at 03:34:15PM +0200, Mathias Krause wrote:
> If we've registered a notifier in pda_power_probe() we must deregister
> it in pda_power_remove() to not let it work on stale data like, e.g.,
> the charger timer.
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Anton Vorontsov <anton@enomsg.org>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ---
>  drivers/power/pda_power.c |    5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
> index 87a963d0a8..aba23d6848 100644
> --- a/drivers/power/pda_power.c
> +++ b/drivers/power/pda_power.c
> @@ -430,6 +430,11 @@ static int pda_power_remove(struct platform_device *=
pdev)
>  	if (pdata->is_ac_online && ac_irq)
>  		free_irq(ac_irq->start, &pda_psy_ac);
> =20
> +#if IS_ENABLED(CONFIG_USB_PHY)
> +	if (!IS_ERR_OR_NULL(transceiver) && pdata->use_otg_notifier)

IS_ERR() should be enough here.

> +		usb_unregister_notifier(transceiver, &otg_nb);
> +#endif
> +
>  	if (polling)
>  		del_timer_sync(&polling_timer);
>  	del_timer_sync(&charger_timer);
> --=20
> 1.7.10.4
>=20

--=20
balbi

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTFSIAAoJEIaOsuA1yqREiCYP/RUl/FVXFj1dweGckF6X2URT
zRqSSrNOmV1D4N9hYC6kp8vJ0vrb5kzxM0otLqWRMWutIoF2KdVeEqZEBz/uZ09V
dDIrnQaNUGb+p3QruNv0tQF7KTkrYsiwYfPLY/PUmPV5ZwRaXyjQAxVNL9eDOYIQ
0UnYabSNXO+tWVIlrHbx9tyfme5+bt67gZIycOF3FoaN+E/Ut4AQ3jzEqh7g0DPR
vK8lO2tQVTV7pTF9+/7lYS8y2sKg/FdoMTdixtE2zx72oJf6zNnk264E+xOyvMcu
RUeQ2J1e3U5c/HnosJ8JHBGhyANJ3uQQ84ZzMpCTthHoc9Qf3pO23EjfUDvIl/us
uZVnsYIOh2/yZ4OU1C7j3C0ZlYfL0nCaFeXTzYD00Kvyt9OrsXzPj2FeJBaC0QMG
bThaPSJwqhU56vWHq5LRhiYZhPctCS0AUmMEyX0UiAeeFjXqDrEayBCOH4SLD87j
hnaD2cKwvWubKD82xy3aQaw+lEG8IlQLX2S/AbR1TZotuTRqfuV8Hbk/E90EU5HS
JI0CW5cfcNspSAG7COQfXlpNJxQ1ZTl7ufG9Fq+3PnELVTZjT5ExZUojSiZz9929
tVPsL8591cI1Dd8rUqUFXtL53ePQi7J7Ozgyk0EBWBOuXAHms/vr0Ml9qjeU9onb
926ud/hf7Y4S/t8ifnfT
=B92n
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
