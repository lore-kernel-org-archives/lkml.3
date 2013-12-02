Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab3LBBNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:13:49 -0500
Received: from ozlabs.org ([203.10.76.45]:46258 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab3LBBNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:13:39 -0500
Date: Mon, 2 Dec 2013 12:13:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paulo Zanoni <paulo.r.zanoni@intel.com>, Deepak S <deepak.s@intel.com>
Subject: Re: linux-next: manual merge of the drm-intel tree with the
 drm-intel-fixes tree
Message-Id: <20131202121326.583f55020e627c86d84cabd0@canb.auug.org.au>
In-Reply-To: <20131202120437.db17c98af3f3e09ecdde0f2e@canb.auug.org.au>
References: <20131202120437.db17c98af3f3e09ecdde0f2e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Dec_2013_12_13_26_+1100_LZgMeY39FOm0wAAU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Dec_2013_12_13_26_+1100_LZgMeY39FOm0wAAU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Dec 2013 12:04:37 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the drm-intel tree got a conflict in
> drivers/gpu/drm/i915/intel_display.c between commit a1216444283e
> ("drm/i915: use the correct force_wake function at the PC8 code") from
> the drm-intel-fixes tree and commit c8d9a5905e45 ("drm/i915: Add power
> well arguments to force wake routines") from the drm-intel tree.
>=20
> I fixed it up (I just used the drm-intel-fixes version) and can carry the
> fix as necessary (no action is required).

Actually, I ended up doing the below.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_display.c
index 080f6fd4e839,0332d7ca892d..000000000000
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@@ -6402,7 -6583,7 +6583,7 @@@ static void hsw_restore_lcpll(struct dr
 =20
  	/* Make sure we're not on PC8 state before disabling PC8, otherwise
  	 * we'll hang the machine! */
- 	gen6_gt_force_wake_get(dev_priv);
 -	dev_priv->uncore.funcs.force_wake_get(dev_priv, FORCEWAKE_ALL);
++	gen6_gt_force_wake_get(dev_priv, FORCEWAKE_ALL);
 =20
  	if (val & LCPLL_POWER_DOWN_ALLOW) {
  		val &=3D ~LCPLL_POWER_DOWN_ALLOW;
@@@ -6436,7 -6617,7 +6617,7 @@@
  			DRM_ERROR("Switching back to LCPLL failed\n");
  	}
 =20
- 	gen6_gt_force_wake_put(dev_priv);
 -	dev_priv->uncore.funcs.force_wake_put(dev_priv, FORCEWAKE_ALL);
++	gen6_gt_force_wake_put(dev_priv, FORCEWAKE_ALL);
  }
 =20
  void hsw_enable_pc8_work(struct work_struct *__work)

--Signature=_Mon__2_Dec_2013_12_13_26_+1100_LZgMeY39FOm0wAAU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSm967AAoJEMDTa8Ir7ZwV1XkP/iRnZqH3mLFoASUyOHQQqQkW
m3fyhw8+qMaVqXYzXJh6tM24+NEXmZdZrpyI+5djDcR8lkOzBVfpuBizDQz0u9y0
3lC6B0mr4EVW7igN/9jvroffQ8vXOi+x47ZgAHHXmduf+7+s6wLqK4dPDGKCLgo3
fFvc31lv55iDogIG6WjkCdgI8BDBhSxUCkYLne7eauCYRrTenGhnGjX3bZHCzhzV
ituGTygdY/T5lk2zBt+yHPwxEDHYezgzMUlmzOxXg/fPLEC/JzCeWPY4SiPSPxIK
RhE5xkMNQD2mxzvlr7mnz+5M1emazY4y3cK3gqCO1U3yYtwpNnFO1YDQRPMHsm3s
N2xLPYZYL/es5ku07ERnQSandhPwJJkgOsjd4i5cYYoegnGnICUdorzlR7g/4djH
cz2dmdhCCOFPgED8902RO3I1p7y57hUVBk8lMKTYxJXfsR2Bb6fAAOiDbDCpvcH7
HrQvuipkxagCdXbXwL3eHvWvlTVZcG1BaVeQk3uoKG9Do9aaImbWfo8zVXA0HVWh
HgTskVAXcHWg4oQ/uOmIa0I6SsR4S/dv5Joe02oPxnwrK27U35vVt7+abX1lBKFN
Wsf+DMKMZhyLD6+Ti/xhDOq0cpKToHK2vbgdROmfwkdHRHkOckrCs9srsKUPEXSX
AkYtsibdYEKldZSB1/xI
=qHme
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Dec_2013_12_13_26_+1100_LZgMeY39FOm0wAAU--
