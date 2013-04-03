Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542Ab3DCCoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:44:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56925 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759066Ab3DCCoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:44:01 -0400
Date: Wed, 3 Apr 2013 13:43:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>
Subject: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-Id: <20130403134349.e009a401ab6ec761edbfedd7@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Apr_2013_13_43_49_+1100_N9erHEL0pEpypmp_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Apr_2013_13_43_49_+1100_N9erHEL0pEpypmp_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_panel.c between commit b1289371fcd5 ("Revert
"drm/i915: write backlight harder"") from Linus' tree and commit
31ad8ec6a614 ("drm/i915: group backlight related stuff into a struct")
from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_panel.c
index bee8cb6,0e7e873..0000000
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@@ -318,9 -321,16 +321,13 @@@ void intel_panel_enable_backlight(struc
  {
  	struct drm_i915_private *dev_priv =3D dev->dev_private;
 =20
- 	if (dev_priv->backlight_level =3D=3D 0)
- 		dev_priv->backlight_level =3D intel_panel_get_max_backlight(dev);
+ 	if (dev_priv->backlight.level =3D=3D 0) {
+ 		dev_priv->backlight.level =3D intel_panel_get_max_backlight(dev);
+ 		if (dev_priv->backlight.device)
+ 			dev_priv->backlight.device->props.brightness =3D
+ 				dev_priv->backlight.level;
+ 	}
 =20
 -	dev_priv->backlight.enabled =3D true;
 -	intel_panel_actually_set_backlight(dev, dev_priv->backlight.level);
 -
  	if (INTEL_INFO(dev)->gen >=3D 4) {
  		uint32_t reg, tmp;
 =20
@@@ -356,12 -366,12 +363,12 @@@
  	}
 =20
  set_level:
 -	/* Check the current backlight level and try to set again if it's zero.
 -	 * On some machines, BLC_PWM_CPU_CTL is cleared to zero automatically
 -	 * when BLC_PWM_CPU_CTL2 and BLC_PWM_PCH_CTL1 are written.
 +	/* Call below after setting BLC_PWM_CPU_CTL2 and BLC_PWM_PCH_CTL1.
 +	 * BLC_PWM_CPU_CTL may be cleared to zero automatically when these
 +	 * registers are set.
  	 */
- 	dev_priv->backlight_enabled =3D true;
- 	intel_panel_actually_set_backlight(dev, dev_priv->backlight_level);
 -	if (!intel_panel_get_backlight(dev))
 -		intel_panel_actually_set_backlight(dev, dev_priv->backlight.level);
++	dev_priv->backlight.enabled =3D true;
++	intel_panel_actually_set_backlight(dev, dev_priv->backlight.level);
  }
 =20
  static void intel_panel_init_backlight(struct drm_device *dev)

--Signature=_Wed__3_Apr_2013_13_43_49_+1100_N9erHEL0pEpypmp_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRW5dlAAoJEECxmPOUX5FEZLgQAJBQT2X7MKrbQSxU3986/Y6f
WepYxMTnDv0acaJRf/78cYEz+JIpV428pLYqjg6W4SAIUixVE0PlHuCSc2s9E8/X
gOBOqMTUram5odiaD9XqbXdlhwwSL3yYfNWeSAybtFLAq0A4ICTHrb4JeImcrCwx
0DCo6NI6RXaHkGuiST2dFDUtVlIzHoDAFQrPVLI3sr5FlKKH9LZOBSaOT5KCTLGd
HPS0SVJTmsFDzcpzDm/IRiZXAlRAoNP7Uxv2oAUkZf5EteeJUY8J0RfAaFVfMI3Q
gdWv1k3xejr0s2GVsy5tpTAN9ih6BVG2eAwR+N597aFrzvx8yC4ytURNvB6xw0/V
HznVwRTKEp2X5oQeWJj/272r513nyPTN7r6QnTjkZayG6Hr2A+FfzT3dHKekd8xB
cAkE4NiTQY+5wRwgTh9K31gqLKW0g4xp2Vl3+cVowvGRZPHMlVzjp/rBw/NPVx6S
BXdqERzKS66303e2n950VRXMzgQLm7MyxQjnKJFkyGJq/bdNGNwO5V0ttFom5Hj0
ur/UiCusKfz+M4VqKIA1pcGhNsssGHkgg7xiFKKYpD9dISEgYusMmkAko0AjuI9Q
oNvfuBrSGdrceiuMM8hpPFCQZB8Mj7JOb5hFtK+AVo2AXGYb7ZQ5SdiUdqMGepmp
7HY/vDnw2yBJafZcTAxd
=Yymz
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Apr_2013_13_43_49_+1100_N9erHEL0pEpypmp_--
