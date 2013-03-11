Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3CKPMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:12:06 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:46061 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3CKPME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:12:04 -0400
X-Greylist: delayed 1462 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Mar 2013 11:12:04 EDT
Date: Mon, 11 Mar 2013 15:47:37 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel mlist <linux-kernel@vger.kernel.org>
Subject: in.tftpd - ulimit -u not working? cgroups?
Message-ID: <20130311144737.GA7024@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 9314994 records (last update: 20130303)
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello everybody,

on one of our boxes, I'm encountering strange problem from
time to time.. in.tftpd processes are forking up to thousand of
processes, getting server to almost unresponsive state.

I've tried various approaches to limiting tftp daemon but to no
avail..

what puzzles me most is, that it seems to breach even ulimit -u setting.

I'm starting in.tftpd from initscript (so no xinetd), prior to starting it,=
 ulimit -n 50
is run.

I can see limit set up correctly for master process:

grep processes /proc/XXX/limits:
Max processes             50                   50                   process=
es

but again, few days ago, problem occured again, according to atop records, =
thousands
of in.tftpd processes got forked..

Any idea on what could I be doing wrong?

I also tried limiting memory using cgroups, but even with limit of 2MB, it =
can spawn
much more processes than I'd like, and 1MB is too low... Is it possible to =
limit
number of processes using cgroups? but I still think ulimit should be enoug=
h, but
what am I doing wrong here?

thanks a lot for any clues in advance, I'm really becoming desperate...

BR

nik

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

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlE97okACgkQ3xdJJrLygV7dfwCdHDk4vGc+YYmq1BO/c+v26A6T
4psAn0+/94L2S4Kyi3w/yIXmkRhwfT4z
=UtSk
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
