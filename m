Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab3BRDTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 22:19:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47642 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756630Ab3BRDTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 22:19:06 -0500
Message-ID: <1361157535.5374.539.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] Bluetooth: btmrvl_sdio: look for sd8688 firmware in
 alternate place
From: Ben Hutchings <ben@decadent.org.uk>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        David Woodhouse <dwmw2@infradead.org>, Bing Zhao <bzhao@marvell.com>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 18 Feb 2013 03:18:55 +0000
In-Reply-To: <1359285711.2156.4.camel@unicorn>
References: <1357689361-7969-1-git-send-email-lkundrak@v3.sk>
	 <1357689361-7969-2-git-send-email-lkundrak@v3.sk>
	 <1357698538.1806.43.camel@aeonflux>
	 <477F20668A386D41ADCC57781B1F70430D13FDB783@SC-VEXCH1.marvell.com>
	 <1357713088.1105.1.camel@unicorn>  <1357713345.1806.44.camel@aeonflux>
	 <1358494422.28503.4.camel@unicorn>
	 <1358730733.24121.228.camel@deadeye.wl.decadent.org.uk>
	 <1359285711.2156.4.camel@unicorn>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-y5gnrIX9KK5luOxlkE5l"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-y5gnrIX9KK5luOxlkE5l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-01-27 at 12:21 +0100, Lubomir Rintel wrote:
> On Mon, 2013-01-21 at 01:12 +0000, Ben Hutchings wrote:
> > On Fri, 2013-01-18 at 08:33 +0100, Lubomir Rintel wrote:
> > > On Tue, 2013-01-08 at 22:35 -0800, Marcel Holtmann wrote:
> > > > Hi Lubomir,
> > > >=20
> > > > > > > > linux-firmware ships the sd8688* firmware images that are s=
hared with
> > > > > > > > libertas_sdio WiFi driver under libertas/. libertas_sdio lo=
oks in both places
> > > > > > > > and so should we.
> > > > > > > >
> > > > > > > > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > > > > > > > ---
> > > > > > > >  drivers/bluetooth/btmrvl_sdio.c |   24 +++++++++++++++++++=
+++--
> > > > > > > >  drivers/bluetooth/btmrvl_sdio.h |    6 ++++--
> > > > > > > >  2 files changed, 26 insertions(+), 4 deletions(-)
> > > > > > >=20
> > > > > > > NAK from me on this one. I do not want the driver to check tw=
o
> > > > > > > locations. That is what userspace can work around.
> > > > > > >=20
> > > > > > > If we want to unify the location between the WiFi driver and =
the
> > > > > > > Bluetooth driver, I am fine with that, but seriously, just pi=
ck one over
> > > > > > > the other. I do not care which one.
> > > > > >=20
> > > > > > The unified location is mrvl/ directory.
> > > > > >=20
> > > > > > We can probably move SD8688 firmware & helper binaries to mrvl/=
 and have both drivers grab the images there?
> > > > >=20
> > > > > That would break existing setups, wouldn't it?
> > > > >=20
> > > > > I was under impression (commit 3d32a58b) that we care about
> > > > > compatibility here. Do we?
> > > >=20
> > > > that is what symlinks are for.
> > >=20
> > > David, Ben: please pull the following branch then:
> > > git pull git://github.com/lkundrak/linux-firmware.git sd8688-move
> > >=20
> > > Thank you!
> >=20
> > The symlinks are broken, and you didn't update WHENCE.
>=20
> Oops, sorry for that. Fixed now, please pull:
> git pull git://github.com/lkundrak/linux-firmware.git sd8688-move
>=20
> Thank you!

Pulled and will be pushed out shortly.  Sorry for the delay.

Ben.

--=20
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.

--=-y5gnrIX9KK5luOxlkE5l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUSGdn+e/yOyVhhEJAQpptQ/+PAVYWA1CFnDxDlh2idm83nGKW6IhD7GT
xFxpUve17r3IMPblKkbRXKG7jOYyidnwWmJzVgFGiHnPwWvi5OJXEXOAilO/1Mn0
4jNMIHVtlAD7KNsdYxfnuDq2ufoiMfWbVeKJj/7bycsBgjNwo7hz7aT8xOXXKz+c
2aeXzloJ5D3OUGlg652sgiOK2Rw3ZkIXJK/5aLAnzgW/neJQQPjftp/VtVrT8hH/
uHmDG35s6WyfzPtSm2uCqb9p9TYeFHS+7r/ZzuPGgsYei/wi/sh4+URYycOU8Jnx
c2TcwFqIllwXFrm5jwYenvmol5P75/7w790+BLT+yoeXEht+TnxuAyVSnBctCYqe
Q3fwbgYAoCgcl0Uso3u4FxYlQhe4UTFt/nG4A8WS29sW+DNSNj8pg2IgWCzTk4rq
zXnY840ZUgbAMsqOB3qG77JrGHVGldc7w0qQ/LJ8q8rRcs7ahqAVK/e84wtzIJ+3
DYJgSB/rF7a+stLP3qBPNlohJ1YDuv03LrO6LDbhtyzFlHt8WAD/hZfvZaq8j5k7
L13fpox77kiZIczjFnnlo8p4+0CH8/dcxK4/GaBSrh8AwvaFFVNzf0b5XhLMOeD4
NBc/baxeqbJYuphDqx0rHTTxUf4zqA7e438AW6So2ZSroWAxADcVRqIBcrYjUgh4
yl6GB3sN1Ag=
=ps9L
-----END PGP SIGNATURE-----

--=-y5gnrIX9KK5luOxlkE5l--
