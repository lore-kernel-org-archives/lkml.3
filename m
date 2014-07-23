Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaGWDGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:06:51 -0400
Received: from ozlabs.org ([103.22.144.67]:33835 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815AbaGWDGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:06:49 -0400
Date: Wed, 23 Jul 2014 13:06:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borun Fu <borun.fu@intel.com>, Sagar Kamble <sagar.a.kamble@intel.com>
Subject: linux-next: manual merge of the drm-intel tree with the drm tree
Message-ID: <20140723130641.480be385@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/p3AIIOIk1oU0mWO7uFkJ1Kq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/p3AIIOIk1oU0mWO7uFkJ1Kq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commit d05410f9a450
("drm/i915: split conversion function out into separate function") from
the drm tree and commit 6b09e72050b4 ("drm/i915: Power gating display
wells during i915_pm_suspend") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

P.S. Daniel, that drm-intel tree commit has no Signed-off-by from its
author ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_display.c
index a5af732b87b8,1389d8a30f0a..000000000000
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@@ -4314,27 -4300,6 +4314,23 @@@ static void i9xx_pfit_enable(struct int
  	I915_WRITE(BCLRPAT(crtc->pipe), 0);
  }
 =20
 +static enum intel_display_power_domain port_to_power_domain(enum port por=
t)
 +{
 +	switch (port) {
 +	case PORT_A:
 +		return POWER_DOMAIN_PORT_DDI_A_4_LANES;
 +	case PORT_B:
 +		return POWER_DOMAIN_PORT_DDI_B_4_LANES;
 +	case PORT_C:
 +		return POWER_DOMAIN_PORT_DDI_C_4_LANES;
 +	case PORT_D:
 +		return POWER_DOMAIN_PORT_DDI_D_4_LANES;
 +	default:
 +		WARN_ON_ONCE(1);
 +		return POWER_DOMAIN_PORT_OTHER;
 +	}
 +}
 +
- #define for_each_power_domain(domain, mask)				\
- 	for ((domain) =3D 0; (domain) < POWER_DOMAIN_NUM; (domain)++)	\
- 		if ((1 << (domain)) & (mask))
-=20
  enum intel_display_power_domain
  intel_display_port_power_domain(struct intel_encoder *intel_encoder)
  {

--Sig_/p3AIIOIk1oU0mWO7uFkJ1Kq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTzybGAAoJEMDTa8Ir7ZwVbcsP/0x+/eC5TlJHspRGyvhY7HjW
ktglRuCJlLnC5PZ7KatVJHTSF9bzmkgqOy1W/YqS0PLcRQ4HnVXc0B3DsDxaizVm
ue3K4tdmtzIATKMk35iqtv8yW3aVNmMz4OYf67uP28s3SXxzGF36/CLaSH78Nq5E
DeWEsVkLxVOFDCGB3eVIy07HKT3VBkPn+WW25Uki4r+NUAMw7Cyej2AbBFmEXn4r
An4opXTL7J3zIdsAeccN4sV3rb8dVCzl749i3n9BmPAdqdKmjUSIwBzo0NPPvIxg
sQuQ1SbAxpvrEFl/L+eyfyN6FeTkR2oHXzoaRK4NxISKArVLX0HWKsF35XDIgoVV
4Z7MbM8XGGJzCfmpsYwMlMxvosih1ZrzlOs/8MRwa3J/LUVjbkjNWD78iHW2HwVv
/27OODoewMgF+47ruuAsUxPu1+z8sYICY+xdOCXBcoyZzixMPUYKIMw58JiUxlM9
iZN3c6vzuZReyE6S0pGvSmPM/64EdZYuy52VCN8QmpXfA/C+t8GsTSI4b0SDwNxp
m/XiurdNiFftYW6a5UHx15pNzf6BKoR8rjef4iVEMv70eDD6c9l3bo3c97Uu/UVX
XyU5EUd97EokFjQV0cunM3zeQ20Q1F+FgxBWPwS/9dCK90BmR1oJ7DCroyR+do8j
20VJ5dkCa82YnT2Yffdp
=9LdS
-----END PGP SIGNATURE-----

--Sig_/p3AIIOIk1oU0mWO7uFkJ1Kq--
