Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab3LMA7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 19:59:04 -0500
Received: from ozlabs.org ([203.10.76.45]:33248 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab3LMA7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 19:59:01 -0500
Date: Fri, 13 Dec 2013 11:58:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>
Subject: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-Id: <20131213115854.5f103f7b91aefd3e65ad5ae6@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__13_Dec_2013_11_58_54_+1100_1x57eyI+jz0TnAHL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Dec_2013_11_58_54_+1100_1x57eyI+jz0TnAHL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_ddi.c between commit 76bb80ed3027
("drm/i915/ddi: set sink to power down mode on dp disable") from Linus'
tree and commit dff392dbd258 ("drm/i915: don't touch the VDD when
disabling the panel") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_ddi.c
index 526c8ded16b0,cec06a5453cc..000000000000
--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@@ -1158,10 -1235,9 +1235,10 @@@ static void intel_ddi_post_disable(stru
  	if (wait)
  		intel_wait_ddi_buf_idle(dev_priv, port);
 =20
 -	if (type =3D=3D INTEL_OUTPUT_EDP) {
 +	if (type =3D=3D INTEL_OUTPUT_DISPLAYPORT || type =3D=3D INTEL_OUTPUT_EDP=
) {
  		struct intel_dp *intel_dp =3D enc_to_intel_dp(encoder);
- 		ironlake_edp_panel_vdd_on(intel_dp);
+=20
 +		intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_OFF);
  		ironlake_edp_panel_off(intel_dp);
  	}
 =20

--Signature=_Fri__13_Dec_2013_11_58_54_+1100_1x57eyI+jz0TnAHL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSqlvSAAoJEMDTa8Ir7ZwVY+QP/jJGQUI6cutH0UaqxMO8FCZ3
wTsFbWq7mG/zOGdBZIMMn3IvWyPTvNDg+EHYhPinROotsHKY65kazmEpYex9pNeL
SldgK9XWboVnCLEyGwEsPjRJYfS8qEc++ceBqXxBGkDWkvzgcKg32lx7pAkomjBz
4xj1PNbtiE+3Sb4yKXDdBb+vrPidqmBRQhZBAwHWj/5xHCr4QgqpvT0S7/J1DoGT
QBfANEROwrUq75T07+Q5tcZ0xQJV53BFtckMmWV2RVVq8Zf/Nr/20tlLremKV0pc
IAcaeWessAzwoFPfwLSqLQ79FBuQETEg3DmZ0EBQeRdJBTKcLjZ+vYW/flDyA1yQ
3PZ3WMBBHh2Tnwm8zx9l98jZzhvTnzCvLMGXK/Sng6KPzHZOOWQM0qwV8XgBfAUO
LfBSY9FdD0aElZgo+Mms+GZtBM0Wu+3rmd1Dm3MX7BXvEkJOwzMv/YKs1dkZpQJR
mrceQJl5N2YXB3Sdq882HMNh4HrpZg2IpqAQfNEggXEhDHonpvONfIojrMvBrFbW
iaSm2baIM9MEc7Yc9MNCsVYh38/EWClw8FS7hlxEx2YgdoE4qUWOrCk5b0bwYCdU
m6qpw1DkNyUkTvFoOvZ2XIvH1NaEDo1hZJmlko8xeYkxqe4dp33AWHG71IRWR+uM
F+SM8hxOJMItFN3f0b9M
=FHKI
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Dec_2013_11_58_54_+1100_1x57eyI+jz0TnAHL--
