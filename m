Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227AbaGUPlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:41:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59584 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933199AbaGUPlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:41:47 -0400
Date: Mon, 21 Jul 2014 10:40:52 -0500
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Adam Wozniak <awozniak@irobot.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        "Agius, Frank" <fagius@irobot.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: high cpu load on omap3 using musb
Message-ID: <20140721154052.GJ6852@saruman.home>
Reply-To: <balbi@ti.com>
References: <52E93009.1090609@irobot.com>
 <3341916.JePQu0RYOt@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liqSWPDvh3eyfZ9k"
Content-Disposition: inline
In-Reply-To: <3341916.JePQu0RYOt@avalon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--liqSWPDvh3eyfZ9k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2014 at 05:28:58PM +0200, Laurent Pinchart wrote:
> Hi Adam,
>=20
> On Wednesday 29 January 2014 08:44:57 Adam Wozniak wrote:
> > With a USB 2.0 webcam attached to the OTG port on an OMAP3 (applies to
> > overo gumstix, beagleboard, probably others) we see a high CPU load in a
> > kworker thread.
> >=20
> > Between 2.6.33 and 2.6.34 musb_core.c changed.
> >=20
> > IRQ handlers changed with the result that a worker in musb_core.c got
> > scheduled far more frequently than needed.
> >=20
> > I've included a patch below against 3.7, but i think it'll apply against
> > mainline.
> > [I apologize for any whitespace mangling.  I've also attached the patch=
=2E]
> >=20
> > I'd like more eyeballs to tell me if this is right.  I'd also like to
> > know who I need to talk to to get this pushed into mainline.
>=20
> Running the scripts/get_maintainer.pl script on your patch produces
>=20
> Felipe Balbi <balbi@ti.com> (maintainer:MUSB MULTIPOINT H...)
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:USB SUBSYSTEM)
> linux-usb@vger.kernel.org (open list:MUSB MULTIPOINT H...)
> linux-kernel@vger.kernel.org (open list)
>=20
> Felipe Balbi (CC'ed) is the person who you should talk to.
>=20
> While we're touching the subject of scripts, you should run the=20
> scripts/checkpatch.pl script and fix errors and warnings before submittin=
g=20
> patches. Please see Documentation/SubmittingPatches.
>=20
> Last (but not least) piece of advice, don't give up if you don't receive=
=20
> replies to your patches. People are busy and mails fall to cracks from ti=
me to=20
> time.
>=20
> Felipe, apart from the coding style violation and the possibly missing=20
> locking, what's your opinion on this ? Does the patch make sense ?

It's a duplication of the check which is already in musb_irq_work():

1742 static void musb_irq_work(struct work_struct *data)
1743 {
1744         struct musb *musb =3D container_of(data, struct musb, irq_work=
);
1745=20
1746         if (musb->xceiv->state !=3D musb->xceiv_old_state) {
1747                 musb->xceiv_old_state =3D musb->xceiv->state;
1748                 sysfs_notify(&musb->controller->kobj, NULL, "mode");
1749         }
1750 }

That does look better, but I'd need the check inside musb_irq_work() to
be removed and commit log would have to improve a bit.

ps: there's no missing locking, musb_stage0_irq() is called within
musb_interrupt() which is called within a locked IRQ handler.

--=20
balbi

--liqSWPDvh3eyfZ9k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTzTSEAAoJEIaOsuA1yqREejsP/2IUOVuMQ418cg8jG7rVulzL
praDsWtqAGLvCG/lgLSQmNQQzQ4tfibDsIfYJYUCkvnJhMXPgaI/y8t8ZzyVlUPR
jYzssHzKf0URIoYRj7Z5Axl3T7S01GPW3uiN5gzKaZgyuGBINTr/Wbcwif8lOULo
NKxpe2yzhpfEZxM3k1OE4mfgxbhYuAM7HGuz0GFp+SZ/zv00v3x2+yDbqjlTqKOK
PdV70+INHRBRhrRoI80q9oHEo2L6imm8w/zCHFeAaQ4mnzc8FvuHLcigkKEapMgs
9zb4OIDQrjlALEsQw2ilT5tHSrVLw+s+zeI/ya6PRhbKreHlbCWzrOj+8jYaYQRb
E8kJVbT95FLXBi+gUwQ5JccR/2Bd5qpoRjg7xHJBKSqXcJzb2DDrmUAkuTbgT4WV
ycUI2XaJAefMQaZo2a9YsVCcAFZ7ClqfbcaswP9rOmPCG73yB2/nbQL5Hdt33wZU
u1HJxvIy7T6dgT9buyPjzXVhTAJ+UkK/qt5/UVTHttnAPGIAYeCyMMszQWJgdKL2
AEBdOTu06yVSmrWEF0ldNIoNxhPWczYW5WLHLIerXphRRC2KpMEk20RegUQELs2x
udptQx0iLI6NH5fc+nAgfhK5blif7vEfMt22+zoihjhMp0JI34pkjXuzDIrjY7l/
uhnJgnafqPHvPmJJH24S
=5t3g
-----END PGP SIGNATURE-----

--liqSWPDvh3eyfZ9k--
