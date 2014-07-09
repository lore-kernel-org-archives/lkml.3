Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaGIHPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:15:39 -0400
Received: from ozlabs.org ([103.22.144.67]:36015 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbaGIHOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:14:21 -0400
Date: Wed, 9 Jul 2014 17:14:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@infradead.org>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Pali =?UTF-8?B?Um9o?= =?UTF-8?B?w6Fy?= <pali.rohar@gmail.com>
Subject: linux-next: manual merge of the rd-docs tree with the trivial tree
Message-ID: <20140709171414.5d995396@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.Q.BxtoPTey=h+ObpmG1C2D"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.Q.BxtoPTey=h+ObpmG1C2D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Randy,

Today's linux-next merge of the rd-docs tree got a conflict in
Documentation/laptops/freefall.c between commit d5ae11dc402f ("doc:
hpfall.c: fix missing null-terminate after strncpy call") from the
trivial tree and commit 0af05db576e9 ("Dell kernel driver dell-smo8800
provides same freefall interface as hp_accel so") from the rd-docs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/laptops/freefall.c
index 67084321dab4,aab2ff09e868..000000000000
--- a/Documentation/laptops/freefall.c
+++ b/Documentation/laptops/freefall.c
@@@ -27,8 -33,8 +33,9 @@@ static int set_unload_heads_path(char *
 =20
  	if (strlen(device) <=3D 5 || strncmp(device, "/dev/", 5) !=3D 0)
  		return -EINVAL;
- 	strncpy(devname, device + 5, sizeof(devname));
+ 	strncpy(devname, device + 5, sizeof(devname) - 1);
 +	devname[sizeof(devname) - 1] =3D '\0';
+ 	strncpy(device_path, device, sizeof(device_path) - 1);
 =20
  	snprintf(unload_heads_path, sizeof(unload_heads_path) - 1,
  				"/sys/block/%s/device/unload_heads", devname);

--Sig_/.Q.BxtoPTey=h+ObpmG1C2D
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTvOvLAAoJEMDTa8Ir7ZwV/NoP/0mQjnIUWvZTwBmxnIumk1Fr
VS3hZAIm1g5mW+7XszUTDQnzCB56JIIeubPA3rk2v2FLyaf/zwXxQTQkIflI5SJD
bb2eTPSdSHIdJU/vnvJimsvtmGQZ5lMaspWMZE0gpkfCB3AOILOkrJs51b7u/mTE
YOAyy/gqvpbErhkphWiY4vu5gqNtQzXhhI3fMaQrtorMZYerpyn4iKn5vOavcJ36
TxXSp37usjZcbOzdldp4XpPJyZ7OSHEXZcaY1dLU2N/EQg/gkrXdI6fQFox8cdHv
a0/heP1myFAMSD//16kLML4wxQdui+qMacinIKYhiREA6AKqVmfAa+9R3eqGEPb+
Hg8KH2a/5EKDen7XP/W5Z/ZSFfB1yi2AOFzSbX1apR2+5/lR/fY54ksXbS5Yt4ag
PlrZ78kkWAcLrJq/LD28B5hYvTulRe33kZNDziQrZhkai0xS2PzgeqV2hLbYks2p
Y8uA+roHQPKTajAJIMWdkJNHXMBhhep6NOeS3l6/Tqbi/Wb5W0ie2+LFEh3CLnoU
BiOw2Xdy39fiaoYli0y6cXnwZjBnhngnhyRSuRuJ8x1etSSmOZsdRg5pYwaLABnu
jmEFmDBBCUv5XBUh2gW7TqSQjqVtMjSXeadOzkPlB25AXHw+zJXz5IABJtCZhpRe
usd7qy12uvnIOgxqfnRS
=NWLj
-----END PGP SIGNATURE-----

--Sig_/.Q.BxtoPTey=h+ObpmG1C2D--
