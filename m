Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab3FRIjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:39:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50302 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3FRIi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:38:59 -0400
Date: Tue, 18 Jun 2013 11:37:12 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, Chao Xie <chao.xie@marvell.com>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <xiechao.mail@gmail.com>
Subject: Re: [PATCH] USB: initialize or shutdown PHY when add or remove host
 controller
Message-ID: <20130618083712.GJ5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371539701-11441-1-git-send-email-chao.xie@marvell.com>
 <20130618080130.GC5461@arwen.pp.htv.fi>
 <51C0191F.2050104@ti.com>
 <20130618082428.GF5461@arwen.pp.htv.fi>
 <51C01B80.3050803@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GlnCQLZWzqLRJED8"
Content-Disposition: inline
In-Reply-To: <51C01B80.3050803@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GlnCQLZWzqLRJED8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 18, 2013 at 11:34:08AM +0300, Roger Quadros wrote:
> >>> On Tue, Jun 18, 2013 at 03:15:01AM -0400, Chao Xie wrote:
> >>>> Some controller need software to initialize PHY before add
> >>>> host controller, and shut down PHY after remove host controller.
> >>>> Add the generic code for these controllers so they do not need
> >>>> do it in its own host controller driver.
> >>>>
> >>>> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> >>>> ---
> >>>>  drivers/usb/core/hcd.c |   19 ++++++++++++++++++-
> >>>>  1 files changed, 18 insertions(+), 1 deletions(-)
> >>>>
> >>>> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> >>>> index d53547d..b26196b 100644
> >>>> --- a/drivers/usb/core/hcd.c
> >>>> +++ b/drivers/usb/core/hcd.c
> >>>> @@ -43,6 +43,7 @@
> >>>> =20
> >>>>  #include <linux/usb.h>
> >>>>  #include <linux/usb/hcd.h>
> >>>> +#include <linux/usb/phy.h>
> >>>> =20
> >>>>  #include "usb.h"
> >>>> =20
> >>>> @@ -2531,12 +2532,22 @@ int usb_add_hcd(struct usb_hcd *hcd,
> >>>>  	 */
> >>>>  	set_bit(HCD_FLAG_RH_RUNNING, &hcd->flags);
> >>>> =20
> >>>> +	/* Initialize the PHY before other hardware operation. */
> >>>> +	if (hcd->phy) {
> >>>
> >>> this looks wrong for two reasons:
> >>>
> >>> a) you're not grabbing the PHY here.
> >>>
> >>> 	You can't just assume another entity grabbed your PHY for you.
> >>
> >> Isn't that done in the controller drivers e.g. ehci-fsl.c, ohci-omap, =
etc?
> >=20
> > right, and what I'm saying is that it should all be re-factored into
> > ehci-hcd core :-)
> >=20
> >> If the controllers don't want HCD core to manage the PHY they can just=
 set it
> >> to some error code.
> >=20
> > they shouldn't have the choice, otherwise it'll be a bit of a PITA to
> > maintain the code. ehci core tries to grab the PHY, if it's not there,
> > try to continue anyway. Assume it's not needed.
> >=20
>=20
> OK fine, but ehci-omap is a weird case as it needs a slightly different
> sequence as to when PHY is initialized depending on which mode it is. (Tr=
ansceiver
> or transceiver-less). please see this fix.
> http://www.spinics.net/lists/stable/msg12106.html
>=20
> All I'm saying as that ehci-omap needs a way to tell hcd core that it nee=
ds PHY
> handling for itself.

why don't you do that always ? Meaning, why don't you *always* take PHY
out of suspend ? If PHY is suspended, you can't wakeup unless you have
(in OMAP case) pad wakeup working, right ?

Moreover, if you can suspend the PHY and still wakup, that's something
we need to teach the PHY layer about. Currently it doesn't know anything
about such wakeup capable PHYs ;-)

--=20
balbi

--GlnCQLZWzqLRJED8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwBw4AAoJEIaOsuA1yqREm8AQAIUAAvjrAU6cSsWDAGbUu2aJ
BJdun2V41kTDg2AvkE6uzmuKfOqm1tiqrllhvTap2IbHtAVnBECn1LyWkTqz9xmY
7AMKkCwaSvNCEPcskBwdzOMYr13MeyeU3tJYKeIgR+lpdMUFPpZXaJbE23lrodOG
mSGh3KDK95hEQnMhN03MTwRW75puRayHKNOPTif8rz0yKhju2DdvsWxlP+QC8WOw
UYHxhrvWrdeHGwKys8uQCWGpM8Tt9WByREur0kp0lP0Jnx/f78miyV3Rq/Tncmd4
czqhpL+mj79k//QnXoA/AI1sPTv1tDfLipteaVDttdr8errSGMN6bIJIzfyHTh50
7LX0n3Piixfe7LynpIFdpuA82EtVP7E4rWothHrDxcg97hJGz9nTTJqlKdunhDR8
qXyN34OG7ZxMxFO0wWp3WtjYWS7ktMzQzdBk6mYGmwFnZPE3XgiItKtHYcn1I8Ma
CI+kcoFJGh54kXN09KlSj98G4TVXdp2fN+QOHnkdPMyGBCcmOLnSg2l/GuzbXlZw
1fNIkDXZTvO6sOEb3ORsI6PXH+apHNvaBMuPI3i45ZsaspZAewshfR7aSZUIRwWe
jLS7A6QVbnX5YPm0WNLiSAJGj9uTx3cvaFiHEDjLYiDP+vQ1a61lSz56/sYHNpH0
JjYWY2AtxjPtCXCF7G3R
=j08c
-----END PGP SIGNATURE-----

--GlnCQLZWzqLRJED8--
