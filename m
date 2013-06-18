Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab3FRI0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:26:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33531 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab3FRI0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:26:15 -0400
Date: Tue, 18 Jun 2013 11:24:28 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, Chao Xie <chao.xie@marvell.com>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <xiechao.mail@gmail.com>
Subject: Re: [PATCH] USB: initialize or shutdown PHY when add or remove host
 controller
Message-ID: <20130618082428.GF5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371539701-11441-1-git-send-email-chao.xie@marvell.com>
 <20130618080130.GC5461@arwen.pp.htv.fi>
 <51C0191F.2050104@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/QKKmeG/X/bPShih"
Content-Disposition: inline
In-Reply-To: <51C0191F.2050104@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/QKKmeG/X/bPShih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Tue, Jun 18, 2013 at 11:23:59AM +0300, Roger Quadros wrote:
> On 06/18/2013 11:01 AM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Jun 18, 2013 at 03:15:01AM -0400, Chao Xie wrote:
> >> Some controller need software to initialize PHY before add
> >> host controller, and shut down PHY after remove host controller.
> >> Add the generic code for these controllers so they do not need
> >> do it in its own host controller driver.
> >>
> >> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> >> ---
> >>  drivers/usb/core/hcd.c |   19 ++++++++++++++++++-
> >>  1 files changed, 18 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> >> index d53547d..b26196b 100644
> >> --- a/drivers/usb/core/hcd.c
> >> +++ b/drivers/usb/core/hcd.c
> >> @@ -43,6 +43,7 @@
> >> =20
> >>  #include <linux/usb.h>
> >>  #include <linux/usb/hcd.h>
> >> +#include <linux/usb/phy.h>
> >> =20
> >>  #include "usb.h"
> >> =20
> >> @@ -2531,12 +2532,22 @@ int usb_add_hcd(struct usb_hcd *hcd,
> >>  	 */
> >>  	set_bit(HCD_FLAG_RH_RUNNING, &hcd->flags);
> >> =20
> >> +	/* Initialize the PHY before other hardware operation. */
> >> +	if (hcd->phy) {
> >=20
> > this looks wrong for two reasons:
> >=20
> > a) you're not grabbing the PHY here.
> >=20
> > 	You can't just assume another entity grabbed your PHY for you.
>=20
> Isn't that done in the controller drivers e.g. ehci-fsl.c, ohci-omap, etc?

right, and what I'm saying is that it should all be re-factored into
ehci-hcd core :-)

> If the controllers don't want HCD core to manage the PHY they can just se=
t it
> to some error code.

they shouldn't have the choice, otherwise it'll be a bit of a PITA to
maintain the code. ehci core tries to grab the PHY, if it's not there,
try to continue anyway. Assume it's not needed.

--=20
balbi

--/QKKmeG/X/bPShih
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwBk8AAoJEIaOsuA1yqREWJIP/iW4rHtx1cwcc1UBA1+jTgO5
ZHMSN09hV/VxhtVKaotRZDP0uqsLwZEgrJX65GvtRvjjzGeHb6RUawMAGAAhyPlR
SRmXg4awzG8rPyVsMUHq6/kt94lGn8VLuv07I0PIO9YA8knS8KUEj5nYhaVkae5l
I7cbd5+IHnLk+cCnnkhVFuW+eCBMgkuWU3KDJoAQG0bGnZ8ot5WAqAV5333pyAup
L422ZUGmKCoqZ8Ug6ZHaBEEKPL8UOEXyNYJ7H5Q7CLHi5arF6jnkYZnqAlz7/ySk
8AnxotSwAqqU9v7tQEMh6L7WjY7b5bywCszzWcGkfxjQexaevRDK22U73mlzp2FE
m7h+7LGgGxFE/xCOsdXHrH71RqSx4KN7udJ9cEaZA/v4rCDG20+QuAr3T1xeW9Co
Xe72Jf6piVWhWBy0hKjh9fGYYJh4sSuguFiUJENt5cHRur4i/RrlOXaFxA+nYvpf
4mA4PKzQIEnHV5w9DHUzeNZATcQKxvPHXJTk3DUrZQGkD0hHYpJ+fLInSobD1d+Y
aJBXt98RW0N60bfy3E4i5bf99EjYVPwnJt0MrFO37YXWh1QiSFeTlofFLh2KFKfc
lSoHmQRcCxzHzFiNDXpUnEEGoNmEOKOMRDO2CGYlWJ+DjT58mRwU5sRVRpO/2HaN
F7G4NlLaKzIMudR70CWB
=n1KP
-----END PGP SIGNATURE-----

--/QKKmeG/X/bPShih--
