Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab3FZIaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:30:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58567 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab3FZIaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:30:04 -0400
Date: Wed, 26 Jun 2013 11:29:56 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ravi Babu <ravibabu@ti.com>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 3/3] usb: musb: dsps: handle babble condition for dsps
 platform
Message-ID: <20130626082956.GO12640@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1369832824-29071-1-git-send-email-ravibabu@ti.com>
 <1369832824-29071-4-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r7tUYVWcdYzDJoZW"
Content-Disposition: inline
In-Reply-To: <1369832824-29071-4-git-send-email-ravibabu@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--r7tUYVWcdYzDJoZW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 29, 2013 at 06:37:04PM +0530, Ravi Babu wrote:
> @@ -428,6 +436,29 @@ static int dsps_musb_exit(struct musb *musb)
>  	return 0;
>  }
> =20
> +static void dsps_musb_restart(struct musb *musb)
> +{
> +	struct device *dev =3D musb->controller;
> +	struct dsps_glue *glue =3D dev_get_drvdata(dev->parent);
> +	const struct dsps_musb_wrapper *wrp =3D glue->wrp;
> +	void __iomem *reg_base =3D musb->ctrl_base;
> +
> +	/* Reset the musb */
> +	dsps_writel(reg_base, wrp->control, (1 << wrp->reset));
> +	udelay(100);
> +
> +	/* Stop the on-chip PHY and its PLL. */
> +	usb_phy_vbus_off(musb->xceiv);
> +	udelay(100);
> +
> +	/* Start the on-chip PHY and its PLL. */
> +	usb_phy_vbus_on(musb->xceiv);
> +	udelay(100);
> +
> +	/* reinit the endpoint fifo table and restart musb */
> +	musb_restart(musb);

everything here, except for the glue reset, is generic. The thing is
that I don't really think the IP needs to be reset to recover from
babble.

Babble is a valid error condition, it's not even fatal right.

--=20
balbi

--r7tUYVWcdYzDJoZW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyqaEAAoJEIaOsuA1yqRE14kP/jdbsN0orPbdoOmNAO4WApMy
u4NFCgMCuVwifFbhEOi26xrISDwFnhjSIg5GutypN0ERr734kAiFzeAMlalajgea
cIVZ4tEuFDKje2c3SYxVoFAyyeZz9LeTNXEipGdG1/kZE7YBQW3VOTcDVyZ8u1B8
5yThdljjkwSTv0p7nzHvvZESzyHHLEk3wmu+cTFy1iHtfkeaThncZlziH0ipzhs5
3QD9ZkZF9XKoWNclok6G5uIOdG/1T53MEOpRAYO+pzN0WealnYhwe5gM17RCG5UW
644FrUjgA3Ef57iOMqEVk3fi66XPHY4tAvStQwfvIv+IeM2DMQPzpUhBQtSNbCQd
OQqqwj/99eDptJ+uJfp4GPbO+raUu3hnyEx/4yQh/d1qo0Vimw+XNunEWevkAP3l
Uem7ksfLMbI/1dG5hu9Wm3xeg9nDaFak6ArcQ2MVlbVlcZCo3+2fdhCHe9GGOYoY
zuiR+XAUN6Q5M93rQa9ShCyok97R2UlTGXlnzoCx2wfC/YogeOaeHh5d2DN3uZ+A
rlfiqPWvneDfeLcTjsL8uCAyRk5/HM5FCLT4rmVDPNOYcMu1janQ6sbQEtbtAgFS
2sNgA+Bm6buX4D51ql52cD5ZVDWWsphiLL+ubdh29mPjJZ5rqldxyhH2tpN8jHnD
DSkqhCgDOaZh6mO7tfv8
=Ybxs
-----END PGP SIGNATURE-----

--r7tUYVWcdYzDJoZW--
