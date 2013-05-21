Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab3EUB6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 21:58:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47598 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab3EUB6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 21:58:19 -0400
Date: Tue, 21 May 2013 11:58:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-Id: <20130521115811.aa350c0edc6a9065adbf5852@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__21_May_2013_11_58_11_+1000_nybcUPoT4S5fC30o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_May_2013_11_58_11_+1000_nybcUPoT4S5fC30o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_dp.c between commit 657445fe8660 ("Revert
"drm/i915: revert eDP bpp clamping code changes"") from Linus' tree and
commits c6bb353815c3 ("drm/i915: move dp clock computations to
encoder->compute_config"), af13188a1a66 ("drm/i915: force bpp for eDP
panels") and 52541e30339d ("drm/i915: allow high-bpc modes on DP") from
the drm-intel tree.

I fixed it up (see below and I used the latter two commits instead of the
one from Linus' tree) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_dp.c
index 3d704b7,2bb4009..0000000
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@@ -755,6 -782,10 +783,8 @@@ found
  			       target_clock, adjusted_mode->clock,
  			       &pipe_config->dp_m_n);
 =20
 -	pipe_config->pipe_bpp =3D bpp;
 -
+ 	intel_dp_set_clock(encoder, pipe_config, intel_dp->link_bw);
+=20
  	return true;
  }
 =20
@@@ -1379,8 -1400,15 +1399,16 @@@ static void intel_enable_dp(struct inte
  	ironlake_edp_panel_on(intel_dp);
  	ironlake_edp_panel_vdd_off(intel_dp, true);
  	intel_dp_complete_link_train(intel_dp);
 +	intel_dp_stop_link_train(intel_dp);
  	ironlake_edp_backlight_on(intel_dp);
+=20
+ 	if (IS_VALLEYVIEW(dev)) {
+ 		struct intel_digital_port *dport =3D
+ 			enc_to_dig_port(&encoder->base);
+ 		int channel =3D vlv_dport_to_channel(dport);
+=20
+ 		vlv_wait_port_ready(dev_priv, channel);
+ 	}
  }
 =20
  static void intel_pre_enable_dp(struct intel_encoder *encoder)

--Signature=_Tue__21_May_2013_11_58_11_+1000_nybcUPoT4S5fC30o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRmtSzAAoJEECxmPOUX5FEr5EP/RABQ4JPctaO6jIrpajzMBHt
7SHcA15erG3en8m1hxpwz1Lh5wjTT2NduAe9608mVgu1XiWGVtMtRAJdT/LyIblt
uaPRAt1th3TfyoVQwdE9H+xxNLjbN+zURN1xPxvqIf/fdWF4GGVi0fzpvcwbKSQ3
iOYntEZxfHX4EkvoVnUgEcqrv4xIUsyP1S8aDux0777p9DJERJQjraMgkbWny2qB
BsynJ4SWyBFaVfECQSAXt6pgoSQk9PzjNC6gqoPFRE6MaPf7AFDdoAC3OX8dbKQH
U1JwUBYO83yVqanTjQwCunW+MR9uxvMoG5VC3/1Ej6cThLrrgb7M+A7moBRGmj5X
f722LgKcd0u74IYsF0XJ46qYY3lAhB/Fgl2KX5n1B39bZfarcMNVnRS7XMxOFy8P
NV4U2VI3unWx4mpcOjafTTEKt8QH3lcWc3W6QyShZTlh90rdt0XQeSd8bwvAZAJm
trp55i6p6Ik+H3IdkFpsYl7nkeDDxn4fdPJl/wI0mAJPcgd3HE9leYGAodm1L7wH
geHe4IeGG0hcnr5LJF9udANTh1HTZFGD4X/4mfxmXyZkwGqiSYlevRWLvJMoEJYp
I1ogBO1MkXd4J+T2chDE2U+K4ImDJAu43FpHtLTOu4eAHH8qTGoD3GsgLBzTgFDp
FnPrkPEJpIuIzA5Rjp+x
=ry9I
-----END PGP SIGNATURE-----

--Signature=_Tue__21_May_2013_11_58_11_+1000_nybcUPoT4S5fC30o--
