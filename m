Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaIHEdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 00:33:06 -0400
Received: from ozlabs.org ([103.22.144.67]:47786 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaIHEdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 00:33:03 -0400
Date: Mon, 8 Sep 2014 14:32:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-ID: <20140908143256.44287543@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/zQVrlaIBdQkcJy97TsNCh/I"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zQVrlaIBdQkcJy97TsNCh/I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commit a4bf214ffc72
("drm/i915: Move intel_ddi_set_vc_payload_alloc(false) to
haswell_crtc_disable()") from Linus' tree and commit 575f7ab754c4
("drm/i915: Pass intel_crtc to intel_disable_pipe() and
intel_wait_for_pipe_off()") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_display.c
index 18da8349a070,b912107a1392..000000000000
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@@ -4168,7 -4253,11 +4264,7 @@@ static void ironlake_crtc_disable(struc
  	if (intel_crtc->config.has_pch_encoder)
  		intel_set_pch_fifo_underrun_reporting(dev, pipe, false);
 =20
- 	intel_disable_pipe(dev_priv, pipe);
+ 	intel_disable_pipe(intel_crtc);
 -
 -	if (intel_crtc->config.dp_encoder_is_mst)
 -		intel_ddi_set_vc_payload_alloc(crtc, false);
 -
  	ironlake_pfit_disable(intel_crtc);
 =20
  	for_each_encoder_on_crtc(dev, crtc, encoder)
@@@ -4231,11 -4319,8 +4326,11 @@@ static void haswell_crtc_disable(struc
 =20
  	if (intel_crtc->config.has_pch_encoder)
  		intel_set_pch_fifo_underrun_reporting(dev, TRANSCODER_A, false);
- 	intel_disable_pipe(dev_priv, pipe);
+ 	intel_disable_pipe(intel_crtc);
 =20
 +	if (intel_crtc->config.dp_encoder_is_mst)
 +		intel_ddi_set_vc_payload_alloc(crtc, false);
 +
  	intel_ddi_disable_transcoder_func(dev_priv, cpu_transcoder);
 =20
  	ironlake_pfit_disable(intel_crtc);

--Sig_/zQVrlaIBdQkcJy97TsNCh/I
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDTF9AAoJEMDTa8Ir7ZwVAYsP/jQSU6CLjgJq5ENoUMBve22n
ZgRaqPZUap8VUGGjSSlBWig9Sh41LEFZTc8B3b+yXC+hRCNLJfVlNdMnmnRq3+OP
YHIW/cAWFKYQqE//jh2epIdNOZ5ndjvJDXpMC0II6kmLjE5xQ3NrYqO9EjRnHhA1
1Hb+WNHtesVR+V708A/r1ydrPZMiSOUdzEv3FpVVSh2NRcossrq8uzKwI1ptOUTp
ilGBNV17BplubGC/HC3lRgON40DS8SA9SHv//ppAfVdLn5G4sQtiv1c6Ho15DSVN
CEln8TRJXDGcYq0kT3qWl1TW0VOEVo0WcbAEgJhXz53gGmPw1WvB4uEVTXLvkqpC
s8dvso3ofE9HZeMrmAkyJIMKlZ6zlsTecsPmrHWwwc0/mPF6EZB+1r3ie49Aqj/r
rmGSEDJ/UJGY+f3uj138MNsjJj7PfXEbBuCdIR+tIwFNAs2t+Il6g9MBIzD7ygg+
s9fOKq2xbsJehRQli3K88nbisKP3QhAz9BSaSd9oTaQqgUkqWmPyrojTipQlNfkM
MgSj5Y5+W5nfq7BcWF3GlWSY7IKfiDg3fJERkuScs3WqWPLTlOc8KbhtwskIoPg5
h50Ukpw5rc+gQDgg7PWb7qafCBrU/tXQBgfVH5UOwEsAYIcZX6WbMU9n0TvTrgaJ
5u8oRwOrky4Pi2iVCccV
=UeSY
-----END PGP SIGNATURE-----

--Sig_/zQVrlaIBdQkcJy97TsNCh/I--
