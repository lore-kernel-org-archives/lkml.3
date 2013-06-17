Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab3FQDZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:25:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33306 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab3FQDZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:25:45 -0400
Date: Mon, 17 Jun 2013 13:25:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-Id: <20130617132537.430b7875a3600a9cbd0f7ad5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_13_25_37_+1000__HnnVMRg6r7J7qq9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_13_25_37_+1000__HnnVMRg6r7J7qq9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commit d62cf62ad07d
("drm/i915: Quirk the pipe A quirk in the modeset state checker") from
Linus' tree and commit 6c49f24180c3 ("drm/i915: hw state readout support
for pixel_multiplier") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_display.c
index 6eb99e1,218bc93..0000000
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

--Signature=_Mon__17_Jun_2013_13_25_37_+1000__HnnVMRg6r7J7qq9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvoG0AAoJEECxmPOUX5FEQCMP/2pvSBjpmqDJyNlYspumm027
wJ93PW3JPSfV/CGQFtWFoeXJj71nnkuePQEl9K+iVvxWgRc7VppfuTaycICxXL2T
2bINIXaXinVQeXLZa/O+w4gmuvzoqWXW2o5eNBV4QXqJjQzfBkuugKX66QzyHTSW
9ocowNL6cn1IXX0yFaa+HBjf+hFd1yOjmFy+ONSi/AZtl9Tjqqox/+y1XJYg/cct
UrK7bAiRzFa8wozpjyVL4rwBbBd6UOBxC1jck9avT/vot1wa8pvTRE3l3qQeEP9N
oKtIIg7PO6cBN5Cb5Jikcd+bVY2uWhsDlmpBGFYvnXSpGM6v+43oAo5BOxO4Hnhj
wLZYrfofRf76AqyPc3jtUrQD/8vG/pgXIt0vwvKX1zmxOq0NBrAIj2qbpKdTa6iF
G84XIj+ZdkfipDo6u2iX86EGHwOpF20fSTpUJ1NcFXAZ++nY7quFFNeNpa+a+pxd
//dJjAQi/IPOe6ey6THJBPDpEJQStC3i2Kr2jVyPdyKXcgeQ31rkzdQ1zEzSUc8O
onsFKs4+f1Nvr1pMsSJX/hTGRxpMmGOXPbE1g5CzfXKPSw35LlY92CUBnrumAv/3
z0PAh2SOcC8CimCns3qXwh0wi71xksASIq0hkSh7SqwsK8cZUjBluFpKXU89vDB1
IlaFq68s2oEGdpO5CbKx
=PTo0
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_13_25_37_+1000__HnnVMRg6r7J7qq9--
