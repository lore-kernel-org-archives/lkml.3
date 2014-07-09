Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaGIEGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:06:24 -0400
Received: from ozlabs.org ([103.22.144.67]:40201 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbaGIEGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:06:23 -0400
Date: Wed, 9 Jul 2014 14:06:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clint Taylor <clinton.a.taylor@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>
Subject: linux-next: manual merge of the drm tree with the drm-intel-fixes
 tree
Message-ID: <20140709140616.28db3a01@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/NjQkMcXrVM.xC=3UTXYQdX1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NjQkMcXrVM.xC=3UTXYQdX1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_drv.h between commit 72f5fd2a9815
("drm/i915/vlv: T12 eDP panel timing enforcement during reboot") from
the drm-intel-fixes tree and commit 6118efe5968c ("drm/i915: move
psr_setup_done to psr struct") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_drv.h
index f67340ed2c12,5f7c7bd94d90..000000000000
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@@ -537,9 -541,6 +541,8 @@@ struct intel_dp=20
  	unsigned long last_power_cycle;
  	unsigned long last_power_on;
  	unsigned long last_backlight_off;
- 	bool psr_setup_done;
 +	struct notifier_block edp_notifier;
 +
  	bool use_tps3;
  	struct intel_connector *attached_connector;
 =20

--Sig_/NjQkMcXrVM.xC=3UTXYQdX1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTvL+8AAoJEMDTa8Ir7ZwVBwAP/0zcugRoR0fd3uMzZgtTiSAI
640tl7fflwupvLFqkC4YYs8iU2J5IJm0VURX/QUfyqJcxtUsRDyj5QI2wnB7s1zB
As2749C+J55xfZsIjXuSuNCvQTuUV0dMkLN6q5IRtTq29Kfwpt+TOwYFAuiBNJAP
F1k60y1//5zWQcNnOyuGR1f3PhPPOVsSeTPFmm0IMDujNQ+vzcECUZyf9dgGWOIz
ARzCJ8kNQN28g9psJMUkSszXzaaSIGrNRrGVZN5p2eCHkHJzl+NBwGssGh3Opwig
IsuCk4M91HlS8h0ko+AnptreZc7k2AI/nmEutTrWjSB/Dw5tyyPSl3JNIrTb3dEp
ttVflm+wybaOPKyjocibgu7G5BXN3J2nrb3jf94kL+oVzdl4+2nSj6PwUXv7TNUe
rcyfYILP1aZMlAkotolCR0XJxZILBgg3Ol38k8E1hfwAUmGbY/mLolcIOd4RkTpM
WJInI1xsAaBCHx4y61BWxmqg90AX+FprcV8wCHoKH3xmyRojGpmxAKCd8qub1I5l
hadK8+joSzKn4fBFfB561FW7XPwU7DvHE4Wc/Ewx7aroWQChptjZLMbEPLU69n0T
PnD0ujpSE2SvUM93Cije3Sru+S9MS/BPou8kbUJJQDxvJ9W9S2YKENvzFA3tls2o
735u1afseaqypK9HW8WU
=mtF/
-----END PGP SIGNATURE-----

--Sig_/NjQkMcXrVM.xC=3UTXYQdX1--
