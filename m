Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbaHFS2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:28:09 -0400
Received: from omr1.cc.vt.edu ([198.82.141.52]:38494 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628AbaHFS2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:28:07 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Nick Krause <xerofoiffy@gmail.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org (open list:SPI SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 1/1] spi: Remove unused definitions
In-Reply-To: Your message of "Wed, 06 Aug 2014 13:53:17 -0400."
             <1407347597-2168-1-git-send-email-xerofoiffy@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1407347597-2168-1-git-send-email-xerofoiffy@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1407349640_2381P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 06 Aug 2014 14:27:20 -0400
Message-ID: <17153.1407349640@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1407349640_2381P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <17141.1407349640.1@turing-police.cc.vt.edu>
Content-Transfer-Encoding: quoted-printable

On Wed, 06 Aug 2014 13:53:17 -0400, Nick Krause said:
> Remove unused definition which cause the following warnings
> =

> drivers/spi/spi-omap-100k.c:73:0: warning: "WRITE" redefined [enabled by=
 default]
> include/linux/fs.h:193:0: note: this is the location of the previous def=
inition
> drivers/spi/spi-omap-100k.c:74:0: warning: "READ" redefined [enabled by =
default]
> include/linux/fs.h:192:0: note: this is the location of the previous def=
inition

> -#define WRITE 0
> -#define READ  1

NAK.  Full stop.  These are potentially used in an inner macro someplace, =
and by
removing these, the conflicting values from fs.h will be used instead.

#define READ                    0
#define WRITE                   RW_MASK

So if there *is* a use in an inner macro, you just screwed the pooch
and introduced a bug in this "clean up" - somebody will be expecting to se=
e
a 0 for a READ, and will receive a 1 instead.  This can't end well.

Nick - how *exactly* did you identify that these are in fact not used?
Given your history of submitting poorly researched patches, you're going t=
o
have to justify the "unused" better than the handwaving you've done here.

--==_Exmh_1407349640_2381P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU+JziAdmEQWDXROgAQIYrRAApfcA5BtiehUUlRTxVshRPQc+CGfZeKo6
Ua7iA/biWJ+4zmNvJ/wkNF6k6tRSFS55dmj0xKoMjlJjmiziTCSKQbfkIa7YgACO
P37JbPP78NcxF/uDMs67tI58yEkIKVJ2iHnWW9FJJnRAE+CZcr+Qp0EQ0Z4w6VJz
LLS8J8Y7Tbf2uAXIJrZf4gxp6c/rz8Mxtw/AR8YA2gszO+nbdeyTICSfZJ1OhZXQ
y2/RDzRKshbFpVQyo11fUOgER1nEmeZkmRZ1KgnZKZc02gDBpWj+Qj6egWbMRaPj
jHw9QfiVUriUJG5wnk9mR08tAUwZ3Qa8oAy2eXZvMB8BKWNizGUYazfspECzvwws
8Wn8AYhtaAWl3sqVZF1MZGCGMqjS6wOaKu4kG2r/wAQA1fIZtCCCgq88ZCdSx6NI
XOP6WAmHqkxJrR8fYfTnN0ycwmL4X5X9JWmzz9bXuXjCDGWSB8j7KjFU/0bG+J4a
qNiZXTqcSDrZtc2cqIRUB3YYLJ0l0XvEy2KEGBexyRBEdMrMmkxlXb0rBg4qU4jL
eGFF7Bq7e5sdlUkWNpBorMm5SC8r2syPpHauliXQBvk+xnxfvQxU5vNn3v/9kSJW
Z0+l9rRv+pCa7GOOIb92wOWoEG8xtxqznYKfl9zHY9CxF5lYkbd0R4QBpWXY753j
JBMeCjqOUgQ=
=FfCs
-----END PGP SIGNATURE-----

--==_Exmh_1407349640_2381P--
