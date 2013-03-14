Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab3CNAcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 20:32:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57146 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754015Ab3CNAcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 20:32:02 -0400
Message-ID: <1363221113.3937.101.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] dmi_scan: proper buf type in dmi_present()
From: Ben Hutchings <ben@decadent.org.uk>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: tmhikaru@gmail.com, akpm@linux-foundation.org, zhenzhong.duan@oracle.com,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 00:31:53 +0000
In-Reply-To: <1363119427-4371-1-git-send-email-artem.savkov@gmail.com>
References: <1363119427-4371-1-git-send-email-artem.savkov@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-83ms+Va9lISuucSy2V+z"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-83ms+Va9lISuucSy2V+z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-03-13 at 00:17 +0400, Artem Savkov wrote:
> buf needs to be unsigned in dmi_present(), otherwise dmi_base calculation
> doesn't work properly leading to a wraparound during dmi_ioremap:
>=20
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/x86/mm/ioremap.c:524 __early_ioremap+0x85=
/0x18a()
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 3.9.0-rc2-next-20130312 =
#283
> [    0.000000] Call Trace:
> [    0.000000]  [<c1036992>] warn_slowpath_common+0x72/0xa0
> [    0.000000]  [<c19cc176>] ? __early_ioremap+0x85/0x18a
> [    0.000000]  [<c19cc176>] ? __early_ioremap+0x85/0x18a
> [    0.000000]  [<c10369e2>] warn_slowpath_null+0x22/0x30
> [    0.000000]  [<c19cc176>] __early_ioremap+0x85/0x18a
> [    0.000000]  [<c19cc1ed>] ? __early_ioremap+0xfc/0x18a
> [    0.000000]  [<c19cc412>] early_ioremap+0xd/0xf
> [    0.000000]  [<c19fbba9>] dmi_present+0xf5/0x22a
> [    0.000000]  [<c19fbd9d>] dmi_scan_machine+0xbf/0x11c
> [    0.000000]  [<c19bd781>] setup_arch+0x4db/0xca0
> [    0.000000]  [<c168105c>] ? printk+0x3d/0x3f
> [    0.000000]  [<c19ba763>] start_kernel+0x7b/0x329
> [    0.000000]  [<c19ba361>] i386_start_kernel+0x137/0x13a
> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
> [    0.000000] DMI not present or invalid.
>=20
> Introduced in "dmi_scan: refactor dmi_scan_machine(), {smbios,dmi}_presen=
t()"
>=20
> Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
Acked-by: Ben Hutchings <ben@decadent.org.uk>

Wow, this is a pretty obvious fix.  Somehow this code did work for at
least two of us, so I suppose we were (un)lucky to have bit 7 clear on
all the critical bytes!

Ben.

> ---
>  drivers/firmware/dmi_scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index 3439f59..40e940d 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -410,7 +410,7 @@ static void __init dmi_dump_ids(void)
>  	printk(KERN_CONT "\n");
>  }
> =20
> -static int __init dmi_present(const char *buf)
> +static int __init dmi_present(const u8 *buf)
>  {
>  	int smbios_ver;
> =20

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-83ms+Va9lISuucSy2V+z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUEaeee/yOyVhhEJAQrLzQ//St6l/b1HsO8lYBzkDsZdxN9SYdeZbg+q
VZ2B2hi6Jv/F1uSbSslj/F2ddfU/7JWMVgDLn5E/fAOMlWChemRwjgK13uaj5Zta
mcQo1MeV0Jsx85OjgRHzk3R7XHWvSDLXUx1vL4NWAshOqGmkABkPtXFuUvYu76Kt
26EebIeIp/p3RKFkDOaDUcRqmIZXdmKAeNNWNO0vlaqPWcq3w66cKn8hC6hL9sx7
UAW4+bW+e6mHtDmTQy6zcjbkOK0nO9WtuMiBl4pgGjAGc1CyJzq1EVfNebHIr5YV
P6keR0pR7Pw8csYssozn3xLzTP4SKTwCsXIoN+a53Jq7PydGcI/Erfpj4Ie7uEMk
9V67EajLVWJeOrq+gxXhIUJKoPh0QLkyu15uFpIrV2wiy68bdIytLMu2WNRvt+Ox
E/VSVqhltcooOzBewqa30GJNwdZVjRe0ZuAkUBZveAuILk/oMuqjUi6lGqbe2UZY
HpNbNGAOsl8IDWMeKmu96thEDMlAswwc32iNzEC6ReB/5nsmF9ZX7v8C56sKpJyU
dO8+sWS6Xq9dIENE/aiNZ3yTJdZkGyMFkmhec/6En8n7Sylnq0BqaOfhlCtj0blq
mNXU9j9n0rIqVY0aUzo7c12Xfe65RtS1MYtOATBtAyGj7a7/+WYAdwgZov1sWP1k
/MDaqEjxVAw=
=g/ai
-----END PGP SIGNATURE-----

--=-83ms+Va9lISuucSy2V+z--
