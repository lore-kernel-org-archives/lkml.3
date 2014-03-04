Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbaCDXQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:16:36 -0500
Received: from ozlabs.org ([203.10.76.45]:47595 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709AbaCDXQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:16:34 -0500
Date: Wed, 5 Mar 2014 10:16:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20140305101627.1d9e3a0941dbadbc6f0a7733@canb.auug.org.au>
In-Reply-To: <20140226074738.0b530aebe4cde54216698d91@canb.auug.org.au>
References: <20140225133537.55ce6935e55faa6aeae53d89@canb.auug.org.au>
	<20140225190715.GA4384@tuxdriver.com>
	<20140226074738.0b530aebe4cde54216698d91@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Mar_2014_10_16_27_+1100_Zd1AZ/7cMd80YYmH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Mar_2014_10_16_27_+1100_Zd1AZ/7cMd80YYmH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Wed, 26 Feb 2014 07:47:38 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 25 Feb 2014 14:07:16 -0500 "John W. Linville" <linville@tuxdriver=
.com> wrote:
> >
> > On Tue, Feb 25, 2014 at 01:35:37PM +1100, Stephen Rothwell wrote:
> > >=20
> > > After merging the wireless-next tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > >=20
> > > drivers/staging/rtl8821ae/rc.c:289:2: error: unknown field 'module' s=
pecified in initializer
> > >   .module =3D NULL,
> > >   ^
> > >=20
> > > Caused by commit 161d78555435 ("Revert "Staging: rtl8812ae: remove
> > > modules field of rate_control_ops"").
> > >=20
> > > The commit "Staging: rtl8812ae: remove modules field of rate_control_=
ops"
> > > was needed in the wireless-next tree - I said so at the time of repor=
ting
> > > the original breakage:=20
> > >=20
> > > > Actually, your tree is based on -rc2, so you need this patch alread=
y (it
> > > > should have bee included in the merge commit 841577c3d33b ("Merge b=
ranch
> > > > 'for-john' of
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next").
> > >=20
> > > And now that part of the wireless-next tree has migrated to the net-n=
ext tree.
> > >=20
> > > I have no idea why you thought you should revert the fix.
> > >=20
> > > I have used the wireless tree from next-20140224 for today.
> >=20
> > The fix should go through Greg's tree.  I shouldn't have merged it at a=
ll.
>=20
> No, the fix was only required in your tree (since it was a patch in your
> tree that caused the breakage).  And that fix is now in Dave's tree, so
> reverting it in your tree just rebreaks stuff in your tree (and in Dave's
> tree if your tree is merged by Dave again).

Your tree is still broken.  I just did some test x86_64 allmodconfig
builds of your tree alone. Current top of tree (wireless-next/master
997bc71a3601 "iwl4965: disable 8K A-MSDU by default") fails like above.

If I revert commit 161d78555435 "Revert "Staging: rtl8812ae: remove
modules field of rate_control_ops"", it fails differently:

In file included from drivers/staging/wlan-ng/p80211netdev.c:91:0:
drivers/staging/wlan-ng/cfg80211.c: In function 'prism2_scan':
drivers/staging/wlan-ng/cfg80211.c:419:10: error: implicit declaration of f=
unction 'ieee80211_dsss_chan_to_freq' [-Werror=3Dimplicit-function-declarat=
ion]
          ieee80211_dsss_chan_to_freq(msg2.dschannel.data)),
          ^
drivers/staging/rtl8821ae/rtl8821ae/trx.c: In function 'rtl8821ae_rx_query_=
desc':
drivers/staging/rtl8821ae/rtl8821ae/trx.c:619:3: warning: passing argument =
1 of 'ieee80211_is_robust_mgmt_frame' from incompatible pointer type [enabl=
ed by default]
   if ((ieee80211_is_robust_mgmt_frame(hdr)) &&
   ^
In file included from include/net/mac80211.h:20:0,
                 from drivers/staging/rtl8821ae/rtl8821ae/../wifi.h:38,
                 from drivers/staging/rtl8821ae/rtl8821ae/trx.c:30:
include/linux/ieee80211.h:2286:20: note: expected 'struct sk_buff *' but ar=
gument is of type 'struct ieee80211_hdr *'
 static inline bool ieee80211_is_robust_mgmt_frame(struct sk_buff *skb)
                    ^
drivers/staging/rtl8821ae/rtl8821ae/dm.c: In function 'rtl8821ae_dm_clear_t=
xpower_tracking_state':
drivers/staging/rtl8821ae/rtl8821ae/dm.c:487:31: warning: iteration 2u invo=
kes undefined behavior [-Waggressive-loop-optimizations]
   rtldm->bb_swing_idx_ofdm[p] =3D rtldm->default_ofdm_index;
                               ^
drivers/staging/rtl8821ae/rtl8821ae/dm.c:485:2: note: containing loop
  for (p =3D RF90_PATH_A; p < MAX_RF_PATH; ++p) {
  ^

So please revert 161d78555435, and then fix this other error.

I am still using the version of wireless-next from next-20140224.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__5_Mar_2014_10_16_27_+1100_Zd1AZ/7cMd80YYmH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFl7PAAoJEMDTa8Ir7ZwVZsAP/2kkm7c68gR9xt0m8f6zScC4
i1K1uH8QA1iOepxwWqb66YjhLgnNRbNAZBBb+hL2NvEigprJ/88sa1gWgTsFK1v5
Mjt6vZbZFEfqzntMrjBIQ+WPSUNjA/CCB8uB1p9cWaZECjouMC8k6YUNkoHqGdLW
qYc/Fdq3AJtZU63avkkzHLoD0J4HtzgykwdW6K4mgZ8R3oDUjtFDqm58+dfUNcBJ
z/GZKXPfd6aF97uMlFmBnienXqtVZGlYXqC8Zd8fkhLztBXREDQoVX6wabutvBm3
8dwe05wsoGhb0DF9ZnIvHfJkmuHovOqUWxT5ft/8Z/TGPBrlV9TYpNmDyFQcJvHj
PXfb7FWe8n9bvnecNn4aRJpyF59Fu7Q9o56491TY6jRxtnL2h7g5IJt77JOkvpBy
Y63IXRzv6Th3o5snIvJN2aUuYjn30L5NKAEN/cAPSaomVHhrrAmYOQjW7zoUl+LP
6Gn+eMulFVhpip33AOyKPpca1ahb9XiTamQmiwl7T2kGCVMOG7t90x1aNg6FbVQ3
fvmuHVrx2Olkfgb3MUDnIhc3t73Yh6b2NBa6B571venSUThVGs+U0gMKF9WJQeaW
a8o61ZqJunWYq/qNCOipBYMjZ3nrTPt/SQIlycQAhDRLHnz3B0Lq/eTx2Tpxl+hH
V5y6bHWabOedjP6mvv/7
=uAlt
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Mar_2014_10_16_27_+1100_Zd1AZ/7cMd80YYmH--
