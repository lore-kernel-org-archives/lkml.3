Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab3FQDJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:09:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51325 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3FQDJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:09:30 -0400
Date: Mon, 17 Jun 2013 13:09:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20130617130918.a8a361ff284b1ac2186598ea@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_13_09_18_+1000_.R5VNNYZ5F_nqn8R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_13_09_18_+1000_.R5VNNYZ5F_nqn8R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_sdvo.c between commit c3456fb3e471 ("drm/i915:
prefer VBT modes for SVDO-LVDS over EDID") from Linus' tree and commit
41aa344866e3 ("drm/i915: Organize VBT stuff inside drm_i915_private")
from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_sdvo.c
index d4ea6c2,7068195..0000000
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@@ -1776,17 -1848,14 +1848,17 @@@ static void intel_sdvo_get_lvds_modes(s
  	 * Assume that the preferred modes are
  	 * arranged in priority order.
  	 */
 -	intel_ddc_get_modes(connector, intel_sdvo->i2c);
 -	if (list_empty(&connector->probed_modes) =3D=3D false)
 -		goto end;
 +	intel_ddc_get_modes(connector, &intel_sdvo->ddc);
 =20
 -	/* Fetch modes from VBT */
 +	/*
 +	 * Fetch modes from VBT. For SDVO prefer the VBT mode since some
 +	 * SDVO->LVDS transcoders can't cope with the EDID mode. Since
 +	 * drm_mode_probed_add adds the mode at the head of the list we add it
 +	 * last.
 +	 */
- 	if (dev_priv->sdvo_lvds_vbt_mode !=3D NULL) {
+ 	if (dev_priv->vbt.sdvo_lvds_vbt_mode !=3D NULL) {
  		newmode =3D drm_mode_duplicate(connector->dev,
- 					     dev_priv->sdvo_lvds_vbt_mode);
+ 					     dev_priv->vbt.sdvo_lvds_vbt_mode);
  		if (newmode !=3D NULL) {
  			/* Guarantee the mode is preferred */
  			newmode->type =3D (DRM_MODE_TYPE_PREFERRED |

--Signature=_Mon__17_Jun_2013_13_09_18_+1000_.R5VNNYZ5F_nqn8R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvn3iAAoJEECxmPOUX5FEinAP/3r1F4jn4E3O56GEdOtBEXtK
Lffn7hViM2oCYaz3D/YTDHvbWJqlvw9Sy48WiIfZakAi4JSX4o0MOGAu0aOzHpYx
uHtSIErrB34ZBavsrQghvuGRPikjE9iwh771ezlRwlgLzb+f2WnqiOftt7NRyew7
9uDjJGfTIy/TR6qxG7rIgCDVIalTqHsGmrhnphOqLeP7kfXMomv5noLTrzXNP9km
NrcSfiU8yCqNttCeneXbZ2Yn1QDVbOlRM8QQKoFUAuI5tFQhg1hC38vjlMj+tfWS
5nhwmz1cTeLjd0ehT8EeTSqcE+eGm9Z4qhsZSA6xnVmWOZLBo1f0tUiyDYjr4RPi
73W+qDBPkL8uFWddJBjyzElJcxL2Tp+L+ET9l+46vAg8ETsV+FJ1OTlgZytVtHh6
fIC+cR2KHPrddiGUIgGsiBbOpu4ol8TOWUMQOoh/w6w1wV4bAKUMTppj2r+ajvvN
QcnMrqg9shZduPG14vnRKE1yWxqjQUZTIHHym5qUXv/9ha/YtKtDaiNLGu0s37Y7
iME0AVxBd4Dq2DRmBw8tPpBopa8k9u2/GNqaSgRa0KIxKcpPCRQzOnwPDshijqNS
KgUDpChicfrDXc6ZRdfX26PYDQkmN2bsDSfeKWBsXPg45mo6nnNElQgwW19wCZBr
Fiw+v61N6qMAnlRgPLxJ
=t22J
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_13_09_18_+1000_.R5VNNYZ5F_nqn8R--
