Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab3CTDMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 23:12:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34963 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab3CTDMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 23:12:22 -0400
Date: Wed, 20 Mar 2013 14:12:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20130320141211.52b44d0e202d32812c3e3c0c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Mar_2013_14_12_11_+1100_.gH8qTZJLDKsY2Yz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Mar_2013_14_12_11_+1100_.gH8qTZJLDKsY2Yz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/net/caif/caif_serial.c: In function 'update_tty_status':
drivers/net/caif/caif_serial.c:94:11: error: 'struct tty_struct' has no mem=
ber named 'warned'

Caused by commit 6865ff222cca ("TTY: do not warn about setting speed via
SPD_*").

drivers/usb/serial/quatech2.c: In function 'qt2_process_read_urb':
drivers/usb/serial/quatech2.c:661:18: error: 'struct qt2_port_private' has =
no member named 'is_open'
drivers/usb/serial/quatech2.c:705:15: error: 'struct qt2_port_private' has =
no member named 'is_open'

Caused by commit e4408ce3c23f ("TTY: quatech2, remove unneeded
is_open").  grep is your friend (or searching while editting the file).

I have used the tty tree from next-20130319 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Mar_2013_14_12_11_+1100_.gH8qTZJLDKsY2Yz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSSkLAAoJEECxmPOUX5FEQ88P+wZdrxcJGsRbm8jXuLqHWuuq
/3yQPMQ+bZ5s3pBJj51ijGjMPDU0+Asnfq9+Ae7EPDg/Mhnj+b9EdYOTtkngqWD2
3yCLMoGsTeYU5h2bcKLdLmyZTTkXtD9qxu3asPFJmgzYdGfSJgK7AFxD9TtIDgMD
ohTKeqhkDk6MKA0257mhIieHpgYzVPceo9wguMkZaRNrMv5HVpmRyhKQYeiVsPI2
GkruI/jomATVtS1QS3WGRTK5CeyDh7mctheqkrYjmGBntD7Yu6hJzP1StcANLqIB
YF8xMNmcl9Ez6cIcGiDoR0E+CuJYoWIN1i/gzkjyJmhJ6NoCYS/LrnMGpG/27sVH
hzfP6zjfo/vQdmqIlgZn/ma/10P58weN86hzLRYQ+Yqqn6CZt1bZkpIlYF2if2IT
jLkQJI8p9/iEo66XX8/bpfBd7ACWPt+H2SYSwhA6VlpbIFK0g5CE7w9djVab0/GG
nsKLdTHc8LMH5anFkTWpnjWoDz/cCoWm70GYKqJ44nUucQUgp7yiMDN4iQqnJz0H
Xr0T0qJ+G2bdPImkQ6CeqC9/3Odlobg/YgjuOyVbxfsG0el9L+JLLNXWsPGFv3RB
gjdSGtOiS0fUP9dAkNI0rF7fRj9tTGsw0pIBiePS2dWoanNHMKSpC/gG3DiWBTPp
Er3nko/PyPooKsezzwyX
=FUdZ
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Mar_2013_14_12_11_+1100_.gH8qTZJLDKsY2Yz--
