Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaGDKVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:21:55 -0400
Received: from flan.grepular.com ([198.211.125.252]:39373 "EHLO
	flan.grepular.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaGDKVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:21:54 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jul 2014 06:21:54 EDT
Date: Fri, 4 Jul 2014 11:13:11 +0100
From: Mike Cardwell <linux@lists.grepular.com>
To: linux-kernel@vger.kernel.org
Subject: Procfs race condition bug
Message-ID: <20140704101311.GA7020@glue.grepular.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I originally posted this two years ago (*) but received no response. I
just had a look and the problem still exists on the 3.14 kernel I am
currently running.

I *think* I've uncovered a race condition bug in procfs. If I attempt to
open a file in /proc/net, eg "/proc/net/tcp" it works fine, but if I
spawn a POSIX thread and attempt to do it from there, it *usually* fails
with a "No such file or directory", but some times succeeds. If I do a
system call inside the thread to look up the thread ID and then open
"/proc/THREADID/net/tcp" instead, it works fine.

There are more details and some example code so you can replicate the
problem on a stack overflow question I asked previously here:
http://stackoverflow.com/questions/11580020/opening-proc-net-tcp-in-c-from-=
a-posix-thread-fails-most-of-the-time

(*) https://lkml.org/lkml/2012/7/20/331

--=20
Mike Cardwell  https://grepular.com https://emailprivacytester.com
OpenPGP Key    35BC AF1D 3AA2 1F84 3DC3   B0CF 70A5 F512 0018 461F
XMPP OTR Key   8924 B06A 7917 AAF3 DBB1   BF1B 295C 3C78 3EF1 46B4

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQGGBAEBCgBwBQJTtn43MBSAAAAAACAAB3ByZWZlcnJlZC1lbWFpbC1lbmNvZGlu
Z0BwZ3AuY29tcGdwbWltZTgUgAAAAAAVABpwa2EtYWRkcmVzc0BnbnVwZy5vcmdt
aWtlLmNhcmR3ZWxsQGdyZXB1bGFyLmNvbQAKCRCdJiMBwdHnBIL+B/47CLWPEBvS
2IWOQHsDP/GiJPelQ4A+u4YiHqXo5Q/RqwJFtxHxnJyZF/NjELSrcmChNcVN5Hi6
DpZSB0cQUUPKnfdzwx00r5AC6wm7RViajbScNq9sKaDd0+h8qVLTLEPviLlyWIzH
e9x25+XVSKRnoaXMNn1tsa8ZE9af9yJM2fzeX3DsfXx19Gmtgv4zvndcJ/TYHUeh
NBJ06AMpE1qLG7aqH0SHRIZGPcJaisL0zIyxsY8YkZqq5OXHgZsxP3bYY6MrhfHk
gXOZsfpTeVxLSKSSi9TgXY/MoMSZhGLxz429H+z/RpMY9KQuHZP2gIpM/wIFMeVW
70DHmDeId2aQ
=E37u
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
