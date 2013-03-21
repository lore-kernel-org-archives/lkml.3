Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3CUEUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 00:20:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49870 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3CUEUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 00:20:15 -0400
Date: Thu, 21 Mar 2013 15:20:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: linux-next: build failure after merge of the tty tree
Message-Id: <20130321152004.27ac4f29e9b6caae7beb3bdb@canb.auug.org.au>
In-Reply-To: <20130320141211.52b44d0e202d32812c3e3c0c@canb.auug.org.au>
References: <20130320141211.52b44d0e202d32812c3e3c0c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Mar_2013_15_20_04_+1100_EllBpOCoKh2GmjXM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Mar_2013_15_20_04_+1100_EllBpOCoKh2GmjXM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 20 Mar 2013 14:12:11 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>=20
> drivers/net/caif/caif_serial.c: In function 'update_tty_status':
> drivers/net/caif/caif_serial.c:94:11: error: 'struct tty_struct' has no m=
ember named 'warned'
>=20
> Caused by commit 6865ff222cca ("TTY: do not warn about setting speed via
> SPD_*").

I still have this error today so have still used the tty tree from
next-20130319.

> drivers/usb/serial/quatech2.c: In function 'qt2_process_read_urb':
> drivers/usb/serial/quatech2.c:661:18: error: 'struct qt2_port_private' ha=
s no member named 'is_open'
> drivers/usb/serial/quatech2.c:705:15: error: 'struct qt2_port_private' ha=
s no member named 'is_open'
>=20
> Caused by commit e4408ce3c23f ("TTY: quatech2, remove unneeded
> is_open").  grep is your friend (or searching while editting the file).

As has been reported, this one is fixed by reverting commit 27b351c "USB:
quatech2: only write to the tty if the port is open".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Mar_2013_15_20_04_+1100_EllBpOCoKh2GmjXM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSop0AAoJEECxmPOUX5FEQG4QAKokh4hiPEHZ0HP3nHbhtM34
FZUqZFspq2oW6CwcYLbAVPeGLqmHlyGKovXZ5cSlriUYnVnBjV1hBxSIJoSa3GXO
8cO+xupOU/ISP/HwKurh0RnT9zPLJioD+Pjd+6AyCTuivaj0KSAyJeJVCBO4mt12
Kmv/kQF/DasxRw2w3AsdkiqM1U4XN9XzhGnB2Ek9ebuOT3Vkr8EBki7perAWzNh1
q4s/cUVPhOzOZOHzuPBCmTRF4YFFL0SpqyUCcwuvQCiXU4Y8F/szgqxRht69lu+7
nokkWE4fUyx6PAuijOkb8za45NaYbUiGsIMltzAloluofyA95neOeqzhQv8fCSPb
/dzepYMBuKh9cGZ5S59aZGJM0TDMvJXY8T5naQLkfxhVCugT6Nm28BZZjGoUwFfN
GJtCGRisQeRJFJafvpkV7EBpqxO+s5UNlJtgZpe+lrQKw2ExbEjSqdzZ8VTyGiA4
w62egQgkKTKozDw3nO/yYG3g4POhuQGjMr4PPoXvda2JG3ns2KoCIVMoeNLscqps
JX1pAzzUkS9Wk0qzZHD6949tnBcWFjkm0XC3RfzQWow1Q2JKh9zwPaVCoLcJsyHc
CQkwB5g4EJha/tdTH8vqBgVJomWPPch+zPEJPu9x1ykIcKOCI7YgcjVS4pA8qE+a
4H49qlUXYPBWg0++nq81
=B0Us
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Mar_2013_15_20_04_+1100_EllBpOCoKh2GmjXM--
