Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaKJD2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 22:28:13 -0500
Received: from ozlabs.org ([103.22.144.67]:58885 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaKJD2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 22:28:11 -0500
Date: Mon, 10 Nov 2014 14:28:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalina Mocanu <catalina.mocanu@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>
Subject: linux-next: manual merge of the tiny tree with Linus' tree
Message-ID: <20141110142803.0dd121b3@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/H3ib.XDcVPJzPdoX6j9mt6k"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/H3ib.XDcVPJzPdoX6j9mt6k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Josh,

Today's linux-next merge of the tiny tree got a conflict in net/Kconfig
between commit f89b7755f517 ("bpf: split eBPF out of NET") from Linus'
tree and commit 4ecea0db79ef ("lib: rhashtable: Make rhashtable.c
optional") from the tiny tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/Kconfig
index 99815b5454bf,02badd46823f..000000000000
--- a/net/Kconfig
+++ b/net/Kconfig
@@@ -6,7 -6,8 +6,8 @@@ menuconfig NE
  	bool "Networking support"
  	select NLATTR
  	select GENERIC_NET_UTILS
 -	select ANON_INODES
 +	select BPF
+ 	select RHASHTABLE
  	---help---
  	  Unless you really know what you are doing, you should say Y here.
  	  The reason is that some programs need kernel networking support even

--Sig_/H3ib.XDcVPJzPdoX6j9mt6k
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYDDIAAoJEMDTa8Ir7ZwVZ4YP/ieQ4DS8O4++ThvRU0/411nQ
sAE9EPp+D+MpDjDsI2wocoSQFIp9oHpqHMeLUtxiRARBPefJcE2EAPWiwQIab/Rb
3WDrp//gGmRDCKxG7e040gYR+/qS98hjO9bVt42/qLrY3wbOaAi4XC44hZa2TScU
6pYJiwhjNWPT8+35plbVkxKa2v3PEsdvy74u/FzavOZQskFkQXfazGJHbGmF8LQ/
n0+1EpBmjosM6gSZDRjVffXq3a47CJPzIlyCzJJLRc/EwaMTwDE8RQCsxTRP6y2t
g/7zBOxSm4PPOP1Pym2ynGASDST94vGUlDIQKeZpwdB4kmy7aAkTEW/R88FooHI8
eGbV1vggJgr+QRXtcxswzoHqx6X9+eHMEpnxRqx7p/0A8bv7wHENc4uOrtRYL9S4
H45qZo9pOk542MdtlegEB7GcgbpharaC6YjJbFVhj3kwRDLRY+XMBJFquwhU2jee
NoliqSKjSgJRhxgEIDIXWB21PSElRJqGFAVFp3HXk2hej+ZcJUqtwbUYIIjMa1TG
+OtK8CL4yUaMWfvSXXzZuNmTtTTSoMSCxgIqAcTm9VbWWa61JtQoJEv6VanLnsVa
NN5CVA4FHXKlLEnWNIxltVeGndlB/MMcYNr+23HfagdPJ2RaR8vOF+batiMiSNPJ
go3PN6qdg4XAzE6PYlD9
=Yicf
-----END PGP SIGNATURE-----

--Sig_/H3ib.XDcVPJzPdoX6j9mt6k--
