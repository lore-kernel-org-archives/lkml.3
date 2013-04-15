Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab3DOKFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:05:22 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:38381 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab3DOKFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:05:20 -0400
Date: Mon, 15 Apr 2013 12:05:12 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Mike Galbraith <bitbucket@online.de>
Cc: linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: 3.0.60: general protection fault: 0000, Fixing recursive fault
 but reboot is needed
Message-ID: <20130415100512.GS28496@pcnci.linuxbox.cz>
References: <20130415053336.GB1155@pcnci.linuxbox.cz>
 <1366014586.4962.17.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DvifzEOEABd5jzbd"
Content-Disposition: inline
In-Reply-To: <1366014586.4962.17.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 9562250 records (last update: 20130415)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 9562250 records (last update: 20130415)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 9562250 records (last update: 20130415)
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DvifzEOEABd5jzbd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

> Feeding that to scripts/decodecode
thanks, didn't know about that!

=2E
=2E
=2E
=2E
>=20
> That's here in dup_fd():
>         for (i =3D open_files; i !=3D 0; i--) {
>                 struct file *f =3D *old_fds++;
>                 if (f) {
>                         get_file(f);
>=20
> It's doing that get_file(), grabbing a reference to all open files in a
> loop, but old_fds points off into lala land, so I'd say you must have
> memory corruption, and open_files is garbage.  Seeing "One of our
> servers..", operative word being "one", I'd tend to suspect heat or such
> given the box exploded in this extremely heavily exercised spot.

yes, that could be. I'll have this box checked, including memtest etc.

thanks a lot for Your time!

nik


>=20
> -Mike
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--DvifzEOEABd5jzbd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlFr0NgACgkQ3xdJJrLygV7iMwCfYbzUBwX2OAeZdKIQiWIqDjBP
u9MAnR7aK6Ol9o7MogkrJBripfalkej+
=3NoV
-----END PGP SIGNATURE-----

--DvifzEOEABd5jzbd--
