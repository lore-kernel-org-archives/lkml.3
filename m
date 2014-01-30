Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaA3BmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 20:42:09 -0500
Received: from ozlabs.org ([203.10.76.45]:47129 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaA3BmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 20:42:08 -0500
Date: Thu, 30 Jan 2014 12:42:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20140130124201.d24b784b6483a11fe3057bd9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__30_Jan_2014_12_42_01_+1100_RoIoyBQrNKdXnQa0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jan_2014_12_42_01_+1100_RoIoyBQrNKdXnQa0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
kernel/sysctl.c between commit 54a43d54988a ("numa: add a sysctl for
numa_balancing") from Linus' tree and commit 52bf84aa206c ("sched/numa,
mm: Remove p->numa_migrate_deferred") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/sysctl.c
index 096db7452cbd,2a4a4fc89cd1..000000000000
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@@ -383,22 -386,6 +385,15 @@@ static struct ctl_table kern_table[] =3D=20
  		.mode		=3D 0644,
  		.proc_handler	=3D proc_dointvec,
  	},
 +	{
- 		.procname       =3D "numa_balancing_migrate_deferred",
- 		.data           =3D &sysctl_numa_balancing_migrate_deferred,
- 		.maxlen         =3D sizeof(unsigned int),
- 		.mode           =3D 0644,
- 		.proc_handler   =3D proc_dointvec,
- 	},
- 	{
 +		.procname	=3D "numa_balancing",
 +		.data		=3D NULL, /* filled in by handler */
 +		.maxlen		=3D sizeof(unsigned int),
 +		.mode		=3D 0644,
 +		.proc_handler	=3D sysctl_numa_balancing,
 +		.extra1		=3D &zero,
 +		.extra2		=3D &one,
 +	},
  #endif /* CONFIG_NUMA_BALANCING */
  #endif /* CONFIG_SCHED_DEBUG */
  	{

--Signature=_Thu__30_Jan_2014_12_42_01_+1100_RoIoyBQrNKdXnQa0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6a3tAAoJEMDTa8Ir7ZwVaTIP/0sRwpnwUQAiY3Df+GdHNaBg
J/IYUpFCW/gdSFJW0RU66qHtdbM4qym7sBHfocw9WyRgAn/kaSL1vMAhTiLY5BXS
6/QSD/yKA9niBhlP0TKLchIE/NLaT+gyD70NiK1Ghmb8BwTwySI8/Zw16epyqN58
gkoCQLnN+V4B8G3ZRS9nW/ZL9QDExZXaedr9Z2m3NZZwOk7ktq4TMYZrlN0b52Ky
WFEpClyJ7kkxe+x8OxOoGYitOaJunowQ3vpNcc8fIfIn6Q38GfzAvNpAf2uSOfLM
opnz3ViodI2xt23KMI0RsCmi9rgVVk6+kOSeTYkaMgQOq7u1FpP4Z7PO8lqxReCi
2xCGeM4DVArXsfjZXE6OzXSQh3VPfVxWue0mD0TaX9d2vQE8LWlWnzWU4Pgnm+mx
FZ/FZaJn4Cxz0gWAXsbLG5GOkXj7jlxNFptLLfKHVwkPdxiSiMt0eO4CkC8i2wh6
0rRVS078HAJSNqiKtb5MpwXrL23Sb0rtYYaHie8EJae6anL00OHJrFc4naETvP0L
9Ss02xmN3/pxnPnBLcNFkjqBs0/lXAagEhETHmlOBmAq6xC2xrRem2h2ya4ZmIpS
fC449NZRfeNKEsKb42R2aMIgwv9QF3pH3uXMA7/+r7i4Yu7chvafH1OWMkGTvFdH
pI/1SAngU0seenZXNurt
=uxfb
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jan_2014_12_42_01_+1100_RoIoyBQrNKdXnQa0--
