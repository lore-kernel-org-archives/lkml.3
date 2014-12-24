Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaLXScc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 13:32:32 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:58938 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaLXScb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 13:32:31 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Johan Hedberg <johan.hedberg@gmail.com>
Subject: Re: 3.19-rc1 refuse connection from bluetooth headset
Date: Wed, 24 Dec 2014 19:32:27 +0100
User-Agent: KMail/1.13.7 (Linux/3.19.0-031900rc1-generic; KDE/4.14.2; x86_64; ; )
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201412241815.12922@pali> <20141224173652.GA16667@t440s.P-661HNU-DI-F1>
In-Reply-To: <20141224173652.GA16667@t440s.P-661HNU-DI-F1>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1605061.G2Ycz2iDWt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412241932.27264@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1605061.G2Ycz2iDWt
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 24 December 2014 18:36:52 Johan Hedberg wrote:
> Hi Pali,
>=20
> On Wed, Dec 24, 2014, Pali Roh=C3=A1r wrote:
> > now I installed 3.19-rc1 kernel and my bluetooth headset was
> > refused to connect automatically. I need to start
> > connection manually from laptop (and then it working).
> > Before when I started bluetooth headset it automatically
> > connected and I did not have to do anything. Now with
> > 3.19-rc1 kernel I need to do connection manually and I see
> > error
> >=20
> > messages in hcidump:
> >  $ sudo hcidump
> >  HCI sniffer - Bluetooth packet analyzer ver 2.2
> >  device: hci0 snap_len: 1028 filter: 0xffffffffffffffff
> > =20
> >  > HCI Event: Connect Request (0x04) plen 10
> >  >=20
> >      bdaddr <HEADSET_ADDRESS> class 0x240404 type ACL
> > =20
> >  < HCI Command: Reject Connection Request (0x01|0x000a) plen
> >  7
> > =20
> >      bdaddr <HEADSET_ADDRESS> reason 0x0f
> >      Reason: Connection Rejected due to Unacceptable BD_ADDR
> >  >=20
> >  > HCI Event: Command Status (0x0f) plen 4
> >  >=20
> >      Reject Connection Request (0x01|0x000a) status 0x00
> >      ncmd 1
> >  >=20
> >  > HCI Event: Connect Complete (0x03) plen 11
> >  >=20
> >      status 0x0f handle 34 bdaddr <HEADSET_ADDRESS> type ACL
> >      encrypt 0x00 Error: Connection Rejected due to
> >      Unacceptable BD_ADDR
> >  >=20
> >  > HCI Event: Connect Request (0x04) plen 10
> >  >=20
> >      bdaddr <HEADSET_ADDRESS> class 0x240404 type ACL
> > =20
> >  < HCI Command: Reject Connection Request (0x01|0x000a) plen
> >  7
> > =20
> >      bdaddr <HEADSET_ADDRESS> reason 0x0f
> >      Reason: Connection Rejected due to Unacceptable BD_ADDR
> >  >=20
> >  > HCI Event: Command Status (0x0f) plen 4
> >  >=20
> >      Reject Connection Request (0x01|0x000a) status 0x00
> >      ncmd 1
> >  >=20
> >  > HCI Event: Connect Complete (0x03) plen 11
> >  >=20
> >     status 0x0f handle 35 bdaddr <HEADSET_ADDRESS> type ACL
> >     encrypt 0x00 Error: Connection Rejected due to
> >     Unacceptable BD_ADDR
> >=20
> > (real address of my bluetooth headset was replaced by
> > <HEADSET_ADDRESS>)
> >=20
> > Can you inspect why new kernel refuse connection from my
> > bluetooth headset?
> >=20
> > I'm still using bluez 4.98 (which is in Ubuntu 12.04), I did
> > not do any update.
>=20
> Could you try the attached patch? I think the reason might be
> the dependence on the HCI_CONNECTABLE flag that's only set if
> the page scan was enabled through mgmt (which wouldn't be the
> case with BlueZ 4.98).
>=20
> Johan

Hi Johan! Thanks for quick reply. Your patch fixes my problem and=20
auto-connection of my bluetooth headset is working again. Will=20
you forward patch to mainline kernel?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1605061.G2Ycz2iDWt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSbBrsACgkQi/DJPQPkQ1KRwACfSt2jyErhH+7AT6diz5LVURdd
A6QAmwT9kdhqtEJKv9H2YSgui7bxfSqD
=NQGz
-----END PGP SIGNATURE-----

--nextPart1605061.G2Ycz2iDWt--
