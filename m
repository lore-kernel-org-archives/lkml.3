Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab3GWRSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:18:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57392 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630Ab3GWRSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:18:40 -0400
Date: Tue, 23 Jul 2013 20:18:38 +0300
From: Felipe Balbi <balbi@ti.com>
To: Illia Smyrnov <illia.smyrnov@ti.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, <balbi@ti.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] Input: omap-keypad: Clear pending interrupts on
 open
Message-ID: <20130723171838.GA9166@radagast>
Reply-To: <balbi@ti.com>
References: <1374595798-15492-1-git-send-email-illia.smyrnov@ti.com>
 <1374595798-15492-4-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <1374595798-15492-4-git-send-email-illia.smyrnov@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 23, 2013 at 07:09:58PM +0300, Illia Smyrnov wrote:
> Clear pending interrupts when open keypad.

where are these interrupts coming from ?

> Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
> ---
>  drivers/input/keyboard/omap4-keypad.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboa=
rd/omap4-keypad.c
> index b876a0d..62abc3e 100644
> --- a/drivers/input/keyboard/omap4-keypad.c
> +++ b/drivers/input/keyboard/omap4-keypad.c
> @@ -185,13 +185,14 @@ static int omap4_keypad_open(struct input_dev *inpu=
t)
>  			(OMAP4_VAL_PVT << OMAP4_DEF_CTRL_PTV_SHIFT));
>  	kbd_writel(keypad_data, OMAP4_KBD_DEBOUNCINGTIME,
>  			OMAP4_VAL_DEBOUNCINGTIME);
> -	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS,
> -			OMAP4_VAL_IRQDISABLE);
>  	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
>  			OMAP4_DEF_IRQENABLE_EVENTEN |
>  				OMAP4_DEF_IRQENABLE_LONGKEY);
>  	kbd_writel(keypad_data, OMAP4_KBD_WAKEUPENABLE,
>  			OMAP4_DEF_WUP_EVENT_ENA | OMAP4_DEF_WUP_LONG_KEY_ENA);
> +	/* clear pending interrupts */
> +	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS,
> +			 kbd_read_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS));

you might want to clear these interrupts before unmasking them :-)

--=20
balbi

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR7rruAAoJEIaOsuA1yqREfYcP/iDwq1NDC6D7pH3Xh6Aamnqu
Dxpb/1i8/IaHPfPNnGQAICSPgZ9sjTTc9tWvfodPQQaN0j+vCyBehE/PCFSXS7Ug
V2X8yh5Jk2mWOK93QlgMumhjbhk46UYnPUjrym4HDS3vHA+cUpE0aFPms9FeSHvU
USqsmS7vP/Ul/+vZWXMLILAjEAGO/nd/S07QkK/DG17kSfvIl+L3RJKJ3CR1Tpa7
wLTAuRB5sOVBwTrDrVQshGna0WE6DC3X9OGpDVjQDdc6YhYJFXFPdwB2Bhq05Xwi
+YYThVW/PjZcCWi1Jw9gmxCWWrqb7E62NqDrEGjG2P5k6rzz+AHMG4MkeIwLq9P8
5DFVWnQ6uZwlrj/DE+6UDBN63E4vaS+T8hnwjP3dxLB6TkNvmsTL5lFIoXj9OzmD
RgeIGwxSlU0RHhCnwRbvpemAL/+CVgSLjpky193hHjGShxnyf6HAhzh4e6gFLUXh
0xal/gqfPoY5iokahdYMj2k26EeRNn1gpdgNXkvwzA2urllhyGu/6Rmqgv8vjqTY
zvXfBxMl1khBFaWQgUuFjXi7/z8Xw1xRlpu+/m0n8pwzZXePn4H/YXJz1EAeXRRv
ZpU8I8CZYQnp73vDb3yHpQTVtX20DUZxY5baIPgmJhfK+lVC99Ab4QxN8YiLZGPS
rWhK5fnwjZ0A/w7/2rM+
=u7k9
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
