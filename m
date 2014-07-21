Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbaGUSwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:52:08 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:36648 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933369AbaGUSwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:52:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: balbi@ti.com
Cc: Adam Wozniak <awozniak@irobot.com>, linux-kernel@vger.kernel.org,
        linux-arm@lists.infradead.org, linux-usb@vger.kernel.org,
        "Agius, Frank" <fagius@irobot.com>
Subject: Re: high cpu load on omap3 using musb
Date: Mon, 21 Jul 2014 20:52:03 +0200
Message-ID: <3287325.pFCFikB7VA@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140721154052.GJ6852@saruman.home>
References: <52E93009.1090609@irobot.com> <3341916.JePQu0RYOt@avalon> <20140721154052.GJ6852@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3635346.O3fFlhQW1J"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3635346.O3fFlhQW1J
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Felipe and Adam,

On Monday 21 July 2014 10:40:52 Felipe Balbi wrote:
> On Mon, Jul 21, 2014 at 05:28:58PM +0200, Laurent Pinchart wrote:
> > On Wednesday 29 January 2014 08:44:57 Adam Wozniak wrote:
> > > With a USB 2.0 webcam attached to the OTG port on an OMAP3 (appli=
es to
> > > overo gumstix, beagleboard, probably others) we see a high CPU lo=
ad in a
> > > kworker thread.
> > >=20
> > > Between 2.6.33 and 2.6.34 musb_core.c changed.
> > >=20
> > > IRQ handlers changed with the result that a worker in musb_core.c=
 got
> > > scheduled far more frequently than needed.
> > >=20
> > > I've included a patch below against 3.7, but i think it'll apply =
against
> > > mainline.
> > > [I apologize for any whitespace mangling.  I've also attached the=

> > > patch.]
> > >=20
> > > I'd like more eyeballs to tell me if this is right.  I'd also lik=
e to
> > > know who I need to talk to to get this pushed into mainline.
> >=20
> > Running the scripts/get_maintainer.pl script on your patch produces=

> >=20
> > Felipe Balbi <balbi@ti.com> (maintainer:MUSB MULTIPOINT H...)
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:USB SUBS=
YSTEM)
> > linux-usb@vger.kernel.org (open list:MUSB MULTIPOINT H...)
> > linux-kernel@vger.kernel.org (open list)
> >=20
> > Felipe Balbi (CC'ed) is the person who you should talk to.
> >=20
> > While we're touching the subject of scripts, you should run the
> > scripts/checkpatch.pl script and fix errors and warnings before sub=
mitting
> > patches. Please see Documentation/SubmittingPatches.
> >=20
> > Last (but not least) piece of advice, don't give up if you don't re=
ceive
> > replies to your patches. People are busy and mails fall to cracks f=
rom
> > time to time.
> >=20
> > Felipe, apart from the coding style violation and the possibly miss=
ing
> > locking, what's your opinion on this ? Does the patch make sense ?
>=20
> It's a duplication of the check which is already in musb_irq_work():
>=20
> 1742 static void musb_irq_work(struct work_struct *data)
> 1743 {
> 1744         struct musb *musb =3D container_of(data, struct musb, ir=
q_work);
> 1745
> 1746         if (musb->xceiv->state !=3D musb->xceiv_old_state) {
> 1747                 musb->xceiv_old_state =3D musb->xceiv->state;
> 1748                 sysfs_notify(&musb->controller->kobj, NULL, "mod=
e");
> 1749         }
> 1750 }
>=20
> That does look better, but I'd need the check inside musb_irq_work() =
to
> be removed and commit log would have to improve a bit.

OK. Adam, could you please modify the patch accordingly and resubmit it=
 ?

> ps: there's no missing locking, musb_stage0_irq() is called within
> musb_interrupt() which is called within a locked IRQ handler.

I hadn't checked that, thank you for the confirmation.

=2D-=20
Regards,

Laurent Pinchart

--nextPart3635346.O3fFlhQW1J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJTzWFgAAoJEIkPb2GL7hl1feAIAKbxp+SIZlUFDTEfzcuVCPQA
NJomq/fWwL+te4+fLZEKrGrkxYgAzn/jkJpoj1OGpTNvHDSfXZuLjpW+GOe/ZVUQ
Wb0+X27/R+rfvvrKOO3HkjHIzI9Nbmj18WWVqGgckqvTCGsyHW99+/Fii/cxC587
O0Q95PCvtewQ6XNAiV4/lOn6XEwiOF0NJMM62MRCatsFDKgSgFMesiR7/COoRzZY
XOcNQIPnMVLk1lgc25LXJit7YFH3NOcSleXDjKaX61Ic07QtFazTDDHfmco8E0Ju
D+j+Ryme3BJPRmsla5oZtfkScHCdx3i2qq9QTfCXEEb/VATKKd7m/FMRFfZ/j98=
=3Xwb
-----END PGP SIGNATURE-----

--nextPart3635346.O3fFlhQW1J--

