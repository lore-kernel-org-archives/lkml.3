Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab3A1Joj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:44:39 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33998 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab3A1Jof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:44:35 -0500
Date: Mon, 28 Jan 2013 20:44:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Millenbach <jmillenbach@gmail.com>,
        Brian Swetland <swetland@google.com>,
        "Mike A. Chan" <mikechan@google.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Yunhong Jiang <yunhong.jiang@intel.com>,
        Xiaohui Xin <xiaohui.xin@intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Bruce Beare <bruce.j.beare@intel.com>,
        Tom Keel <thomas.keel@intel.com>, Alan Cox <alan@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: manual merge of the tty tree with the input tree
Message-Id: <20130128204424.a3eedfee954ba6cc7a620652@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Jan_2013_20_44_24_+1100_oy2CEh2bUFU=nuwa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Jan_2013_20_44_24_+1100_oy2CEh2bUFU=nuwa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/input/keyboard/Kconfig between commit 6f2ac009f29b ("Input:
goldfish - virtual input event driver") from the input tree and commit
4f73bc4dd3e8 ("tty: Added a CONFIG_TTY option to allow removal of TTY")
from the tty tree.

I fixed it up (see below - I am not sure if GOLDFISH_EVENTS needs TTY or
not) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/keyboard/Kconfig
index 078305e,008f96a..0000000
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@@ -479,16 -482,8 +482,18 @@@ config KEYBOARD_SAMSUN
  	  To compile this driver as a module, choose M here: the
  	  module will be called samsung-keypad.
 =20
+ if TTY
+=20
 +config KEYBOARD_GOLDFISH_EVENTS
 +	depends on GOLDFISH
 +	tristate "Generic Input Event device for Goldfish"
 +	help
 +	  Say Y here to get an input event device for the Goldfish virtual
 +	  device emulator.
 +
 +	  To compile this driver as a module, choose M here: the
 +	  module will be called goldfish-events.
 +
  config KEYBOARD_STOWAWAY
  	tristate "Stowaway keyboard"
  	select SERIO

--Signature=_Mon__28_Jan_2013_20_44_24_+1100_oy2CEh2bUFU=nuwa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRBkh4AAoJEECxmPOUX5FEuUgP/3uvpH02Oas5Up0yzaC39b5T
8IQjkpoHap1sDm+JWdwm4gPEQuG4rgGloBb/AxQugKE0NueOFOzqrMkv1WoAamcP
cLOVwsSpaHvCNvHdy2PS1Gs/iTIkdqUzeykrM4wGGKrsFvo5RazMc7Zeb4bd6vj+
Q3EoEMFg4YRM+tzQYTRFHLak7b/yLnw23eTIljeY9/v87SJfIEkTISsH+VHTdclc
dDUDAO5WtVTmLw0Z9mbxf/kbov5HOZbFWSc/93W7z5zXLIkWRaL6ehGRZ3uwbx+K
HDNWygHLkKLkR3VKgNgRn634/pGSJn2Uu8FD17+JbRTdbE2zKaFDi8RnE/Z1bzh8
pQZrTmXHH1WbPx+2fB98M1Ah6mVYCowEWQF6/LzG+Xwl7ktrCZ3WRoOdZsaGDy4v
kM3ZEKJkPyEAInZl5fGLwMjF5PSJzblDMOzRrQ8788E6VPaUVpiaLfyEuHr1G0uj
oi6bR0Z+C7tkIY7YxVk6alFE3BI/VuvCHyxQqOSfsbC5w1m6IyvLzNBsf8gVtjxF
AterTEfzr6XQ0wvCItMh4zhXnGBEmFlpzcG9fyTASFnnmLFM/WcEcKxGud5YLQrV
NbQD/hW4+8Li/O1/1cOeITw59VbL9WOvk4xouJitin/jySgwO1Rm1GzjPyYjJRQ6
phj4L2PPOO5XA5Y4FqT2
=3pft
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Jan_2013_20_44_24_+1100_oy2CEh2bUFU=nuwa--
