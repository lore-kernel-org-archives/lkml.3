Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab3G2SIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:08:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50158 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3G2SIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:08:22 -0400
Date: Mon, 29 Jul 2013 21:08:12 +0300
From: Felipe Balbi <balbi@ti.com>
To: Illia Smyrnov <illia.smyrnov@ti.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v3 2/3] Input: omap-keypad: errata i689: Correct debounce
 time
Message-ID: <20130729180812.GG4964@radagast>
Reply-To: <balbi@ti.com>
References: <1375116311-13999-1-git-send-email-illia.smyrnov@ti.com>
 <1375116311-13999-3-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FLPM4o+7JoHGki3m"
Content-Disposition: inline
In-Reply-To: <1375116311-13999-3-git-send-email-illia.smyrnov@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FLPM4o+7JoHGki3m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 29, 2013 at 07:45:10PM +0300, Illia Smyrnov wrote:
> From: Axel Haslam <axelhaslam@ti.com>
>=20
> Set debounce time value to 12ms to workaround the errata.
>=20
> ERRATA DESCRIPTION:
> When a key is released for a time shorter than the debounce time,
> in-between 2 key press (KP1 and KP2), the keyboard state machine will go =
to
> idle mode and will never detect the key release (after KP1,and also after=
 KP2),
> and thus will never generate a new IRQ indicating the key release.
> From the operating system standpoint, only a key press as been detected,
> and the key will keep on being printed on the screen until another or
> the same key is pressed again.When the failing state has been reached,
> the KBD_STATEMACHINE register will show "idle state" and the KBD_FULLCODE
> register won't be empty, this is the signature of the bug.There is no imp=
act
> on the power consumption of the system as the state machine goes to IDLE =
state.
>=20
> WORKAROUND:
> First thing is to program the debounce time correctly:
> If X (us) is the maximum time of bounces when a key is pressed or release=
d,
> and Y (us) is the minimum time of a key release that is expected to be de=
tected,
> then the debounce time should be set to a value inbetween X and Y.
>=20
> In case it is still possible to get shorter than debounce time key-release
> events, then the only solution is to implement a software workaround:
>=20
> Before printing a second character on the screen, the software must check=
 if
> the keyboard has hit the failing condition (cf signature of the bug above)
> or if the key is still really pressed and then take the appropriate actio=
ns.
>=20
> Silicon revisions impacted: OMAP4430 ES 1.0,2.0,2.1,2.2,2.3
>                             OMAP4460 ES 1.0,1.1
>                             OMAP5430 ES 1.0

if only these are affected, should you have revision check ? Also we
don't support OMAP5430 ES 1.0. I say this because, IMO, debouncing time
is likely to be board-specific and/or application-specific.

> diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboa=
rd/omap4-keypad.c
> index feab00f..e8bdc76 100644
> --- a/drivers/input/keyboard/omap4-keypad.c
> +++ b/drivers/input/keyboard/omap4-keypad.c
> @@ -62,8 +62,10 @@
> =20
>  /* OMAP4 values */
>  #define OMAP4_VAL_IRQDISABLE		0x0
> -#define OMAP4_VAL_DEBOUNCINGTIME	0x7
> -#define OMAP4_VAL_PVT			0x7
> +
> +/* Errata i689: set debounce time value to 12ms */
> +#define OMAP4_VAL_DEBOUNCINGTIME	0x2
> +#define OMAP4_VAL_PVT			0x6

to make this easier to understand, you might want to convert this into a
better macro that takes an argument in microseconds and you calculate
the debouncing time which should be written to HW.

--=20
balbi

--FLPM4o+7JoHGki3m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9q+MAAoJEIaOsuA1yqREI0YP+wb3LdCD9jqLKao2yeF4OnqI
RjTtngNmCfqmDL2mpyo8HLz+dRNSt3sBeR+E129Y7TaL0YbggfpIATGRTgL0ijDE
KgFwbKZu4uT2YQt0l/Eq0nJeDKtiMawXwxZONFpFiLeDki+oTXuLEhCvyJ7kdEpG
SX6cPjT02ScLbXxT+f6hRPt4AWK2lOdgKDhZHtGbusUz6G+Npc/E28YrTZV5uYXc
vCk74D3uDhbp3M9tnFVxOqSDSGTKhVpp4pxiNJwzvxwfxUXM5w9sYC+VuMk2s64O
Dup6D8EknuSoiZKLOAwxrWDx64tpSACYq9k86Gpzu4ZizHG3LHqkD/3bYObzyYy/
xnXU4yJdR6w8S0ByVOh+8R3KeD9hPO5iFC/g3MnOqbLMgb8cqojTLfEFLxcs9cry
AaRXCQlV7KJ21Yw8iPkWFhFEqO4MSZpMxCx0uVNxb8Bu9HLDDpNF6UjDwFs4OI8j
JEmNYxOvdR25wVZKpk48L687h81Uzf/msdZRHhB1B0kXfceB8iY39aTNon/bNZ5c
7Hd/LZj8CkuGBwGjyyoPrzOmFUXQS9h3s47OL6rqkwUA5Q1lsz2lVkDTdbRhAmq6
Loe2iC31jEorjLxVn0NAQac4cT6jrSVS0EevNgzjYWXZj8p9H6syRERZbf0C7gPt
OkRKC6VizDUbDd8iTokS
=ZCke
-----END PGP SIGNATURE-----

--FLPM4o+7JoHGki3m--
