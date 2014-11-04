Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaKDEnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 23:43:31 -0500
Received: from ozlabs.org ([103.22.144.67]:52201 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbaKDEn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 23:43:29 -0500
Date: Tue, 4 Nov 2014 15:43:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Robert Elliott <elliott@hp.com>,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: build failure after merge of the scsi tree
Message-ID: <20141104154320.2919bf64@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wy/dvRL0Jh3Bl.7ttsN289G"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wy/dvRL0Jh3Bl.7ttsN289G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

In file included from include/linux/sched.h:17:0,
                 from include/linux/blkdev.h:4,
                 from drivers/scsi/constants.c:10:
drivers/scsi/constants.c: In function 'scsi_opcode_sa_name':
include/linux/kernel.h:54:32: error: invalid application of 'sizeof' to inc=
omplete type 'const char *[]'
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(=
arr))
                                ^
drivers/scsi/constants.c:300:15: note: in expansion of macro 'ARRAY_SIZE'
  if (opcode < ARRAY_SIZE(cdb_byte0_names))
               ^

Caused by 94bafab0008c ("scsi: consolidate opcode lookup in
scsi_opcode_sa_name()").  This build does not have
CONFIG_SCSI_CONSTANTS set.

I have used the scsi tree from next-20141031 again (since yesterday's
tree had a different build problem).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/wy/dvRL0Jh3Bl.7ttsN289G
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWFltAAoJEMDTa8Ir7ZwVGdoP/12arQwBPQCDJ2r+gKsy8+ge
puMmMd1ATTxpHwXaaHkM3XYl3V39E/FnrOJwZbFGml1wR+23hpFt8RRFJRSj5G/S
6k+2IGe8xnRXvAXipIt541H4nmZbrRxKLeUbWU+Ilp0YuRa5Ah2XuvBdNb0TD6yn
P9022FYc2GTO+9IHaG4yoDNSSwMJQwiOZopzcYrR3WnheI9HYzpsJMr5FLgxqvC8
I7cHj0hj3QsVCpkKjPaWkgTahDkQgvlsxn/70Blw0MlFZdSkeLK+qqzFP3y9Z1/0
UCmw1NcjL6diIxfeDF/ag0nKPC1XMB8BtdNuYNgUHCkwTYrUMg/GbajOkV1UsRW0
embYcXnLHOjnZ+oUF7MZCIMWc79WPRSGRf673gBj1RyC5BWB44WGyL8PswqxsGDW
cqlGcrn/Ft8mEVraCOmeBK39eOQ6J7R3StUWcpHZkez/g+zGms79f1H2spRxgAAs
n/mDXaFd1knLqRxl26oikq45RejYw8zFr35kkVBj2965MMVcuzTAtJthCJqvlRtF
jpZ7awOfAScitBcfYGrDpOYgXBGMOKk2fhePJzMO6+IgOEfdAl4nGPzgL07tugn9
R3yLxHx+7fV6WKktwy27+Krbw66eir13f+z7xBE4ljfFSXRbHo2qARpNuPKXoDBz
D6AYnvKqIqIn/F4tl62t
=rHWC
-----END PGP SIGNATURE-----

--Sig_/wy/dvRL0Jh3Bl.7ttsN289G--
