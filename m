Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3JDVDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:03:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34472 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab3JDVDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:03:33 -0400
Date: Fri, 4 Oct 2013 22:02:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Ben Widawsky <benjamin.widawsky@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Message-ID: <20131004210250.GV27287@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HEWbDiF3bQmv4WB2"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Conflict in merge of the the drm-intel tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HEWbDiF3bQmv4WB2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

While merging the drm-intel tree into -next there were conflicts in
drivers/gpu/drm/i915/intel_dp.c between 0cc4b69960 (drm/i915: Mask LPSP
to get PSR working even with Power Well in use by audio) in the drm tree
and 18b5992c37 (drm/i915: Calculate PSR register offsets from base +
gen) from the drm-intel tree.

I've fixed this up as below:

diff --cc drivers/gpu/drm/i915/intel_dp.c
index bc6579e,0f77b8c..0000000
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@@ -1549,8 -1558,8 +1558,8 @@@ static void intel_edp_psr_setup(struct=20
  	intel_edp_psr_write_vsc(intel_dp, &psr_vsc);
 =20
  	/* Avoid continuous PSR exit by masking memup and hpd */
- 	I915_WRITE(EDP_PSR_DEBUG_CTL, EDP_PSR_DEBUG_MASK_MEMUP |
+ 	I915_WRITE(EDP_PSR_DEBUG_CTL(dev), EDP_PSR_DEBUG_MASK_MEMUP |
 -		   EDP_PSR_DEBUG_MASK_HPD);
 +		   EDP_PSR_DEBUG_MASK_HPD | EDP_PSR_DEBUG_MASK_LPSP);
 =20
  	intel_dp->psr_setup_done =3D true;
  }

--HEWbDiF3bQmv4WB2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTyz3AAoJELSic+t+oim9XvoQAJalqkcwvndjvAkGbdmoxNE+
o/C4lVXHKoKypnbqNmNhGgeZxzebdgt1cdLDU3TFUbsQiVNWQeqe8fIezPYDH/wR
N52a544aZq9Oic6DAft28Hrq3uCcqpigFwtKuxclwyHhYMnzbU/8R/PFa4zk2JT0
DVqXLkqV0FO4f7D//HupZICp/ywacfRDpYENeZFJ32FLYUNeS1pQ1QE5lDtTfSRp
+5uZyyJXTeKUv1ImNnAGnV4DcC9FitmSZORbqdBkdmGndxIwdw6YScC5rmqF9VkW
uEz6rRdWXTowXgqZb3JOOqOf2PUiA4fIYsNMCZM67y+a9txzL9EcbPaVrlsN9gUw
TykYumeFCiFWbxN6yGopgyRmXenqx2LB+wIN+KyJk1JN+VcknW7R2RDCsC5svYZa
AU1FaHdEaQoIuZv9223ZmOt3LXFZJP+Gj/Jb13iS2ydKKsWF3NRjZA85ULT69+U9
M0vKpm12Pcxiq6w4SsGfwOfeNrjjJxsP2TpazxTJMdXdqW7MQDIjVRJer2Ha7JzK
4hHTlRwzkrA36WEUGpBIC5S1qoi51SRuQFt/5bW0mqyIcA1jvKG5ONuLUnfinWnQ
mHx+rR8G349rgPtCTkGxjSsh+31yLUXaKLRi8IcPj0onHg7VtqQXlOcTGs8MOvMo
FlMtmljakbe6GltUbKyt
=b/f+
-----END PGP SIGNATURE-----

--HEWbDiF3bQmv4WB2--
