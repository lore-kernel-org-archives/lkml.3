Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3H2EJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 00:09:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53474 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab3H2EJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 00:09:20 -0400
Date: Thu, 29 Aug 2013 14:09:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shobhit Kumar <shobhit.kumar@intel.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Dave Airlie <airlied@linux.ie>
Subject: linux-next: manual merge of the drm-intel tree with the drm tree
Message-Id: <20130829140906.2c4b5dea4453266265018c0b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Aug_2013_14_09_06_+1000_CXyhuRdgVG/puWv0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Aug_2013_14_09_06_+1000_CXyhuRdgVG/puWv0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/drm_crtc.c between commit b21e3afe2357 ("drm: use ida to
allocate connector ids") from the drm tree and commit 88cd8b8b1503 ("drm:
add MIPI DSI encoder and connector types") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).
=20
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/drm_crtc.c
index 54b4169,190827d..0000000
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@@ -186,22 -193,23 +186,23 @@@ struct drm_conn_prop_enum_list=20
   * Connector and encoder types.
   */
  static struct drm_conn_prop_enum_list drm_connector_enum_list[] =3D
 -{	{ DRM_MODE_CONNECTOR_Unknown, "Unknown", 0 },
 -	{ DRM_MODE_CONNECTOR_VGA, "VGA", 0 },
 -	{ DRM_MODE_CONNECTOR_DVII, "DVI-I", 0 },
 -	{ DRM_MODE_CONNECTOR_DVID, "DVI-D", 0 },
 -	{ DRM_MODE_CONNECTOR_DVIA, "DVI-A", 0 },
 -	{ DRM_MODE_CONNECTOR_Composite, "Composite", 0 },
 -	{ DRM_MODE_CONNECTOR_SVIDEO, "SVIDEO", 0 },
 -	{ DRM_MODE_CONNECTOR_LVDS, "LVDS", 0 },
 -	{ DRM_MODE_CONNECTOR_Component, "Component", 0 },
 -	{ DRM_MODE_CONNECTOR_9PinDIN, "DIN", 0 },
 -	{ DRM_MODE_CONNECTOR_DisplayPort, "DP", 0 },
 -	{ DRM_MODE_CONNECTOR_HDMIA, "HDMI-A", 0 },
 -	{ DRM_MODE_CONNECTOR_HDMIB, "HDMI-B", 0 },
 -	{ DRM_MODE_CONNECTOR_TV, "TV", 0 },
 -	{ DRM_MODE_CONNECTOR_eDP, "eDP", 0 },
 -	{ DRM_MODE_CONNECTOR_VIRTUAL, "Virtual", 0},
 +{	{ DRM_MODE_CONNECTOR_Unknown, "Unknown" },
 +	{ DRM_MODE_CONNECTOR_VGA, "VGA" },
 +	{ DRM_MODE_CONNECTOR_DVII, "DVI-I" },
 +	{ DRM_MODE_CONNECTOR_DVID, "DVI-D" },
 +	{ DRM_MODE_CONNECTOR_DVIA, "DVI-A" },
 +	{ DRM_MODE_CONNECTOR_Composite, "Composite" },
 +	{ DRM_MODE_CONNECTOR_SVIDEO, "SVIDEO" },
 +	{ DRM_MODE_CONNECTOR_LVDS, "LVDS" },
 +	{ DRM_MODE_CONNECTOR_Component, "Component" },
 +	{ DRM_MODE_CONNECTOR_9PinDIN, "DIN" },
 +	{ DRM_MODE_CONNECTOR_DisplayPort, "DP" },
 +	{ DRM_MODE_CONNECTOR_HDMIA, "HDMI-A" },
 +	{ DRM_MODE_CONNECTOR_HDMIB, "HDMI-B" },
 +	{ DRM_MODE_CONNECTOR_TV, "TV" },
 +	{ DRM_MODE_CONNECTOR_eDP, "eDP" },
 +	{ DRM_MODE_CONNECTOR_VIRTUAL, "Virtual" },
+ 	{ DRM_MODE_CONNECTOR_DSI, "DSI" },
  };
 =20
  static const struct drm_prop_enum_list drm_encoder_enum_list[] =3D
@@@ -211,24 -219,9 +212,25 @@@
  	{ DRM_MODE_ENCODER_LVDS, "LVDS" },
  	{ DRM_MODE_ENCODER_TVDAC, "TV" },
  	{ DRM_MODE_ENCODER_VIRTUAL, "Virtual" },
+ 	{ DRM_MODE_ENCODER_DSI, "DSI" },
  };
 =20
 +void drm_connector_ida_init(void)
 +{
 +	int i;
 +
 +	for (i =3D 0; i < ARRAY_SIZE(drm_connector_enum_list); i++)
 +		ida_init(&drm_connector_enum_list[i].ida);
 +}
 +
 +void drm_connector_ida_destroy(void)
 +{
 +	int i;
 +
 +	for (i =3D 0; i < ARRAY_SIZE(drm_connector_enum_list); i++)
 +		ida_destroy(&drm_connector_enum_list[i].ida);
 +}
 +
  const char *drm_get_encoder_name(const struct drm_encoder *encoder)
  {
  	static char buf[32];

--Signature=_Thu__29_Aug_2013_14_09_06_+1000_CXyhuRdgVG/puWv0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHslmAAoJEECxmPOUX5FEXbMP/jIG0EMVlIS7RmN4mwHQFACT
5BcOuQMhH2eAU8l3Rnc0LA7BhVKmRunbxYmQQh5ZrmgBLCVFfb/6L/WXzE0D9JsR
dDgWpxx07P/sxJ4wYiKLwUpHvDTHY2TSrqVr+Mn2wGwFAY7ukVOYfW9ehV92F0ib
j1H+oC34nMt/AbNCL8XwMqlJfhgDe6dGnUR8aW5JMhX4MZXGZzS4URyALFYB+aN8
HVqo745Qqd8vKb7/KMWswoWQsfUZGQvd+VQlStwRSuWj/9yomV67WMAeP9mnauCu
QDUn+5zdWCycfEo3EYgzic+/Rx0uGKzGszgktX0QvQXAn1/vmxMncEsiN81DZCKV
UBYW4DWSd5ySj24+45nWBq6ephFlqZj7i767WC9ejzB9UJM+qk2t0tHI0+FrsYMn
Vjldri+cJEFGAO3KFUZogm47oyu+bVafktNP/iXNxqwIsFmGi5R4Jigxj9hPFqf0
06VBr0YCIfTCqHpuc9SiHRJYh+BVBBpVaZl4tjutW4sJiss1XLPL3TQOqwgL5xrL
fKvPB+TfF0Rabme+c1AEq3GRFvadWc88PVT/yXc3J8bAsq0Gxe+YC1pT3ssQll6s
fzK1ispJ01MdAtMvMInARCf3ffVOsMgBrUEn9QHdnZnFtlSfgJ+h7maw/B4h1UyS
HwZ1IeCObqbdI4ZHpYww
=M3pV
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Aug_2013_14_09_06_+1000_CXyhuRdgVG/puWv0--
