Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab3CZDtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 23:49:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56846 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884Ab3CZDtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 23:49:45 -0400
Date: Tue, 26 Mar 2013 14:49:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Johan Hovold <jhovold@gmail.com>
Subject: linux-next: manual merge of the usb tree with the tty tree
Message-Id: <20130326144932.aae6ea8285bba0a98b0b6193@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Mar_2013_14_49_32_+1100_DD61SS4z.cH31.pU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Mar_2013_14_49_32_+1100_DD61SS4z.cH31.pU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/serial/usb-serial.c between commit 6aad04f21374 ("TTY: add
tty_port_tty_wakeup helper") from the tty tree and commit d12e211d4484
("USB: serial: clean up debug info") from the usb tree.

I fixed it up (I just used the version of usb_serial_port_work() from the
tty tree - see below) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/serial/usb-serial.c
index 2f60474,5eb96df..0000000
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@@ -542,11 -538,19 +538,11 @@@ static void usb_serial_port_work(struc
  {
  	struct usb_serial_port *port =3D
  		container_of(work, struct usb_serial_port, work);
 -	struct tty_struct *tty;
 =20
 -	tty =3D tty_port_tty_get(&port->port);
 -	if (!tty)
 -		return;
 -
 -	dev_dbg(tty->dev, "%s\n", __func__);
 -
 -	tty_wakeup(tty);
 -	tty_kref_put(tty);
 +	tty_port_tty_wakeup(&port->port);
  }
 =20
- static void kill_traffic(struct usb_serial_port *port)
+ static void usb_serial_port_poison_urbs(struct usb_serial_port *port)
  {
  	int i;
 =20

--Signature=_Tue__26_Mar_2013_14_49_32_+1100_DD61SS4z.cH31.pU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRURrMAAoJEECxmPOUX5FE/hAP/0kVqRaJQhoR924ZZIgyoIGf
qv3g7im/JmeaHPYA3eXDa1k15Z/tyKxeLmtNe5rGXN7QPwS7smoNs+s3Lz9b/GyY
HG2yrtHAQIXPly6t8BaK9MOdC3wxYSM/+ztxEf0t+ns0AT9xxZ8gWfSGs6smV8d+
o2cuuXtmW28veMFEk8/Y2TgPsoAZejKvrDo2c2b9OanJykCyxbIrps8H0oqyyTeC
MpcE5wSNxLLgUk4Ut7pZ8q0Wt/wtroFzxjex4jsHpqJNb1EMYqwVpmWSgynP44fB
K/zCH9yTwmzX0CGKjIMU1jFyoPNgy7Ijhuvux0ZPpAlERkIwC7Rd24udAaELRu2J
FZPQ0eBlYHDdvgwxSIbDPKRk6g9uUq2kj2+Wy+H2uRxIlkt6qE56PpkN7FeSpTAQ
yjM6+QdkHQ2T4Agu6UI37R7hPkP4BkkdTacmwLiEy7j652ZwzI7A2INjee2KTdcf
NriPdKYAbG8e3rsL3CJm26mJ22GOm4/knZHHqFzsvk4MSkCsH2nMpEo6v+yHeEmN
pMejr6KP2TycwRtQ4W8omeTR8Q+9Tjhunm8Y5yp9r6D9krv9oEGV1a81xx1tWxpA
Qh8m4Z0jDOUL+Ue1KTEi9eQDO6yjqExPUnAeoxKh0uuS0S0LKAa3hF9Fj9rhXMus
7heNLkAQJdd//7+xc56J
=4D7Q
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Mar_2013_14_49_32_+1100_DD61SS4z.cH31.pU--
