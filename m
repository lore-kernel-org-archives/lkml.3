Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaKJGPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:15:46 -0500
Received: from ozlabs.org ([103.22.144.67]:33171 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaKJGPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:15:44 -0500
Date: Mon, 10 Nov 2014 17:15:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anish Bhatt <anish@chelsio.com>, Christoph Hellwig <hch@lst.de>,
        Karen Xie <kxie@chelsio.com>
Subject: linux-next: build failure after merge of the scsi tree
Message-ID: <20141110171533.63b2dfcc@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/GUtEBAxf31v4UOrd9PG1DiT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GUtEBAxf31v4UOrd9PG1DiT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/scsi/cxgbi/cxgb4i/cxgb4i.c: In function 'do_abort_req_rss':
drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:942:3: error: too many arguments to func=
tion 'send_tx_flowc_wr'
   send_tx_flowc_wr(csk, 0);
   ^
drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:492:20: note: declared here
 static inline void send_tx_flowc_wr(struct cxgbi_sock *csk)
                    ^

Caused by commit 4be50d4f7649 ("cxgb4i: send abort_rpl correctly").

I have used the scsi tree from next-20141106 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/GUtEBAxf31v4UOrd9PG1DiT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYFgNAAoJEMDTa8Ir7ZwVfWwP/0q/SIcRDJyQwQXhXGsPYrS9
jE88IqttfoCbpG25wfiRNNSxomvtuVgQpsWmU1KlRpeSBWOQ5tMw0sHhgS1qqixV
OnreiixcyHHhMdDs55/6vuTDmxvaBNwgyJt04bA01qpR+ASdZlxMpX6cH8J98qur
l30NC4QkK2hgJ43n6xaFji4hOEvVg86XVrjdI9GnC/41CBMgXAEaYu3zqxk3q9k0
Pcyg+Hred82MAzII3rs1R9rA7uNUi+nO9MuFMZzRUwgbtYZQUmAyjOfrSBony8na
3OC9fiHQZy111p5i7HOIHHklLhBMoswXf8zQPMCLHqQjCYjx0h4JveV3Gw2vIA65
e7ZKWjDYbdaVzKUB3uPWXyWFdOmId5esQXObB9Jc16obRfqZT7tbQNiGfGhENA9c
f12WVcFZAuez4uoAKQ7Tu0cYMWQ2MyWtxye+TO41bxK7/pn/CiCQCQF7kZMcD+Lv
+CA6IfkoelkFLSW7UoTTRTKKCH5oRkzsjHLiDquiAalYIo47R9RjMEUglcDyLFXl
DW2E13T3LmftFkq1+BSIj5Cw9EVBJGEaDWP1RPQiaqxtrbUGzqduC8EZ2iuVD9ni
oKu8gpFlq/nq6b+Qj/kSjPuwQulRL5wr1ZayFdZ8inoDOOSHeEXUR1UduNPcEjj9
Tim1B2ssaYWmaqIBshkh
=jNmM
-----END PGP SIGNATURE-----

--Sig_/GUtEBAxf31v4UOrd9PG1DiT--
