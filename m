Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3GHH4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:56:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56646 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab3GHH4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:56:38 -0400
Date: Mon, 8 Jul 2013 10:56:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 1/4] usb: limit OMAP related USB options to OMAP2PLUS
 platforms
Message-ID: <20130708075605.GA29100@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
 <1372916353-24050-2-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <1372916353-24050-2-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 04, 2013 at 01:39:10AM -0400, Paul Gortmaker wrote:
> commit 57f6ce072e35770a63be0c5d5e82f90d8da7d665 ("usb: phy:
> add a new driver for usb3 phy") added the new Kconfig option
> OMAP_USB3, but it had no dependencies whatsoever, and hence
> became available across all arch/platforms.
>=20
> Which presumably caused this to show up in x86 randconfig:
>=20
>     warning: (USB_MUSB_HDRC && OMAP_USB3) selects \
>         OMAP_CONTROL_USB which has unmet direct \
>         dependencies (USB_SUPPORT && ARCH_OMAP2PLUS)
>=20
> Then commit 6992819feb39cb9adac72170555d957d07f869f2 ("usb: phy:
> fix Kconfig warning") was added.  However, this just deleted the
> ARCH_OMAP2PLUS dependency from OMAP_CONTROL_USB, further
> compounding the problem by opening up OMAP_CONTROL_USB to
> all arch/platforms as well.
>=20
> Earlier it was suggested[1] that we revert the change of 6992819feb
> to restore the dependency, and add a same ARCH_OMAP2PLUS dependency
> to the new OMAP_USB3 entry.  However that was discouraged on the
> grounds of people wanting the extra sanity compile testing on x86,
> even though the driver could probably never be used there.
>=20
> Now we have CONFIG_COMPILE_TEST, so developers who value the ability
> to compile drivers on an architecture that it never can be used for
> can have that, and people who want dependencies to shield them from
> seeing options that aren't relevant to their platform get what they
> want too.
>=20
> Here we restore the dependency but couple it with COMPILE_TEST, in
> order to achieve both of the above goals.
>=20
> [1] https://patchwork.kernel.org/patch/2194511/
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Moiz Sonasath <m-sonasath@ti.com>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR2nCmAAoJEIaOsuA1yqRE/mcP/1UBQ0r0o8ssnM/aaPml+0RK
sU8hujcHi9PeRpkLi5wHi3KhUUShtbKgFGqFBeLI6dRMa//JkuH1pCSXBA5xdYtt
au0f2G4bl6k8JwrtC04CqMAnVPlsGuRKJpRi0GKXsaU4A2RpvFxRFXENUTj+H0Md
icN8leARHuZWFTk2hBfKvbrTNtHSrmVumuM7ftUilAkB2cBRP2kvqPeXdLRfC7zQ
VPC7WC85LFzSH4AdTSpB3LPjHAqYhWqbLslR07CVGB4RnZ7CdI5QlaNbWIoo3SDA
L9VfM8mDrAOxdX+XqYgkjiT/x43JL61YaWLeKAN9WdyoV5gPzuXYqBMcntH0Go34
MXUNX/GMjag24aVoPv2EqT2uS+2hww5sLUBooH+kcOXXQBN8WuICCndrPdDMzrxU
LZ0mYf0EFgL2bUlJhgEQDbudUzh/V8+MWVtk6m0Qt/CAby7tDootJ/kzU4y+8ZZW
mbrwr7cMN8oHc9uvnq4UvVAHabNpLueejiq8GH1Yk43zwL6sOBABgxHPA4sTYdWP
Sc50VOpqGZCVE6hzDfyXvIkf1ZK2JHiY8N75872aoi2C05OcnpyXpUaTZb6HDc4y
GYMlVS0xwyRnD6wFxTMmDydp/2tvAUU6GT8BeSJ6yIco4KjhrrhIavRtrW/f+T9m
kRO4sBJrrNYXvLf8N/6l
=qSak
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
