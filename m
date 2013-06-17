Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3FQDc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:32:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34337 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab3FQDc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:32:56 -0400
Date: Mon, 17 Jun 2013 13:32:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-Id: <20130617133253.f59c0b9a1721111a8e3c75e3@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_13_32_53_+1000_tp2pf6IzJ=fGZHzr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_13_32_53_+1000_tp2pf6IzJ=fGZHzr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_sdvo.c between commit 7ba220cec0bb ("drm/i915:
Enable hotplug interrupts after querying hw capabilities") from Linus'
tree and commit e596a02ccfc6 ("drm/i915: Remove dead code from SDVO
initialisation") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_sdvo.c
index 7d31165,b8e1623..0000000
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@@ -2850,18 -2889,12 +2891,6 @@@ bool intel_sdvo_init(struct drm_device=20
  		}
  	}
 =20
- 	hotplug_mask =3D 0;
- 	if (IS_G4X(dev)) {
- 		hotplug_mask =3D intel_sdvo->is_sdvob ?
- 			SDVOB_HOTPLUG_INT_STATUS_G4X : SDVOC_HOTPLUG_INT_STATUS_G4X;
- 	} else if (IS_GEN4(dev)) {
- 		hotplug_mask =3D intel_sdvo->is_sdvob ?
- 			SDVOB_HOTPLUG_INT_STATUS_I965 : SDVOC_HOTPLUG_INT_STATUS_I965;
- 	} else {
- 		hotplug_mask =3D intel_sdvo->is_sdvob ?
- 			SDVOB_HOTPLUG_INT_STATUS_I915 : SDVOC_HOTPLUG_INT_STATUS_I915;
- 	}
-=20
 -	/* Only enable the hotplug irq if we need it, to work around noisy
 -	 * hotplug lines.
 -	 */
 -	if (intel_sdvo->hotplug_active)
 -		intel_encoder->hpd_pin =3D HPD_SDVO_B ? HPD_SDVO_B : HPD_SDVO_C;
 -
  	intel_encoder->compute_config =3D intel_sdvo_compute_config;
  	intel_encoder->disable =3D intel_disable_sdvo;
  	intel_encoder->mode_set =3D intel_sdvo_mode_set;

--Signature=_Mon__17_Jun_2013_13_32_53_+1000_tp2pf6IzJ=fGZHzr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvoNlAAoJEECxmPOUX5FEQLAP/jZ/KeVgqbQxN8AS3Jpljvlz
NggKZwcThHF0KsMUer2vQ1qjt9u2z/ATvpk9y9DgLU9/nZhAoluUpkSC1nIFAjDM
s0ypTj8ESqrBmCr1PE4mr8/Ksu8VZvU3Xs9WkKbEe89Y780XJmHDSftphkFa68zU
y8Do7CBt2fnVh+zIvFJwyulZaI76fgB8oZUUVDSqfn5WWylj4+s4SqjyxDRicsUV
ixI4p26rwoOw/hMXRqFr7aqC3tzE+9M8dakpc9LJlCYqAc9LRPqy3g//yiXexScB
BMSxIAmFWtYVJXabgi85MeCCWevbUOyi8wtt+QeX0dmTl3Wnus9tkI/vmxtSopQ+
yi+3A9sTKy2E0kTQxPWPOBEydp4/PCzNsRmS5vJh38QJTFvdgZt7JE3wGk3W0FVL
uqGTc6HjkqH8hZM4S702UNzScQCVY2v8D+VuSJHjucc9lABcrih8BfH8q6RsR3jm
PzbdbjRJb6PqzYIL81aL/a2yTiv/Cad6ScubMK1cOZShvGAkkFB9SSnmvIQU5I4o
ynpl+yYLAqhZkkrW2k9ULOAaKMGIHt4h9ySymaa/7WuZM/7WqvRv47JJjNs9+esQ
TC+Bj9MmrVQSaDf/Pp7peLO89G/t0wJ3x307yU7S7pc6v2bT/L5vSzXiKqZSnASZ
GOe6arGQaOKv0jMHR/Y2
=c3/5
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_13_32_53_+1000_tp2pf6IzJ=fGZHzr--
