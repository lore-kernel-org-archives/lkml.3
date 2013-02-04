Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3BDFMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 00:12:53 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35061 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3BDFMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 00:12:52 -0500
Date: Mon, 4 Feb 2013 16:12:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the char-misc tree with the mfd tree
Message-Id: <20130204161241.9ba53f0389122d30a2b32ed4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Feb_2013_16_12_41_+1100_WNuPnEP21ReJf88u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Feb_2013_16_12_41_+1100_WNuPnEP21ReJf88u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
drivers/mfd/wm5102-tables.c between commit d078377faf5f ("mfd: wm5102:
Refresh register defaults") from the mfd tree and commit 689557d3c704
("mfd: wm5102: Add microphone clamp control registers") from the
char-misc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mfd/wm5102-tables.c
index c68727d,a396a3a..0000000
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@@ -315,13 -316,9 +321,13 @@@ static const struct reg_default wm5102_
  	{ 0x00000218, 0x01A6 },   /* R536   - Mic Bias Ctrl 1 */=20
  	{ 0x00000219, 0x01A6 },   /* R537   - Mic Bias Ctrl 2 */=20
  	{ 0x0000021A, 0x01A6 },   /* R538   - Mic Bias Ctrl 3 */=20
 +	{ 0x00000225, 0x0400 },   /* R549   - HP Ctrl 1L */
 +	{ 0x00000226, 0x0400 },   /* R550   - HP Ctrl 1R */
  	{ 0x00000293, 0x0000 },   /* R659   - Accessory Detect Mode 1 */=20
  	{ 0x0000029B, 0x0020 },   /* R667   - Headphone Detect 1 */=20
 +	{ 0x0000029C, 0x0000 },   /* R668   - Headphone Detect 2 */
 +	{ 0x0000029F, 0x0000 },   /* R671   - Headphone Detect Test */
- 	{ 0x000002A2, 0x0000 },   /* R674   - Micd Clamp control */
+ 	{ 0x000002A2, 0x0000 },   /* R674   - Micd clamp control */
  	{ 0x000002A3, 0x1102 },   /* R675   - Mic Detect 1 */=20
  	{ 0x000002A4, 0x009F },   /* R676   - Mic Detect 2 */=20
  	{ 0x000002A5, 0x0000 },   /* R677   - Mic Detect 3 */=20
@@@ -1854,11 -1883,8 +1862,12 @@@ static bool wm5102_volatile_register(st
  	case ARIZONA_DSP1_STATUS_1:
  	case ARIZONA_DSP1_STATUS_2:
  	case ARIZONA_DSP1_STATUS_3:
 +	case ARIZONA_DSP1_SCRATCH_0:
 +	case ARIZONA_DSP1_SCRATCH_1:
 +	case ARIZONA_DSP1_SCRATCH_2:
 +	case ARIZONA_DSP1_SCRATCH_3:
  	case ARIZONA_HEADPHONE_DETECT_2:
+ 	case ARIZONA_HP_DACVAL:
  	case ARIZONA_MIC_DETECT_3:
  		return true;
  	default:

--Signature=_Mon__4_Feb_2013_16_12_41_+1100_WNuPnEP21ReJf88u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRD0NJAAoJEECxmPOUX5FE/R4QAKUcuI+Q+F2kXNUOE/3kF8R8
BtOeUCTR34n+Q+7WdW9jnwaWBc4fuqIXvBape/dXj2lbEa3MB9wZOi3PIKX+j1M5
EF8a+BiQ1xIdLRqbWM1dytYVyMW8ubl9IXsSDWMadWFIQ3MbwLYJMYC2xFhLJjXt
uUmOoflAhzHT+vir823QkhZuh7FlWnG3j2uApzHXv8jwOrxtwkrh+K6jElZyu6MP
M1OYSgRDy0sCpznZCdHbbheDcGzbbF5NzUGeXNiAimTF/rYuu/5zZRARNU1YUF/i
tgtuQMsaaAE8oAUCrsWLEZFlWNyx5HZrt1bdo21hWReyOj1mHQKAWOvpdVUhtITz
z9gIW01B6CJOIpBk62M3BvjPhlZJXxH8aAvMu7WD49ciF9mIn/kXsUfci6czx6CX
us5eTe/FzhryXsDeA9FtDHTbCV1iRywHi1ICbEq53mxhzyDpa6K2Vpu4ybCu+Dsw
6N5Xh1DpHP1kokweyXNpZlbpVHBSQJ+gUpt5vBl8/AvPbsMow4aW/seS75s6oGgR
ZQ4RmNO9In4jsR7tVAjzUa0RmvZbZ2lV1QNApAIw5T2+bEsdSBoxj5yaTq33sHs7
ZapuREA9/IzVRYAmgwpunsH0QrSR9eEnGeat/wXVu62kyJLmpp4dTeGr+Ckj6ZZ/
OWuZl/b+RTdxp8jyilqS
=ImRV
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Feb_2013_16_12_41_+1100_WNuPnEP21ReJf88u--
