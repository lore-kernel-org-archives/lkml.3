Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab3FGG2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:28:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42097 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3FGG2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:28:47 -0400
Date: Fri, 7 Jun 2013 16:28:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>,
        Peng Tao <bergwolf@gmail.com>, Greg KH <greg@kroah.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20130607162830.9d7ce277a9eda2b54fe73e92@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Jun_2013_16_28_30_+1000_xU4AJEQTrP/hLy.f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Jun_2013_16_28_30_+1000_xU4AJEQTrP/hLy.f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/staging/lustre/include/linux/libcfs/linux/lib=
cfs.h:49:0,
                 from drivers/staging/lustre/include/linux/libcfs/libcfs.h:=
44,
                 from drivers/staging/lustre/include/linux/lnet/linux/lib-l=
net.h:45,
                 from drivers/staging/lustre/include/linux/lnet/lib-lnet.h:=
44,
                 from drivers/staging/lustre/lnet/lnet/api-ni.c:38:
drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h: In function =
'set_shrinker':
drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h:102:3: error:=
 'struct shrinker' has no member named 'shrink'
  s->shrink =3D func;
   ^

Caused by commit a37f14f05f2f ("shrinker: Kill old ->shrink API") from
the akpm tree interacting with the new Lustre client code from the
staging tree.

I have just disabled the Lustre client code again (by reverting commit
ee04fd11f11f ("Revert "Revert "staging/lustre: drop CONFIG_BROKEN
dependency""")) and maybe someone can tell me what I need to do to fix
this when I get back in a week.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__7_Jun_2013_16_28_30_+1000_xU4AJEQTrP/hLy.f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsX2XAAoJEECxmPOUX5FE/oEQAKfpuW+VfxvGNoxAdPtqNw1q
lLnNBDsf4sJ4b/vDXvJ9cy0ZmuoxKNVVN4zJyqIw2J34phy3z8I2DTowqkecdZAG
bsJqq953zoYtW182cSWzQLAEiwbUegkngZwbuHGDmHly513qJmgF9AaA3Jb5DjGy
txyLVT5PDRrNnZAnzuD4hCjG0cJ6zB24/7PODoJOQPYkaAZbulKs/EWGTsKDUWo5
Rn/K3axutM8MLmvsjGk6SV1e9K/QmuSDp0i8dr/P1KWh6yGXjfemVbcv4lFf7XFD
BDViVXHLbI9m+TC67Fn5Lh0ulUpdbF36ViyhW45TNb9NfGDwE04y7nxl5A/RerG1
IQ5Bv31JpQ41E/2NtyEmEBlI7gaAtaCboo1GLCEMt/sYHDOLqz4+iWWhiQnGk567
+zXr/IEhYrnKUz+gXr2tgwd98o/qsY3JZDaalhaEfTGcIXVqmp0KS64qK9rCV7PM
jTrA5gWNRoMVoxxrVO+7BoMRldNHiGme99o9091EpbuRNlTP4Xy4ryVVl+LOP30g
UddbAQjZZ2KoA+np/8eIZCDob1RVSDeG3SInY0Sz+oHqB5SkPQZO5fuS2icmbpkD
BpQfSolXT8EDFp7/X3WxbTuBjGZXaSvCyR0fuSrEGsBZQW3W61q6ndApT9MYDlOK
0hhZD6zghg9TvQHLBf1a
=Yi0v
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Jun_2013_16_28_30_+1000_xU4AJEQTrP/hLy.f--
