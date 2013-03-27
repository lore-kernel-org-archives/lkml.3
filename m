Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3C0Dlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:41:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37335 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3C0Dlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:41:44 -0400
Date: Wed, 27 Mar 2013 14:41:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Ming Lei <tom.leiming@gmail.com>
Subject: linux-next: build failure after merge of the usb tree
Message-Id: <20130327144134.0809a21c09b45d20a1fe480d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Mar_2013_14_41_34_+1100_xZ_zhF_/G=kd+CRI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Mar_2013_14_41_34_+1100_xZ_zhF_/G=kd+CRI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/usb/serial/usb-serial.c: In function 'usb_serial_probe':
drivers/usb/serial/usb-serial.c:887:3: error: 'struct usb_serial_port' has =
no member named 'delta_msr_wait'

Caused by commit eba0e3c3a0ba ("USB: serial: fix hang when opening port")
fro the usb.current tree interacting with commit 53ab34dc50ad ("USB:
serial: remove unused MSR-wait queue") from the usb tree.

I have reverted the commit from usb.current on the assumption that the
problem it solves has been, or will be, solved some other way.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__27_Mar_2013_14_41_34_+1100_xZ_zhF_/G=kd+CRI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUmpuAAoJEECxmPOUX5FElO0P/0CAydS0l27dBDEXb/AE1WnG
QeXCQEFlrJuX1c+J6SoPcGI/9GlcSheACXcHXxw1wIQ/s4JSsIadzFPhdAnWI5UO
KMDbiOKZlEmx+DHjOXamc7O93RgpDtZ6J3EWhdT257lwlcG85Q40jNNpWONIYpoc
o+wNAJqPKyWmiQCfmg4Nr3Qf+D/CMVv5HL1qbD59R61DPLAPnKiMZaflfW/Jfkw7
RgCnQ8j4zLOoUJSZJiMg731ijvu7EEG3fRCCqRuHPxNwN+g9V+THOZfeaO+Yov8w
gY6EgL82GOagvuZrQzEQa2Ra/qei0SQ5F6aQ1ksF30sNfUltdtYHlsfjyzl+plhI
ivesTtE6EIbiztMp9glvSyQQCG7pRZKUy2WoD4Zh23JeGOTU6Pdf0SrRkDEgftKd
Pz1O/1CGIVE7V00Y4PkEoatyM3epNH82wNwBuco8EbtV5x0gRH+mq7DbUFAlJqK2
Ub/Pa+QhJgopCgIzk8Yer/VOSy6KRRZNNeqaeuwfgGWTkpcRl1OQhI3h6mUO+H1w
Y9iHKoYXghTAEY4FIKHiWVXsTYAaCcBXhLgFhf0dZyZPlZOXofqh7FxzcqS/cSvs
SbJQ3C5zaALXjjCSzBZQHnGAkPEqCnz6vmp+NVx3n+KoWxjjS7KP5DoSrQDRLuwX
oas7EOBwOQb+vHM0+XGV
=fahz
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Mar_2013_14_41_34_+1100_xZ_zhF_/G=kd+CRI--
