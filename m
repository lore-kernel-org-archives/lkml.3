Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab3FSHMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:12:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51927 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab3FSHMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:12:30 -0400
Date: Wed, 19 Jun 2013 17:12:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 driver-core.current tree
Message-Id: <20130619171221.bedfb8f5c3c9819decc01edc@canb.auug.org.au>
In-Reply-To: <20130619153225.9ff68f0984bfa54333c4df10@canb.auug.org.au>
References: <20130619153225.9ff68f0984bfa54333c4df10@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Jun_2013_17_12_21_+1000_pSKmZj.vuwdIg6zn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Jun_2013_17_12_21_+1000_pSKmZj.vuwdIg6zn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 19 Jun 2013 15:32:25 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/base/firmware_class.c between commit 875979368eb4 ("firmware
> loader: fix use-after-free by double abort") from the driver-core.current
> tree and commit fe304143b0c3 ("firmware: Avoid deadlock of usermodehelper
> lock at shutdown") from the driver-core tree.
>=20
> I fixed it up (more may be required - see below) and can carry the fix as
> necessary (no action is required).

I missed the bit below (at least) and have now added this as a merge fix
for the driver-core tree.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 19 Jun 2013 17:08:01 +1000
Subject: [PATCH] fix up for fw_load_abort API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/base/firmware_class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 57aa842..fdacd77 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -812,7 +812,7 @@ static void firmware_class_timeout_work(struct work_str=
uct *work)
 			struct firmware_priv, timeout_work.work);
=20
 	mutex_lock(&fw_lock);
-	fw_load_abort(fw_priv);
+	fw_load_abort(fw_priv->buf);
 	mutex_unlock(&fw_lock);
 }
=20
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Jun_2013_17_12_21_+1000_pSKmZj.vuwdIg6zn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwVnZAAoJEECxmPOUX5FEZ84P/2PYMG4u7U8VpxsAH/E33rZD
lllEeMaVjJ+Irbl8RIJn7e+7JYrWR5fnxyXBv/tQlZipHI48cDlvDoTjkegG/jx/
Lu0GJCJVLqCvffux+XlpZyf8Hd+sHavqkafugKmIQfqDyvDRflR+mfZqTgr2CgfQ
1dUSCtsigTMBsx32wDhKereNNiO7Lg2U/Sa1+l4mJoh9+lezgZkFtCIUQyrwfG9H
7jwUFYjktxuSDYwFxun4AGQ/+TwsvKp6KCOq9+nWtetiQS3vOG2KVCKFSko9ueJf
8ap4hQ0E6S+z4xqYlb/OK+JrSPisZ7E+Jwu9IqiRPq9wO+gz0kFRWwzDXlPTYMTx
weATxNA0NqW8RCMGVVxIv6oCofhMmhDI3/lK8FjSuRBdSNJL91n0eJOGqcQU4PMP
q8w/mOlqtGddTQ33I+bNAHs7X4ha4VxV3hemQJ7/QniSmMPpt88WJEsGTBdvUlWu
bdbVpEIOoVzWc1nuv5h7ZGV59ufUfCi2AP/tO6+blym8Y1QD1CFmy5dlNPSVpgV/
EcDdzl+vfX8c3h5Evjjbz2UDHiwL6gISSFwAItOlaBrRMDRLr2uOn144POjKwzWs
eQMpIwKWhWL/gR11RNHOOtq0MoWsyTmDkwYi0VxhC2XpDOwUhm99nHJkw56idM1B
M8bt1fa7RcEu9PTSUsvL
=Ja6t
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Jun_2013_17_12_21_+1000_pSKmZj.vuwdIg6zn--
