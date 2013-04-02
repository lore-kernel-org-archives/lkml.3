Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277Ab3DBDbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:31:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56495 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759425Ab3DBDbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:31:18 -0400
Date: Tue, 2 Apr 2013 14:31:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20130402143108.129f7a97a8a05e88e53f3ff4@canb.auug.org.au>
In-Reply-To: <515A4B6C.2080805@lwfinger.net>
References: <20130402133400.017b4ec5cd37725b32aa8079@canb.auug.org.au>
	<515A4B6C.2080805@lwfinger.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_14_31_08_+1100_QRnSUsjvPUc6smRn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_14_31_08_+1100_QRnSUsjvPUc6smRn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Larry,

On Mon, 01 Apr 2013 22:07:24 -0500 Larry Finger <Larry.Finger@lwfinger.net>=
 wrote:
>
> On 04/01/2013 09:34 PM, Stephen Rothwell wrote:
> >
> > After merging the wireless-next tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >
> > drivers/net/wireless/rtlwifi/rtl8188ee/dm.c:30:18: fatal error: wifi.h:=
 No such file or directory
> >
> > Caused by commit f0eb856e0b6c ("rtlwifi: rtl8188ee: Add new driver").
> > Forgot a file?
>=20
> I do not understand. File wifi.h is definitely there and is in=20
> drivers/net/wireless/rtlwifi/. Use of that directory as a source of inclu=
de=20
> files is handled by "ccflags-y +=3D -I drivers/net/wireless/rtlwifi=20
> -D__CHECK_ENDIAN__" in the Makefile for rtl8188ee. In fact, it builds jus=
t fine=20
> here.
>=20
> What am I missing?

I don't know, sorry.  The tree I have also has
drivers/net/wireless/rtlwifi/wifi.h. All the other uses of wifi.h in the
other drivers below that directory use

#include "../wifi.h"

Maybe it has something to do with using O=3D... on the command line (which =
I do).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Apr_2013_14_31_08_+1100_QRnSUsjvPUc6smRn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRWlD8AAoJEECxmPOUX5FELL8P/Awc//G4SubmLuWUWYGflNP7
hxLcnHvV3pmvRqIa2XD4kwczmgnmzmBLmCZB84HgsznmicQUKIP8GSIUJhtZfDSU
PhDO8mIYfp1minAr94GxuzzQYtSyar1m4hjIaMiI8y7CmESTgtnPGJLtDbzS05tJ
y8r1lazON+I0J843gYo+KQEAa6LmveMj6mj8+74pfm/uye5lqz4SpkPjt1GoAhjc
qGfnxaCs+FXfTl9hLMjrKGf8bA8TVSNEF/GGEkaeyRvZPeZJBwe+jfVRfWq2HdkS
Rn4/wbnSHnPuL4zvMrbIxkAGrnoF5DMZMWLEqF8ilPGysCgPheEFkKjCoabTPa1n
ePd/cAugJcuLwIzLfV4vVm3eZp5DFF9IztDx5E8bivSEASLagB9JkACCXFe3NNTH
QcGvMhpXhroM3vZzmlB8EnE2VyspEB56c8XoV7/aGTjW2+1Ed5xbxqACGbOp34/3
/hyIofbU8EG1tQ5aYrbe69K/Ore9pjTxIv4KQJiGE1M/s0HepuW/tpXv41dyCwHW
ffmNNZBtxCKmmk8sSJn1fq2SDAOJA9XjfCYd293wtOHg70Sd7It3Hg+n/j3uoaHd
xbty9ZYsVa+cDtcSFul/6us3oBP0GlcR0bo8s+kCoqYv+x9j1SUYideFvK6AQ0pA
z7pK16y3gl77WuCbk/JK
=N65V
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_14_31_08_+1100_QRnSUsjvPUc6smRn--
