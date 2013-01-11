Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab3AKFwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 00:52:53 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53647 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab3AKFww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 00:52:52 -0500
Date: Fri, 11 Jan 2013 16:52:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>
Subject: linux-next: build failure after merge of the final tree (powerpc
 tree related)
Message-Id: <20130111165241.44a5ede6b24c997810be74e1@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Jan_2013_16_52_41_+1100_HYpva/npX.Lrv51c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Jan_2013_16_52_41_+1100_HYpva/npX.Lrv51c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

arch/powerpc/kernel/kgdb.c: In function 'kgdb_arch_exit':
arch/powerpc/kernel/kgdb.c:492:2: error: '__debugger_breakx_match' undeclar=
ed (first use in this function)

Caused by commit 9422de3e953d ("powerpc: Hardware breakpoints rewrite to
handle non DABR breakpoint registers").  I applied "powerpc: Fix typo in
breakpoint kgdb code" from Mikey for this.

arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:1204: Error: attempt to move .org back=
wards

Not sure what caused that - probably a combination of patches adding code
low down.  I have just left this broken for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__11_Jan_2013_16_52_41_+1100_HYpva/npX.Lrv51c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ76ipAAoJEECxmPOUX5FE7tQQAIFdZpJ78SNjcr9cc+ia823y
7i+bezSWLUGToKHZJ87ajVtMCpImEVCsQa2Hq1GahBlj9vQJmpkGQ79GD1bxt6wW
behryfUSf3ORzVKseUsrXQ53FI35jSk38hL4xNqGH5sbtarZb6fPlWN4iPiFwo6k
5QIoYo5MabgvQEHOJBNiuX2XqEdFYgHM7qZ8SMSImnAJE1MHYt/dmx6AdVFoKNXq
JXcPPBmmnjXnK1JKst5tnti+AmGimIaHPfsf3FSj1JGApPFIovQtU5kPH2HeNz1S
v0QY6xski27Dy9CQNkWIa4vov0ok7DJ3vqbRxCfVZWCE0G4/EHRikUclmQE8gsQq
5xplD+oOAS0pzKMnbFxi62gBv+9tWwoSFrgjneQjHkXpoFmpS/Khn152K0XX4IH+
4C22CF5HJvLT4MfaU7AiaafBI8GIU53tVXMTecOlPYXZiuoOmBcDvunvyFW0le9k
bLq3YRh3H4s/cSN/jEgtyuiQUXZxSo45uv0i/xEHpVz3DMe3+KfFCTe0dIiJihIJ
DktVGtoi+wm2TJC01hV8XammK+OxYL1pkS1CwapD+bUJls1Xctu+UzQ2L+obOdkf
rJpf/9I2Z5xvrPPeKf8+UVVO6zQvp//Y/pgJnmjLZMZ3dcQ+00rFbx73Fu/+BCwy
GLOceTmxfvFMH4uLUrUh
=k6Ic
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Jan_2013_16_52_41_+1100_HYpva/npX.Lrv51c--
