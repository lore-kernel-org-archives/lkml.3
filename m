Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab3FZDzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 23:55:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47516 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3FZDzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 23:55:10 -0400
Date: Wed, 26 Jun 2013 13:54:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-Id: <20130626135458.fa65dac429e9c1c04c6e48d4@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Jun_2013_13_54_58_+1000_lqnXlBsD5_qgfzx7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Jun_2013_13_54_58_+1000_lqnXlBsD5_qgfzx7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commits 2d05eae1c92f
("drm/i915: Propagate errors back from fb set-base") and d62cf62ad07d
("drm/i915: Quirk the pipe A quirk in the modeset state checker") from
Linus' tree and commits 6c49f24180c3 ("drm/i915: hw state readout support
for pixel_multiplier") and 9222be993921 ("drm/i915: don't scream into
dmesg when a modeset fails") from the drm-intel tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_display.c
index 6eb99e1,8f746d9..0000000
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@@ -8177,11 -8264,14 +8264,19 @@@ check_crtc_state(struct drm_device *dev
 =20
  		active =3D dev_priv->display.get_pipe_config(crtc,
  							   &pipe_config);
 +
 +		/* hw state is inconsistent with the pipe A quirk */
 +		if (crtc->pipe =3D=3D PIPE_A && dev_priv->quirks & QUIRK_PIPEA_FORCE)
 +			active =3D crtc->active;
 +
+ 		list_for_each_entry(encoder, &dev->mode_config.encoder_list,
+ 				    base.head) {
+ 			if (encoder->base.crtc !=3D &crtc->base)
+ 				continue;
+ 			if (encoder->get_config)
+ 				encoder->get_config(encoder, &pipe_config);
+ 		}
+=20
  		WARN(crtc->active !=3D active,
  		     "crtc active state doesn't match with hw state "
  		     "(expected %i, found %i)\n", crtc->active, active);

--Signature=_Wed__26_Jun_2013_13_54_58_+1000_lqnXlBsD5_qgfzx7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRymYWAAoJEECxmPOUX5FE79EQAIQ69akBwp08I+wFXaMxNoRf
xtRXzedDZG454HHpyV0G5KOHsqbrfGk+LrbPtWqrjijIuJhECDFLjA9Ud49iC3wh
AwarQ/0anmIoAwgG8xiU5Nk9QWiR+/U0Eb3PiyAuE/q4Xw1O15nmqmuIZ4tf7w8K
CcMCSl0BaDyXj+meol1t3ApLwcP7tcYYGdDNyK/OuY0F9+dBX96FEvWEuMuqMWtD
Nu/qhZvM0OenTQqb1bsT/lnFt7GqRyTlzMmK6Z77So0deVX5KZYxh4kXrae0y816
mHqFjZvzXus4Msf7t6Gyxfz/3medlNihWVvIUDjZzM6FYI3/rjOS3xqjrRIjPbpm
CLCRviqWg7iufgujvAxtVvVqIqINpDvP1Mofua649FuKxx78ibFaEwqAsAdqlOul
taYucL94TdVszJz9qJv9Y40raHUw9v6xC07rno7mKEPU4v3lkeBJVSPlhda2cNVN
rljc/F8mcAIQ0UgkBTzfq2EcTUJ+3rdAlUNKHF1a1ADgi8IUS7yfswxRs9W+OweY
eXh88wlLspzNE63nGco0RFTH46Q97Ld9T0xaR7HK3M+M/KCKQkmuG+wSOmMeUQg5
M+q3/n6KhGXpkY7ucEYNAAP5BxZRqpEug8MAd2zoo9Kd5Mo1FR8fFAppKNIQNnPz
HQGfQwxmcWQR4dC76JfX
=dbqF
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Jun_2013_13_54_58_+1000_lqnXlBsD5_qgfzx7--
