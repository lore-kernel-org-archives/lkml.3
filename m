Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaK0G2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:28:46 -0500
Received: from ozlabs.org ([103.22.144.67]:40937 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaK0G2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:28:31 -0500
Date: Thu, 27 Nov 2014 17:28:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: linux-next: build warning after merge of the irqchip tree
Message-ID: <20141127172822.593adbd2@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/v3OSX=lX_Lxx6my=lT=UUBP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/v3OSX=lX_Lxx6my=lT=UUBP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jason,

After merging the irqchip tree, today's linux-next build (arm
multi_v7_defconfig) produced this warning:

include/linux/irqchip/arm-gic.h:109:53: warning: its scope is only this def=
inition or declaration, which is probably not what you want
In file included from arch/arm/mach-ux500/pm.c:13:0:
include/linux/irqchip/arm-gic.h:109:53: warning: 'struct irq_domain' declar=
ed inside parameter list
 int gicv2m_of_init(struct device_node *node, struct irq_domain *parent);
                                                     ^

and many more similar.

Introduced by commit 853a33ce6932 ("irqchip: gic-v2m: Add support for
ARM GICv2m MSI(-X) doorbell").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/v3OSX=lX_Lxx6my=lT=UUBP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdsSMAAoJEMDTa8Ir7ZwVAk0P/0m1ThqDqrzqvRDQ1mu8aay1
8GM1n65I4QYfhJlTBacg4WyDofjRWokxCB/pcfDe7gATNTvHEKWnh++gZ3Q9Iexu
RkXXLJu/U3snjsob7ZqSfViNURBNTD9CjeGsr/M5TguUL2dRAQFeOg2tV4HmvOJ1
QwWCmHSpiIo/MX1FoVGlYIc6Tx2+CMKB1PWGJ+COjmJI8stAXI6/5Va+dY/aT4Ue
YUjfPS1OZcSKCb8bY4C27eoi7f+1iQg5LFjrdD8Ai6Ag6cKFX2n7an+TQg7jaTaz
wLCtukfEyB8V/JiXgH6jj4VFBC2T+QaEKOh/Te0kBrrE9LjKY6VkjghoMue1Awcy
Wam7SDbrE55aQg8LuIIKTRWze91UcOu/eQ/SzsK38ncGP7Jwq9OMtyH2p0s1iYt1
6PS9XtUYnsMzphc3wOoKKJbBXSrn8A2V1yfV3OUcPeaM9KX2NDpNlbdeJ+KqBc+y
iFS0JSONN8ZVjZ2z7wcLkBAmNAhM7KWVn2HhBOYn30w6l1VXsCyqCmqSkeAtjnrk
OIq4p9GCoAj88LqTe4k3clPzCM86ZhgCWdEIWLv+86ALJloLk7w3PpU2Hl7Lx8U+
BsGgBC1NJvqfFtZESczTdAdNrczzJzUH9Y0Fv8VjG0V+DhNcnRSYQxl+jdYTkPNq
PTeOZm5b4MlfK5f4zjJH
=1Xan
-----END PGP SIGNATURE-----

--Sig_/v3OSX=lX_Lxx6my=lT=UUBP--
