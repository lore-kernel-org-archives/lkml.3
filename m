Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3J1FL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:11:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33005 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3J1FLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:11:25 -0400
Date: Mon, 28 Oct 2013 16:11:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlZpbGxlIFN5cmrDpGzDpCI=?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20131028161112.bc9ff9e8728cf29554dfa05d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Oct_2013_16_11_12_+1100_fHtOfGffAl8QdIWN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Oct_2013_16_11_12_+1100_fHtOfGffAl8QdIWN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/i915_dma.c between commit e1264ebe9ff4 ("Revert
"drm/i915: Delay disabling of VGA memory until vgacon->fbcon handoff is
done"") from Linus' tree and commit ce352550327b ("drm/i915: Fix
unclaimed register access due to delayed VGA memory disable") from the
drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_dma.c
index d5c784d48671,437886641d90..000000000000
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@@ -1348,6 -1358,13 +1355,8 @@@ static int i915_load_modeset_init(struc
  	 */
  	intel_fbdev_initial_config(dev);
 =20
 -	/*
 -	 * Must do this after fbcon init so that
 -	 * vgacon_save_screen() works during the handover.
 -	 */
 -	i915_disable_vga_mem(dev);
+ 	intel_display_power_put(dev, POWER_DOMAIN_VGA);
+=20
  	/* Only enable hotplug handling once the fbdev is fully set up. */
  	dev_priv->enable_hotplug_processing =3D true;
 =20

--Signature=_Mon__28_Oct_2013_16_11_12_+1100_fHtOfGffAl8QdIWN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbfH1AAoJEMDTa8Ir7ZwVqM8P/2IrE72caY22/7YlveONt90R
9oWzi9yQbjA4/8xku1Ac98t46ylU2OWG8yJDz/KiyNi5zmTW6V6WvL8luEUSzXbA
vZzfaCurupfWknF0vpri20QYJF/UcrXHpgIn+Ott0/nk05dGocTnyTFpRzfmNIIe
DVeNE/yy5Hh/R5hwiF3Sa2J4LK0q7tsxLzIwoHJ0+EcQZc8Q7CyuCZ8Sb3x0mPT9
iLNNwpfxDUERX5Diw1w5lHPkpTyNADaPRR1hCVRcQbwcFQjZGZJ5uGPgh0bF1E4y
MVSggJBMsP5Sg1b+MM7zjwj8ysx/wm7I///aRZvmZFHIdKWnUxtTn5joHl9DMM+M
qkVTujqLdkt+iH2wLwpKpWOmBoCnt97lCHq3lHQ+/l2idjFalgosbfb6E/55upa3
i0unPYkkBr+TyzJMy12weRdzW8gezycwfOceiLiLoeRSW78EIsLdTVYVi3EOeqNZ
l5DxiqGjPR1neg/pHsm6QZ3jCxhNVevD0w+d3p9sGcPEGR4GfuVjhbCBxLsgOPXJ
oVJS9guanIDL7Vpfagu1lMr1IIwlNnul6gmF59jnn0NfCTV2/TY7MURaTIIncPtB
cnKj8+ea0JlM/wKPY7dPsnmmayMsQJnoXzq9bsssOQRzIbFQC53SHB+MHDjymbab
m7g2FZaO8yc+uvvqJ0Sl
=nRj0
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Oct_2013_16_11_12_+1100_fHtOfGffAl8QdIWN--
