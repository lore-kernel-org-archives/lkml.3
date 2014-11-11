Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaKKCM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 21:12:27 -0500
Received: from ozlabs.org ([103.22.144.67]:56229 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaKKCMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 21:12:24 -0500
Date: Tue, 11 Nov 2014 13:12:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>
Subject: linux-next: build failure after merge of the block tree
Message-ID: <20141111131216.3742d156@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/L.YyEyKKm3UkHSwFgiv2tvb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/L.YyEyKKm3UkHSwFgiv2tvb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/built-in.o: In function `cdrom_sysctl_handler':
cdrom_sysctl.c:(.text+0x156d92): undefined reference to `cdrom_mutex'
cdrom_sysctl.c:(.text+0x156da0): undefined reference to `cdrom_autoclose'
cdrom_sysctl.c:(.text+0x156dae): undefined reference to `cdrom_autoeject'
cdrom_sysctl.c:(.text+0x156dbc): undefined reference to `cdrom_debug'
cdrom_sysctl.c:(.text+0x156dca): undefined reference to `cdrom_lockdoor'
cdrom_sysctl.c:(.text+0x156dd8): undefined reference to `cdrom_check_media_=
type'
cdrom_sysctl.c:(.text+0x156e0b): undefined reference to `cdrom_list'
cdrom_sysctl.c:(.text+0x156e37): undefined reference to `cdrom_autoclose'
cdrom_sysctl.c:(.text+0x156e57): undefined reference to `cdrom_autoeject'
cdrom_sysctl.c:(.text+0x156e77): undefined reference to `cdrom_check_media_=
type'
cdrom_sysctl.c:(.text+0x156ea4): undefined reference to `cdrom_lockdoor'
cdrom_sysctl.c:(.text+0x156eb5): undefined reference to `cdrom_list'
cdrom_sysctl.c:(.text+0x15702e): undefined reference to `cdrom_mutex'
drivers/built-in.o: In function `cdrom_print_info.constprop.0':
cdrom_sysctl.c:(.text+0x1570f3): undefined reference to `cdrom_list'
cdrom_sysctl.c:(.text+0x157189): undefined reference to `cdrom_list'
drivers/built-in.o: In function `cdrom_sysctl_info':
cdrom_sysctl.c:(.text+0x1572c3): undefined reference to `cdrom_mutex'
cdrom_sysctl.c:(.text+0x1576dc): undefined reference to `cdrom_mutex'
drivers/built-in.o: In function `cdrom_sysctl_register':
(.text+0x157765): undefined reference to `cdrom_autoclose'
drivers/built-in.o: In function `cdrom_sysctl_register':
(.text+0x157781): undefined reference to `cdrom_autoeject'
drivers/built-in.o: In function `cdrom_sysctl_register':
(.text+0x15778e): undefined reference to `cdrom_debug'
drivers/built-in.o: In function `cdrom_sysctl_register':
(.text+0x15779b): undefined reference to `cdrom_lockdoor'
drivers/built-in.o: In function `cdrom_sysctl_register':
(.text+0x1577a8): undefined reference to `cdrom_check_media_type'

Probably caused by commit d01681d1457c ("cdrom: export sysctl code").
This build has CONFIG_SYSCTL=3Dy, CONFIG_BLK_DEV_IDECD=3Dm,
CONFIG_BLK_DEV_SR=3Dm, CONFIG_PARIDE_PCD=3Dm, CONFIG_CDROM_PKTCDVD=3Dm,
CONFIG_GDROM=3Dn.

I have used the block tree from next-20141110 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/L.YyEyKKm3UkHSwFgiv2tvb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYXCEAAoJEMDTa8Ir7ZwVtUQQAJNYcMamEpXrKpk5VaDkx/3j
aZp0Uv/6xHdMgEDjj28pX9ArK6NsTppv/AfbLTh9CgpZjTRWWMmkUc4bJOi/fwjk
MWU9HGTUcrSreNeUo/JIvAV5oY6Po/dyvQzIVFxRGlTSCVMLEXDojhdRvwP9SEkj
IN5eOKGwAv7IEnfLgTf96HXZ95IYX1kxXXUlwdN1ibS0jOWnajjxMlJf/kysq6wN
6cmMhle8jj7Fxh3ittWTH34rhcodjV7oRCjwMzQxoIIUcYI6Apd7n14EWR5Dc5ZZ
vt5fZgj+oinNduyFxXZbq7jP+Lw794ttNXfryQtZpkvrwjox7WlXKY9SRInz9Xjy
PrHZCoq6/S9XZfSvoLlbkgdwCw3onApmi/RUoIKFBGasNGP4RXfF/CxTZCSVHOCr
UWM9cTkc6kY00tyGBGt47Nd4Wk2bUZ8TXQvVr1sZTB2cYyKod5wsaQZr7zwd65NT
ROGFA1Lj+V+yjvkiGIUM5Lu6E624wy33qFCcyU+DykUuBCxLQDxVhV+EXiqfLgMk
nL0AtgsEc6oOXlAMsqII9SImqw2vqPbRKPQnIGqx3HQXfFU0qXt/+IuNzLVc8oL3
3SbMrGFB9G4LR5gr7Evxc/UDN4enL9rSgjT5RfR/4MsyAyMmUJgNolEGb6fI3coA
zDUEznC/uj6IVQRw0sMY
=XwRd
-----END PGP SIGNATURE-----

--Sig_/L.YyEyKKm3UkHSwFgiv2tvb--
