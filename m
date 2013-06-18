Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3FRIDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:03:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51656 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab3FRID1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:03:27 -0400
Date: Tue, 18 Jun 2013 11:01:30 +0300
From: Felipe Balbi <balbi@ti.com>
To: Chao Xie <chao.xie@marvell.com>
CC: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <rogerq@ti.com>,
        <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <xiechao.mail@gmail.com>
Subject: Re: [PATCH] USB: initialize or shutdown PHY when add or remove host
 controller
Message-ID: <20130618080130.GC5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371539701-11441-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Content-Disposition: inline
In-Reply-To: <1371539701-11441-1-git-send-email-chao.xie@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 18, 2013 at 03:15:01AM -0400, Chao Xie wrote:
> Some controller need software to initialize PHY before add
> host controller, and shut down PHY after remove host controller.
> Add the generic code for these controllers so they do not need
> do it in its own host controller driver.
>=20
> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> ---
>  drivers/usb/core/hcd.c |   19 ++++++++++++++++++-
>  1 files changed, 18 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index d53547d..b26196b 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -43,6 +43,7 @@
> =20
>  #include <linux/usb.h>
>  #include <linux/usb/hcd.h>
> +#include <linux/usb/phy.h>
> =20
>  #include "usb.h"
> =20
> @@ -2531,12 +2532,22 @@ int usb_add_hcd(struct usb_hcd *hcd,
>  	 */
>  	set_bit(HCD_FLAG_RH_RUNNING, &hcd->flags);
> =20
> +	/* Initialize the PHY before other hardware operation. */
> +	if (hcd->phy) {

this looks wrong for two reasons:

a) you're not grabbing the PHY here.

	You can't just assume another entity grabbed your PHY for you.

b) usb_get_phy() returns an error number

	so the proper check would be !IS_ERR()

--=20
balbi

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwBPaAAoJEIaOsuA1yqREQKEP/R7KOSP/hWVy6fL+fXAmVA7y
2OufaAwiuHj6hgpg7Nt/uqNqG8Vq7KVvWlXqnA3v4x5fjbXr2tEYPZWJjOVAwwy9
t3WGaCmwJoxFqt1fP/qd1IpO5IgxNUewYo1R8xAWLf1DW+Tk66C7aA5rT6WvJ1og
H9t5Vkv0Xu70fPPnw5E8kEUShbGCwA8YrHlennPY0rpZPdiXcUC9eaEjEGZPAUME
nl4oCxvPKUiYDOKR2WrFyXfg3RcE5KHsU3q42K/Vt4O6OiziPGtYPmVO7oKROr7l
RzuBlAxyj+xU+PmAAQvk3vrQQIlBVnMdSR45IkW5wB3URj9H2j1b6gySDoBrAAuI
PK1Kfr+wdv9rHmDGtuNVNYmTXrSKMLAe7zzZRnLHeNfHEzHD2OqfYVNm9xayTGBB
8DK7Tr2BFXoqyeVFjDlsfeuNHz1n6frdUswsQllPezflQPs2+hLPDwXN1essDtQ5
wl9v8xg79NYMd3DwDWmYhulB6pizjIikUVHKyYW6ZBVSyTsEDD4xvLQW8qn5m6Rp
9lmoaiNq3Zmr40DNfviOM/lZrleKFRdlIr/wnnbtpyz5pmOLXzoCxLltOY9iPVB8
itQMssagI7RC2ir5nT7QT5Winu8NeTi6x7MzFDyohXGZ+wiuCkkFEq9hQfOXPXN7
w5OXmPB+twLTmtwNQqlo
=ALnt
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
