Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaKPXCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 18:02:41 -0500
Received: from ozlabs.org ([103.22.144.67]:39697 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbaKPXCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 18:02:40 -0500
Date: Mon, 17 Nov 2014 10:02:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Aaron Ma <mapengyu@gmail.com>
Subject: linux-next: build warning after merge of the pci-current tree
Message-ID: <20141117100220.0e503957@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/kJ3L6kJGsdIxD4T=rAFwhiw"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kJ3L6kJGsdIxD4T=rAFwhiw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

After merging the pci-current tree, today's linux-next build
(arm_multi_v7_defconfig) produced this warning:

drivers/pci/probe.c: In function 'pci_read_bridge_mmio_pref':
drivers/pci/probe.c:438:5: warning: left shift count >=3D width of type
     base |=3D ((dma_addr_t) mem_base_hi) << 32;
     ^
drivers/pci/probe.c:439:5: warning: left shift count >=3D width of type
     limit |=3D ((dma_addr_t) mem_limit_hi) << 32;
     ^

Introduced by commit 3a02517d5e2a ("PCI: Support 64-bit bridge windows
if we have 64-bit dma_addr_t").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/kJ3L6kJGsdIxD4T=rAFwhiw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUaS0NAAoJEMDTa8Ir7ZwVDQoP/0nl+uk9//h81t7qudmegjV+
dqi8pNYmQXO5y6j+EyNs+paZK7vmmZWqeooOQ/Ll0VxvpFTh7vvrhJePOg5k3J1g
hAtFoSdHqgDGMBkXYgdHKjb49K/fbcPtws+QDneokTzVyZeTI+F4d0kmVzYARf3b
tXXhFzzdZzq29SVEmfbki3a/mu6cvQ1hdhG994sFnd3JgAzTfCVpuVi539fKGEwS
6hZ5WQB5TYa6D1E/yerldKxlAAGQnMOQnNE6QkPlsmiuBISw1eNJjBXWZ9N0LKmC
qGqs/Rda9FXM57SDpRGt1p2gfPsatM+mWqnRKZOCzFXo1U0dQ6hLl4S4CI3tGLRJ
WliLj1yy1o3DRS1rAoWZZbCM8Z6BFDYsdD7FQFUnH7G4mMavlwAOfFZZ1Uc4gVDq
gEceeZOwA4FV7102zOASY256ikXQ1bPiz6VIoP+ZPbpDw+cus04nZfd0zP9sS28A
CyU3H8rvrdmtKtdBSEDKLoQcJ9TH5qmrYSxdtMhYWcFjQKREsLGNgRCQ0QrDfCyg
9HQwv9Bq18VT8YWC130YFfMnt6zq3r4daHEo0YRGdTC9tg/uaCnzFdVuJFqX4wI6
oAHZjsTHFYmwrlvvEDJ3FTfsswOrKl07ZQ4XWDW+4Vx/pHn4i04EYKvEjc2fuyWH
avzAPxOF8AUt6MJ7UCu4
=j5y9
-----END PGP SIGNATURE-----

--Sig_/kJ3L6kJGsdIxD4T=rAFwhiw--
