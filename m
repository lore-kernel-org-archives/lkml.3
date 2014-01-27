Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaA0PcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:32:08 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43335 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbaA0PcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:32:06 -0500
Date: Mon, 27 Jan 2014 09:30:38 -0600
From: Felipe Balbi <balbi@ti.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        <valentine.barshak@cogentembedded.com>
Subject: Re: [PATCH] usb: phy: Quiet unable to find transceiver message
Message-ID: <20140127153038.GA13268@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140125150559.GN16455@hansolo.jdub.homelinux.org>
 <Pine.LNX.4.44L0.1401251035570.7061-100000@netrider.rowland.org>
 <CA+5PVA7iFPHXz1Mn+Ri07Ajr1FYpm1ubVoq-twrFC1Rbu=p_HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <CA+5PVA7iFPHXz1Mn+Ri07Ajr1FYpm1ubVoq-twrFC1Rbu=p_HA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 25, 2014 at 03:24:55PM -0500, Josh Boyer wrote:
> On Sat, Jan 25, 2014 at 10:37 AM, Alan Stern <stern@rowland.harvard.edu> =
wrote:
> > On Sat, 25 Jan 2014, Josh Boyer wrote:
> >
> >> commit 1ae5799ef6317 ("usb: hcd: Initialize USB phy if needed") allows
> >> the USB layer to initialize external PHYs if needed.  However, a PHY is
> >> not needed in all cases.  The usb_get_phy_device function will print
> >> an error message, "unable to find transceiver" but everything still
> >> functions normally.
> >>
> >> Drop the severity of this message to pr_debug.
> >>
> >> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> >> ---
> >>  drivers/usb/phy/phy.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
> >> index e6f61e4..c7fe880 100644
> >> --- a/drivers/usb/phy/phy.c
> >> +++ b/drivers/usb/phy/phy.c
> >> @@ -228,7 +228,7 @@ struct usb_phy *usb_get_phy_dev(struct device *dev=
, u8 index)
> >>
> >>       phy =3D __usb_find_phy_dev(dev, &phy_bind_list, index);
> >>       if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> >> -             pr_err("unable to find transceiver\n");
> >> +             pr_debug("unable to find transceiver\n");
> >>               goto err0;
> >>       }
> >
> > Wouldn't it make more sense to change this to dev_debug?  As it stands,
> > the user has no idea which device is lacking a transceiver.
>=20
> Quite possibly, yes.  I'm not overly familiar with the subsystem and
> was just writing up what Felipe suggested.
>=20
> > (The same is probably true for other log messages in this source file.)
>=20
> I don't disagree, but I'd rather someone with more experience in the
> USB subsystem do that kind of broader audit/change.  I'd be happy to
> test.

yeah, I just sent a patch where I forgot to switch over to dev_dbg(), if
you can do that for both messages and remove the out of memory message,
I'd be glad to take your patch instead of mine.

cheers

--=20
balbi

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS5nueAAoJEIaOsuA1yqREo5QP/jpfjz/Fyn4B9dwjjNCKu/o0
322Y2eocb5gyIGey15uwvu1plh5/ZG7HexW+nuZkz+bUY/dj8b1Gm12JbcZZQ537
Imi6SbOqBxlBOwk+NcxtMrq636KqyjYt49PxbkC/piYvYPbydV7f0eFHM+e1fkFu
yfUV30MkTcMlTwSFo91FfP1dAu5yjdcXNDiU8a9Q7ta1uwyhDusbLlAuLz0jUdRf
XxuHINQZB2IVu84mhgQUJb1TOdWAgPMQYe/6Yz0NLEI/GLKMZ0vHsLwaRp/rz22S
GUias3OmiFdKz7kjPJKJ83NVFNZZIbhkdL7+FK5jH5m8Gs/qbuYituQKrPw0WNw6
dGnrspzsMQM2Mfcbn4oHhOp+0UqZ2x6yGD4o/cEgP+zh901kMGfPdS7cYyYc0a5R
fwPr/Hj0hQPnm1t3kpItrn0mLd/sLkKdQ8V4DQuk9dpUMjZRV/lRnTm/No9yvpHC
3j+SAzELLmz6xTxTGG2/wW64DEi/FYJ7nvgDvK8sH7/n4YWNRDoUGj4P7QumjBId
i5prvms3JREaLjQeA4ZIAvcGMIg44Jxtn+NA5dFV+dd4rMoxnCi/Kq1/22vC4gYE
bIUgOrfbZ6/QVjbN2Du7ucQI8Cfe5TLb4v7qB+61FpwLXw82AixdxAQp01bJ/JPp
qdIUWtQ3bpNmHzq5CvsT
=S9l7
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
