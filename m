Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3H2CsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:48:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51647 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3H2CsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:48:23 -0400
Date: Thu, 29 Aug 2013 12:48:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Subject: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Message-Id: <20130829124814.2c2547a15b5e8927a4a805a1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Aug_2013_12_48_14_+1000_oeDwcYh/VejLl4GF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Aug_2013_12_48_14_+1000_oeDwcYh/VejLl4GF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
arch/arm/mach-shmobile/board-bockw.c between commit fa3e0cee12fb ("ARM:
shmobile: BOCK-W: fix SDHI0 PFC settings") from Linus' tree and commit
9c43952d0f1e ("[media] ARM: shmobile: BOCK-W: add VIN and ML86V7667
support") from the v4l-dvb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/board-bockw.c
index 3354a85,7d44f66..0000000
--- a/arch/arm/mach-shmobile/board-bockw.c
+++ b/arch/arm/mach-shmobile/board-bockw.c
@@@ -167,13 -188,17 +188,23 @@@ static const struct pinctrl_map bockw_p
  				  "usb1", "usb1"),
  	/* SDHI0 */
  	PIN_MAP_MUX_GROUP_DEFAULT("sh_mobile_sdhi.0", "pfc-r8a7778",
 -				  "sdhi0", "sdhi0"),
 +				  "sdhi0_data4", "sdhi0"),
 +	PIN_MAP_MUX_GROUP_DEFAULT("sh_mobile_sdhi.0", "pfc-r8a7778",
 +				  "sdhi0_ctrl", "sdhi0"),
 +	PIN_MAP_MUX_GROUP_DEFAULT("sh_mobile_sdhi.0", "pfc-r8a7778",
 +				  "sdhi0_cd", "sdhi0"),
 +	PIN_MAP_MUX_GROUP_DEFAULT("sh_mobile_sdhi.0", "pfc-r8a7778",
 +				  "sdhi0_wp", "sdhi0"),
+ 	/* VIN0 */
+ 	PIN_MAP_MUX_GROUP_DEFAULT("r8a7778-vin.0", "pfc-r8a7778",
+ 				  "vin0_clk", "vin0"),
+ 	PIN_MAP_MUX_GROUP_DEFAULT("r8a7778-vin.0", "pfc-r8a7778",
+ 				  "vin0_data8", "vin0"),
+ 	/* VIN1 */
+ 	PIN_MAP_MUX_GROUP_DEFAULT("r8a7778-vin.1", "pfc-r8a7778",
+ 				  "vin1_clk", "vin1"),
+ 	PIN_MAP_MUX_GROUP_DEFAULT("r8a7778-vin.1", "pfc-r8a7778",
+ 				  "vin1_data8", "vin1"),
  };
 =20
  #define FPGA	0x18200000

--Signature=_Thu__29_Aug_2013_12_48_14_+1000_oeDwcYh/VejLl4GF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHrZyAAoJEECxmPOUX5FEJPAP/AvSxPYfrEoa6qyzT6BoCyHK
/CAYBc1TRi6hsioZISuy+VPMihzVyOLm5B4LceQCw5MuTo1FlexzGQbygJ233Efy
R+QEHLos+tBpNFIKCgxsw7EkTMGCFc+m7vvooy1VdSMCMZYORsLs/Lpk2Pwux0zQ
tvl4aTSQMaN5HtDbLluzFFigCW4UPbrROuoLdgzjSeudxMXcWqrLvod8A2qJjoif
0jBKxkR/Wr7Lv2ZYM4cnRxu6lJTrdyT/eXMWXFLGAh0aSiwh4XcoEShgCYaFbqft
M9DGKdleWfSgkxgih2knc34G0q9LfUa9BqnpNbe7/CIQq22l75DO+XpmaVBFm02r
kqKTpeJ+Ysun0wcCPIYcBZ/5TQEdVhWLdN+ssdVigT7z9nTYl4vcFLwstZJpGo7y
ciRxGf5qWoAEeRnqr1XJqDJ5UIjjAbDHaLAgBBIHvQDi5rtaoQTG4mxS+OH9Mn9M
/PzrEC2IAQN6uxnEVA9qAJnDGSSvxR3mQi/sZj9jwXcSOzhWEO3NfniOPtnQa5Sw
h3kKbfh/ikXx7gjITcGLpBC/QgJyiWb+HRQLRnMmlZ7Wi4wUC3/C3fkBRZos2tuq
9ViDqZwpNdBQ5h7A5/U1jn2NfBNtcPXCURdopnYypDji0C0A6g0peBmrm5Ddthfw
qxpfo4akvAIVoYHUYfVR
=Oj5N
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Aug_2013_12_48_14_+1000_oeDwcYh/VejLl4GF--
