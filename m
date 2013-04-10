Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936452Ab3DJJQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:16:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59412 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3DJJQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:16:36 -0400
Message-ID: <51652DDF.8000100@pengutronix.de>
Date: Wed, 10 Apr 2013 11:16:15 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Hector Palacios <hector.palacios@digi.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "aletes.xgr@gmail.com" <aletes.xgr@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v2 2/2] mmc: mxs-mmc: add non-removable property
References: <1365166070-9370-1-git-send-email-mkl@pengutronix.de> <1365166070-9370-3-git-send-email-mkl@pengutronix.de> <51643053.7030302@digi.com> <516431F9.8010302@digi.com> <51644302.6000109@pengutronix.de> <516520AA.8030300@digi.com>
In-Reply-To: <516520AA.8030300@digi.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2EQSCXBSGRPTCXDAGAJSR"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2EQSCXBSGRPTCXDAGAJSR
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 04/10/2013 10:19 AM, Hector Palacios wrote:
> On Tue 09 Apr 2013 06:34:10 PM CEST, Marc Kleine-Budde wrote:
>> On 04/09/2013 05:21 PM, Hector Palacios wrote:
>>> On 04/09/2013 05:14 PM, Hector Palacios wrote:
>>>> @@ -95,7 +97,8 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
>>>>           struct mxs_mmc_host *host =3D mmc_priv(mmc);
>>>>           struct mxs_ssp *ssp =3D &host->ssp;
>>>>
>>>> -       return !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
>>>> +       return host->non_removable || host->broken_cd ||
>>>> +              !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
>>>>                    BM_SSP_STATUS_CARD_DETECT);
>>>>    }
>>>
>>> Sorry, I missed your original XOR here, when merging my changes:
>>
>> Can you send an incremental patch against my 2/2 with your
>> Signed-off-by, I'll squash your patch into mine and repost the series.=

>=20
> Sure. Here it is:
>=20
> From 18f6199947bc2681d2d63b307506019535018646 Mon Sep 17 00:00:00 2001
> From: Hector Palacios <hector.palacios@digi.com>
> Date: Wed, 10 Apr 2013 09:16:31 +0200
> Subject: [PATCH] mmc: mxs-mmc: handle 'broken-cd' property
>=20
> According to bindings documentation for mmc, the property 'broken-cd'
> can be used to indicate card-detection is not available and polling
> must be used instead. This patch retrieves this property
> and sets a custom flag. On the get_cd() hook, it returns 1 if
> the flag is set, to always assume the card is present.
>=20
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>

Thanks, your patch description is so good, I'll keep your patch as 3
and repost the whole series.

Marc

P.S.:
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2EQSCXBSGRPTCXDAGAJSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlFlLecACgkQjTAFq1RaXHP10ACaA2KGRg959+/WhqB72oOuOjXm
SGsAn3xtU3Vo9ZYXimFgXiXFvDu3gnZY
=orlO
-----END PGP SIGNATURE-----

------enig2EQSCXBSGRPTCXDAGAJSR--
