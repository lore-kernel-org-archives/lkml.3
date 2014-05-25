Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaEYXND (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 19:13:03 -0400
Received: from ozlabs.org ([103.22.144.67]:52376 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaEYXNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 19:13:00 -0400
Date: Mon, 26 May 2014 09:12:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vincent =?UTF-8?B?U3RlaGzDqQ==?= <vincent.stehle@laposte.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrzej Hajda <a.hajda@samsung.com>, Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH linux-next] imx-drm: imx-tve: remove unused variable
Message-ID: <20140526091252.2a4496d4@canb.auug.org.au>
In-Reply-To: <20140525221235.GA26619@kroah.com>
References: <1401054854-20932-1-git-send-email-vincent.stehle@laposte.net>
	<20140525221235.GA26619@kroah.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/g+2..frb0=6hpOuhbCY9=ot"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/g+2..frb0=6hpOuhbCY9=ot
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sun, 25 May 2014 15:12:35 -0700 Greg Kroah-Hartman <gregkh@linuxfoundati=
on.org> wrote:
>
> On Sun, May 25, 2014 at 11:54:14PM +0200, Vincent Stehl=C3=A9 wrote:
> > Commit f9b0e251dfbf 'drm: make mode_valid callback optional' left varia=
ble ret
> > unused; remove it.
> >=20
> > This fixes the following compilation warning:
> >=20
> >   drivers/staging/imx-drm/imx-tve.c: In function =E2=80=98imx_tve_conne=
ctor_mode_valid=E2=80=99:
> >   drivers/staging/imx-drm/imx-tve.c:252:6: warning: unused variable =E2=
=80=98ret=E2=80=99 [-Wunused-variable]
>=20
> It doesn't apply to my tree :(

Yeah, commit f9b0e251dfbf 'drm: make mode_valid callback optional' is
in the drm tree, so this patch needs to go to Dave Airlie (cc'd).
Though Daniel Vetter may want to send it on.

For Dave's benefit, here is the patch again:

From:	Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
Subject: [PATCH linux-next] imx-drm: imx-tve: remove unused variable
Date:	Sun, 25 May 2014 23:54:14 +0200

Commit f9b0e251dfbf 'drm: make mode_valid callback optional' left variable =
ret
unused; remove it.

This fixes the following compilation warning:

  drivers/staging/imx-drm/imx-tve.c: In function =E2=80=98imx_tve_connector=
_mode_valid=E2=80=99:
  drivers/staging/imx-drm/imx-tve.c:252:6: warning: unused variable =E2=80=
=98ret=E2=80=99 [-Wunused-variable]

Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Hi,

This can be seen with e.g. linux next-20140523 and arm allmodconfig.

Best regards,

V.

 drivers/staging/imx-drm/imx-tve.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/im=
x-tve.c
index 3e8b0a1..4caef2b1 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -249,7 +249,6 @@ static int imx_tve_connector_mode_valid(struct drm_conn=
ector *connector,
 {
 	struct imx_tve *tve =3D con_to_tve(connector);
 	unsigned long rate;
-	int ret;
=20
 	/* pixel clock with 2x oversampling */
 	rate =3D clk_round_rate(tve->clk, 2000UL * mode->clock) / 2000;
--=20
2.0.0.rc2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/g+2..frb0=6hpOuhbCY9=ot
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBCAAGBQJTgnj5AAoJEMDTa8Ir7ZwVpLkP+JXHc1/cZgBNKarigDnD9oeF
O6LKgOu5cq3dDYIVpE5Njoy6z/QnpIYg97K7siS6Vq4t1vQqcG7fPa2Ut4h3c295
0xnjhT9OHRlIt7eZAgk6UqJ5Lv8xNjANJh8MmIdpK7DIcgpxjhS0szcPyLMX8bIh
wWoPFrLoy0QM+QT3t4WAiyQHxdyMGdoEAgAMcayhMDb/d+blyv76/kMi4wXeu8ve
th8uPF888UvcqwE6mkP8TQim7Vg6wbPurBo8ig/AzFSfPktLvrZSh69iAU7bZBno
PZ28jaeJYBB8yrKwTN4/nUwHbe9OoBob6n/wbP23hhki+R3R/gLT5Da+GKhUUz9q
akIdxOo7VOq8oYCBR/d04KbKmCs8xxZHdZ0Xn1GSusNRPOyRKo5ZVt9I5dv+O/FR
z1gYPXSoPM5RBDk/tRUC62QKFt5ThiEPvaFHqcPJYLZhy5gMdZbQqfaYCLtbbEMu
boi2Zh2Jt8JLF7NS7O78GOaS5Yg3jGgdFGqOrWIkoAXCLxcQVNcdouWb8fOOzQtW
fuEquu5fm2bTW3jS9sB5Q+/FFAX6n6QFySggoQau1PMmaLiVu59bzXdtpK0GRlIM
u8DVFmv+USBURCn9vnKNm42MpO1nYG27GIrTbajjrPFRIWaGhXiuPtf+LKWCerC8
g2khgZNPOCvtbMN059I=
=glNa
-----END PGP SIGNATURE-----

--Sig_/g+2..frb0=6hpOuhbCY9=ot--
