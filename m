Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbaGRDVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:21:17 -0400
Received: from ozlabs.org ([103.22.144.67]:51108 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759758AbaGRDVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:21:15 -0400
Date: Fri, 18 Jul 2014 13:21:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anish Bhatt <anish@chelsio.com>, Karen Xie <kxie@chelsio.com>,
        Manoj Malviya <manojmalviya@chelsio.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20140718132106.073aa48e@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/x+9o704s=k.jUivpR8zEvlH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/x+9o704s=k.jUivpR8zEvlH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: ".ipv6_dev_get_saddr" [drivers/scsi/cxgbi/libcxgbi.ko] undefined!
ERROR: ".ip6_route_output" [drivers/scsi/cxgbi/libcxgbi.ko] undefined!

Caused by commit fc8d0590d914 ("libcxgbi: Add ipv6 api to driver").
Presumably some missing Kconfig dependency (this build does not have
CONFIG_IPV6 enabled) or it needs some #ifdef guarding.

I have used the net-next tree from next-20140717 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/x+9o704s=k.jUivpR8zEvlH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTyJKnAAoJEMDTa8Ir7ZwVU04QAIcf3Ww4b4/jjS+TKk1HHqbV
WtN6MQwN5R0uJ81Mrv6e886asUS2/JU1qwXBB0nuG16AeilRkFTL96hFdhD2UpEE
u0LkV+Pli12Cw3rQg/StEWW9Q9P2pzFM3mfZfxJYxu9Y3gaPUWC/G7lilpqEFCmA
tjbkYMSgv9fTI0di8ERc8OZK91TsC9dBNeZ10OHe5XbprfXA5nwx5lXP5eL+uESJ
aSPT0M/G8xt3xZ53aZw28MQAtdoGinBm1yR3EA6HTjMKxEy1NcnH4iJXzGzX4Wb8
F6zsVmtQTUeyYuRRk5Uj/ce/WF53Ix50ik6vXVbmF31fbChLizdx9DY0aKdasAPc
+f3qaCMcYet6rosJKptGyz+NTIkYIIm3Ba/e3gBgndxyNuzZxvGsn21AVo6bVESt
XeatSLFrMCkAWiqBmf9QstzPq/ngClYatAYuyJXActofEmpdRbk55x2Sz4+O/MY4
PKAHodBah5qYswJeKBmpLTxJo3h+O8OBL4PGJc7XBwma0AC4BlSPycmUgch5QFyB
9ArOorpyy/xSOe3oys5Ns4x/e/V7rI3YWarb7af4gHaCwLsKqP6blUdfhwwJaEqa
lxg859MWL0e9IfCDNeoTgPbgLlIYTe4gQGlKN/6R8PIgRI93Xo4kMM3MVLBkmpRO
pb8P27Q1jDqzXwCIOMAS
=sBI9
-----END PGP SIGNATURE-----

--Sig_/x+9o704s=k.jUivpR8zEvlH--
