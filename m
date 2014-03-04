Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbaCDXVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:21:17 -0500
Received: from ozlabs.org ([203.10.76.45]:60554 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbaCDXVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:21:15 -0500
Date: Wed, 5 Mar 2014 10:21:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20140305102109.948255688bc31a030fdd49d7@canb.auug.org.au>
In-Reply-To: <20140305101627.1d9e3a0941dbadbc6f0a7733@canb.auug.org.au>
References: <20140225133537.55ce6935e55faa6aeae53d89@canb.auug.org.au>
	<20140225190715.GA4384@tuxdriver.com>
	<20140226074738.0b530aebe4cde54216698d91@canb.auug.org.au>
	<20140305101627.1d9e3a0941dbadbc6f0a7733@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Mar_2014_10_21_09_+1100_Git=hAb.29m4Sah1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Mar_2014_10_21_09_+1100_Git=hAb.29m4Sah1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Wed, 5 Mar 2014 10:16:27 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> If I revert commit 161d78555435 "Revert "Staging: rtl8812ae: remove
> modules field of rate_control_ops"", it fails differently:
>=20
> In file included from drivers/staging/wlan-ng/p80211netdev.c:91:0:
> drivers/staging/wlan-ng/cfg80211.c: In function 'prism2_scan':
> drivers/staging/wlan-ng/cfg80211.c:419:10: error: implicit declaration of=
 function 'ieee80211_dsss_chan_to_freq' [-Werror=3Dimplicit-function-declar=
ation]
>           ieee80211_dsss_chan_to_freq(msg2.dschannel.data)),
>           ^
> drivers/staging/rtl8821ae/rtl8821ae/trx.c: In function 'rtl8821ae_rx_quer=
y_desc':
> drivers/staging/rtl8821ae/rtl8821ae/trx.c:619:3: warning: passing argumen=
t 1 of 'ieee80211_is_robust_mgmt_frame' from incompatible pointer type [ena=
bled by default]
>    if ((ieee80211_is_robust_mgmt_frame(hdr)) &&
>    ^
> In file included from include/net/mac80211.h:20:0,
>                  from drivers/staging/rtl8821ae/rtl8821ae/../wifi.h:38,
>                  from drivers/staging/rtl8821ae/rtl8821ae/trx.c:30:
> include/linux/ieee80211.h:2286:20: note: expected 'struct sk_buff *' but =
argument is of type 'struct ieee80211_hdr *'
>  static inline bool ieee80211_is_robust_mgmt_frame(struct sk_buff *skb)
>                     ^
> drivers/staging/rtl8821ae/rtl8821ae/dm.c: In function 'rtl8821ae_dm_clear=
_txpower_tracking_state':
> drivers/staging/rtl8821ae/rtl8821ae/dm.c:487:31: warning: iteration 2u in=
vokes undefined behavior [-Waggressive-loop-optimizations]
>    rtldm->bb_swing_idx_ofdm[p] =3D rtldm->default_ofdm_index;
>                                ^
> drivers/staging/rtl8821ae/rtl8821ae/dm.c:485:2: note: containing loop
>   for (p =3D RF90_PATH_A; p < MAX_RF_PATH; ++p) {
>   ^
>=20
> So please revert 161d78555435, and then fix this other error.

That fix could be a simple as just disabling the affected staging tree
driver and letting Greg know.  Or you could actually fix it.
--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Wed__5_Mar_2014_10_21_09_+1100_Git=hAb.29m4Sah1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFl/qAAoJEMDTa8Ir7ZwV9rwQAIYXLwCQjarbUuJ7zlRbfCqS
bX+yDRZUBIylFRh4+Ee6znWdnSnUOF0IZ0syfVjIc6TlLJCOLrH3t2TBmJmogR5i
ntmomIpvlu+4nmq3pRsBnjsE+cGxJuHAggJccObIhPHpP1zcQh09/vvnqs0vSJc+
DypYjZMUjw4ky/f1z/b3CgU95IECJ8GAAkut2gFf4DprgEQTqzmO7zN46RT9BjBR
SNUp7Tl5RzP0AcV+Gz4Hf5xZc8Q1OXDpW4ppj/uddFf+unuHySCn2a943DprIJcB
4Yg3WlanpDyMyx/5rZvIQOgeF7cLlN3Q/inuzVS60JpmypxX3yPzihGjp8LHYzT4
Ouq2OjDwBOuk8DJwi7e/4SGf72QyxG/1Mh7E+HeLhCa900zLnmBtW1WHB7ey9hBU
PQA+ZVDDZZ40pIrr/6+3s+GBtTrYrkiSSWj2EuE4WF8YsgfhAdoCbFvCSzXLMuSC
KCwRcxRBCSbaF6zDaSAx/2R35YUcJt3pep0UvoHwVY70Ub87Ww2vNm0n6rq6jpVT
J9jU8JoJtYGWqQj3TblSEhoBCW387jZKxXGIG0Y17CL6hvawU+b7T+rE4yJSFIpl
Onrqd+eWDgNFhVPxLO9o1cwPPyOD4T785TiR9aJvCT9KzVMPg/qcmmOHoxMj2tSk
/+a93Y5EpfxIAme1ZRUB
=aHS2
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Mar_2014_10_21_09_+1100_Git=hAb.29m4Sah1--
