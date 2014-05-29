Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980AbaE2H3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:29:09 -0400
Received: from ozlabs.org ([103.22.144.67]:54090 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964922AbaE2H3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:29:06 -0400
Date: Thu, 29 May 2014 17:28:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qipan Li <Qipan.Li@csr.com>, Barry Song <Baohua.Song@csr.com>
Subject: linux-next: build failure after merge of the tty tree
Message-ID: <20140529172858.43a0063a@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/HUPhy9QFex//.sI7l2BpbgE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HUPhy9QFex//.sI7l2BpbgE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

drivers/tty/serial/sirfsoc_uart.c: In function 'sirfsoc_uart_rx_dma_complet=
e_tl':
drivers/tty/serial/sirfsoc_uart.c:707:2: error: 'struct uart_port' has no m=
ember named 'rx_lock'

Caused by commit 07d410e06463 ("serial: sirf: fix spinlock deadlock
issue").  Did anyone even build test this? Much less test that it fixed
the deadlock ... :-(

I have used the tty tree from next-20140528 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/HUPhy9QFex//.sI7l2BpbgE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThuG/AAoJEMDTa8Ir7ZwV3/4P/0MpNCAM5ScKya63ItNp7bAS
qK5tDxhn9YVBsDv1dPjdLBqcVQs5aHUQCQPRrqM4QCkciHFOJTEmzctA7MJW/Qc5
5v85uNB+sjVrnlp1FxDRlpx5hHMab633bAcr/oj7L/aIAsQg+65V3M86vUHHip0q
7UytLwwpJ45CRMVdK+8GFhQRp3Mzf7xkmgBXGCNXm+ApV8TCdpzYhx70+IWyGm+6
IQaRVkMXuWhETGhXnFP30yZcjsSx6ofpAbMVZn23o5KAZ8DzJF8dsVu3bPCV3+VA
QU18wKE/Lkk0mM0nPPGdqNc5ByKcWDzGiMM+LTk1LbghAXVbUwwIRzD2YOsvaTiz
DEXkX843hfdwhPd3M4kaDs+BBrDPGsXtFqHuI/QxH6TghSH+BnguG1F+wiDrfprK
8nmUApFMReWVShkzIv3QcXnRfqj9oQRX6nMkQ+bhaEirGJOIWnnKGg/+gVLaWs2A
IMZUtVrar5+gwSlFXRgTaBvxcMVzfcoDqG6U7sk5/hnNyFT10gzZ/fiwaqWwr1Rd
DhpNv2GpFtsPgFh73UbpCEXOT5L0ZMVFluYKetMHG6rCoXjbACdQx0On0YS0iPpx
Wqc91cR2pH5HSL2uKw68auyirNV+fmH9I+CjrX+LpzBPY1jibeQ6/6ZDsgqkLmFT
TAhTgKgKAcygLe/gbNzS
=dUBJ
-----END PGP SIGNATURE-----

--Sig_/HUPhy9QFex//.sI7l2BpbgE--
