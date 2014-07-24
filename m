Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446AbaGXIm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:42:29 -0400
Received: from ozlabs.org ([103.22.144.67]:57311 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934229AbaGXIm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:42:26 -0400
Date: Thu, 24 Jul 2014 18:42:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>, Mark Brown <broonie@linaro.org>
Subject: linux-next: manual merge of the akpm-current tree with the arm64
 tree
Message-ID: <20140724184219.58c15517@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/LA8C=k9K0=ydF2CM.h_t+yV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LA8C=k9K0=ydF2CM.h_t+yV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/arm64/Kconfig between commit affeafbb8477 ("arm64: Remove stray
ARCH_HAS_OPP reference") from the arm64 tree and commit 0941368c8dd9
("lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual Kconfig") from the
akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/Kconfig
index 555ad3cf3f0f,7bc7b7445774..000000000000
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@@ -1,6 -1,8 +1,7 @@@
  config ARM64
  	def_bool y
  	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 -	select ARCH_HAS_OPP
+ 	select ARCH_HAS_SG_CHAIN
  	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
  	select ARCH_USE_CMPXCHG_LOCKREF
  	select ARCH_SUPPORTS_ATOMIC_RMW

--Sig_/LA8C=k9K0=ydF2CM.h_t+yV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0MbwAAoJEMDTa8Ir7ZwVO4IP/jWekQYUD5k+Lti6HxUevTBf
ugfApCsB2UKld4IL/VLMStqb/9/HweogfHAW7sMW234dlDKeXkDqqokI6qIPiS16
EanGI/h4cYc9IuBib0iyrYx19WK1QZQuPulGeVc4ehp3t5fEe+8F7UEgM+E4JhIl
PcODwvFaGB4I6bs3ZAMnfX/Ynj50rke/4OydNttQ16+5LX8t5H+Xj/5LgD7TX7Hn
elDACDxR3dlgV7LBywP8+Mjn5yqYSe8ekvhvOoP/uGgOujmvzbfYO9JuPOe7t4nc
Wj4pc2wINbP1xStUbktihFDi3fGhr2myb1xAgidUryKoobGXLa7zwh7v0qodmLQ5
2PDR8cprg/0BlOHwsu/e58d13OudJAYgmRJmTaWx6sSwpnKHybq6BiO7NQdMtoAd
EDZx+TSRg7nRryJX3MpB9Tv+KZuMXVIBEKkZPbhhNabtDjrJuBjNrlVk965UJgs2
zfLePvTADHgDgoDGE9BY2y8NU2YxUd3VKtPl19fonZE/kG6B/rHUHmJKUE9htwWT
ao0AuOhcuBpmrsl83HwHGKH2dGNHx2htA8O3ZT3iP8MnQQXBpybiKuGUV2JqJB33
shvELcgVuOsvtA8n8fxFR3VAZGe+AfBumgvx26XL5BzV1wBZ2GwVok4R+L5pbnWV
CTv6kq9qmZGhaJG+bvRN
=eamx
-----END PGP SIGNATURE-----

--Sig_/LA8C=k9K0=ydF2CM.h_t+yV--
