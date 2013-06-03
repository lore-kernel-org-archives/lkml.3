Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3FCAqF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 20:46:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48602 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab3FCAp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 20:45:57 -0400
Date: Mon, 3 Jun 2013 10:45:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Campbell <ian.campbell@citrix.com>,
        Matthijs Kooijman <matthijs@stdin.nl>, Michal Marek <mmarek@suse.cz>
Subject: linux-next: manual merge of the devicetree-current tree with the
 kbuild-current tree
Message-Id: <20130603104541.ba697d4df0ac27a363bb05b7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Jun_2013_10_45_41_+1000_QT1TtcMG2SMGqRCC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Jun_2013_10_45_41_+1000_QT1TtcMG2SMGqRCC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the devicetree-current tree got a conflict in s=
cripts/Makefile.lib between commit ad06156876c0 ("kbuild: Don't assume dts =
files live in arch/*/boot/dts") from the  tree and commit 2c302eb0a6a5 ("kb=
uild: make sure we clean up DTB temporary files") from the devicetree-curre=
nt tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc scripts/Makefile.lib
index 8337663,d7ec7cf..0000000
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@@ -264,9 -264,9 +264,9 @@@ $(obj)/%.dtb.S: $(obj)/%.dt
  quiet_cmd_dtc =3D DTC     $@
  cmd_dtc =3D $(CPP) $(dtc_cpp_flags) -x assembler-with-cpp -o $(dtc-tmp) $=
< ; \
  	$(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 \
 -		-i $(srctree)/arch/$(SRCARCH)/boot/dts $(DTC_FLAGS) \
 +		-i $(dir $<) $(DTC_FLAGS) \
- 		-d $(depfile).dtc $(dtc-tmp) ; \
- 	cat $(depfile).pre $(depfile).dtc > $(depfile)
+ 		-d $(depfile).dtc.tmp $(dtc-tmp) ; \
+ 	cat $(depfile).pre.tmp $(depfile).dtc.tmp > $(depfile)
 =20
  $(obj)/%.dtb: $(src)/%.dts FORCE
  	$(call if_changed_dep,dtc)

--Signature=_Mon__3_Jun_2013_10_45_41_+1000_QT1TtcMG2SMGqRCC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRq+c6AAoJEECxmPOUX5FERjEP+wb+AzA7TW2fn6O0CfmaRZN+
uY8lDdPR1T5oqRziEI9wZ4vweVUFbJNiS4G7UR4oM+dm5Mf77ZJWpT2vdI/bbjsb
CRpS9cBLx4kkxmRoi4HbnDCvP5t9P8WRbcEbpMZn0t6b3c8UPlG61lQdxrCC1tpf
j7Df6WWGAjPu+UcWr1k/zoym8OB6ILCGQWkzGGnr2zOlqV9d+V+6/xYyJOQDhAQP
jnrZFkStzuatQZtGUKhhKXg5iIv2yJEYnruRTyB2lF35NFrDxp7+0xmCkg0QRgR1
tDCSVNRm6wPW/OLLZDVe/60RzJCwNi6Y/GCrPj4qBXTKRBQSDaB8mGEdc3CdHyYG
sOiyn2ACwsxReK3ORH51Ewf1IDoKcdMrR2VtsjakSYTEF1gr4BHQ2ZOqy36gUMhV
HDwdRRoWuvdPLk8+30s+Gbjc47e33Eik0VJBMpzJa6TqVyFpx9hjdBrUmFQL9eZR
o1b20DrOOG5gwwiHTmlJ3nKZDH3ZYYCSVO6z0ejnK8fJGovzvedYrt3036ZxmAhK
M24qChWEuUZTF9DInai1cbyw/gMnxiCASLx68fqTKBFESryuFaSzKlub1VIWufM6
+uY7yNtHPYfy/bGQcbOXrgdxmkkTsg8dqatB0GldKWjAEaEcNCzgn3XNPrbUMn+z
yxc3X5VPmpwDPNnMr8Df
=Zt0c
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Jun_2013_10_45_41_+1000_QT1TtcMG2SMGqRCC--
