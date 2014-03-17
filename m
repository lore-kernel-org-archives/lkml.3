Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbaCQHe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:34:28 -0400
Received: from ozlabs.org ([203.10.76.45]:52070 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbaCQHe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:34:26 -0400
Date: Mon, 17 Mar 2014 18:34:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Magnus Damm <damm@opensource.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Wolfram Sang <wsa@sang-engineering.com>
Subject: linux-next: manual merge of the usb tree with the tip tree
Message-Id: <20140317183419.f0ac20789cdfca0ad7d93c48@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_18_34_19_+1100_0cS6guq+B+fau7+o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_18_34_19_+1100_0cS6guq+B+fau7+o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/sh/Kconfig between commit fbfa893458ed ("sh: Remove Kconfig entries
for TMU, CMT and MTU2") from the tip tree and commit f6723b569a67 ("usb:
host: remove selects of USB_ARCH_HAS_?HCI") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/sh/Kconfig
index dfb1fbf38e44,64455daa63a1..000000000000
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@@ -346,9 -354,8 +346,8 @@@ config CPU_SUBTYPE_SH772
  	bool "Support SH7720 processor"
  	select CPU_SH3
  	select CPU_HAS_DSP
 -	select SYS_SUPPORTS_CMT
 +	select SYS_SUPPORTS_SH_CMT
  	select ARCH_WANT_OPTIONAL_GPIOLIB
- 	select USB_ARCH_HAS_OHCI
  	select USB_OHCI_SH if USB_OHCI_HCD
  	select PINCTRL
  	help
@@@ -358,8 -365,7 +357,7 @@@ config CPU_SUBTYPE_SH772
  	bool "Support SH7721 processor"
  	select CPU_SH3
  	select CPU_HAS_DSP
 -	select SYS_SUPPORTS_CMT
 +	select SYS_SUPPORTS_SH_CMT
- 	select USB_ARCH_HAS_OHCI
  	select USB_OHCI_SH if USB_OHCI_HCD
  	help
  	  Select SH7721 if you have a SH3-DSP SH7721 CPU.

--Signature=_Mon__17_Mar_2014_18_34_19_+1100_0cS6guq+B+fau7+o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJqV/AAoJEMDTa8Ir7ZwV1qIP/1ZUkfE/FBRJ1qoh6X+KmXIZ
F0PQVKOmaf2Fc+EyPDyCVWEQocsqSwdPu9eqWX2yMZyInQdE8KnqaM8GlWNk/y6j
rfdku1nmkH/L8yN41HJ4Yt1AKe9Prq9PB5sS+KfVbx+pF7N3t+75AiK+tUuseew0
cmjId6VGSLnOeX3Vrf7LZ15iNiWVLwKlI77klsLzr4YE+xYrTzYFytpRf6DmjtQE
qI4/0AbS93R2mXdDqxVvsQq3pCuZzUJPlgOZJPrAzI3GfyRTMqaece9LqRChu55v
Yvm2tKZWxpkH1r4xcbA+84QpLmy5JLpa44gM/8J+BEMR5PaKCXq93KWTaU6DO9wn
BsPMe+l7xpbP/lRQ/6xQiOv5LL5wy4/0sjmRGwz6cg7oeIePzhTARkihn+DW6+Mu
Ay+iPyZN3zUF3BbL4DzJ9TeuY5PeYN7agqNTLW9n0bzttKGjAg63YU/ENmg7yloB
MPp6DMaQu1AbaGiffB8J7vvCJCLShqLXBKUFDFUJUH0dWrBieGfSU1Z2/A4DTp28
CdSWDB/h10/kbkHOhlSWBWgu79O4JiOTbDoYpuVtHb7Tk0hWY8s7eCYM9aPqxxI2
hBk4Kr07Qg8G9KrpSnTPB6JgI+omhv4MXr4WwzgJRRLeczV+gk3+qaVIH+U+g5Hn
lP+l2bwPdz7prxKsA/tY
=QU2B
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_18_34_19_+1100_0cS6guq+B+fau7+o--
