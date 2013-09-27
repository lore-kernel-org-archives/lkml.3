Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3I0IV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:21:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41038 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3I0IV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:21:26 -0400
Date: Fri, 27 Sep 2013 18:21:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: linux-next: build failure after merge of the final tree (tty tree
 related)
Message-Id: <20130927182117.42cdf5287fa1e9b40dd3f8e9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Sep_2013_18_21_17_+1000_wKOpSls_94jqdSAN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Sep_2013_18_21_17_+1000_wKOpSls_94jqdSAN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/tty/serial/8250/8250_dw.c: In function 'dw8250_probe':
drivers/tty/serial/8250/8250_dw.c:341:3: error: too many arguments to funct=
ion 'dw8250_probe_acpi'
   err =3D dw8250_probe_acpi(&uart, data);
   ^
drivers/tty/serial/8250/8250_dw.c:281:19: note: declared here
 static inline int dw8250_probe_acpi(struct uart_8250_port *up)
                   ^

Caused by commit fe95855539fd ("serial: 8250_dw: don't limit DMA support
to ACPI") from the tty tree.

I have reverted that commit for today (and commit 7fb8c56c7fa0 ("serial:
8250_dw: provide a filter for DMA channel detection") that depends on it).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Sep_2013_18_21_17_+1000_wKOpSls_94jqdSAN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSRUACAAoJEMDTa8Ir7ZwV3sgP/0TChbm/lVzfvOKygcR/zbn/
gHWi+SHDhzqX+tsuqJOoiNgNqzLtZ1Y6SOXqHJMPDXY66MF2b68s0YnJpQCleYJE
wKtdG8uXPFYZFsXp9EcObYnl5ZTobo3EsVjuLiO6tfdKaZrjQ6bJTyiH2BRk++TZ
0bx2eN6X4Peq96Av0t4Ntccfikfb+jVHYCPzhDzjMl7w3d4oFd/Cin7DIcQ8rDSO
HQ/0DOrDTywq2RAno7YNEnIXJlrtYxUemL0JuAoQYKr57kQYk8QH9GS/m6PLiof1
GaGSMYgwUn8OHqxjO2svWw/TgtTCHBXAYW61UyfcJYeC9pGXK3+yIyvWb2AbjY1y
37WP1IR00ta8tfPYlfEKqN/u6dG2geIACK2wu4fv0cKx5uMp4CRkV5kQjdCrPobn
N6s7Q8Rjly2l0+hksrmv+ZhtZrE0Q0bFozEe4Z6lbFCuFAh9Nex/Y63Iep3TC2Js
Zxf3igKj/Yw8EzjBOQKZ7RB5QT8wu6pwFqaNIVMj7GP3Hf/UTDhshaOQs0lhDdXU
7ibCNKJTwfLQx/dhVsHqKNmxUnwVkoarcpi8PfB0khxBHqgmmflV44L9YEqxY2xX
QDmx1UEHtHbxvRJyYLNQhiyBRbgC1Egh14ZQtaaZvx+eQBH9dYMMCUjFLKWqRGPv
+Zqcw/fzw8F49u71q5ZY
=ruou
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Sep_2013_18_21_17_+1000_wKOpSls_94jqdSAN--
