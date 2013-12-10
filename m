Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3LJEHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 23:07:09 -0500
Received: from ozlabs.org ([203.10.76.45]:56064 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab3LJEHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 23:07:07 -0500
Date: Tue, 10 Dec 2013 15:06:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: linux-next: build failure after merge of the pinctrl tree
Message-Id: <20131210150659.4bb4ed87c3e30cac03500a56@canb.auug.org.au>
In-Reply-To: <20131210140218.645eaf6983481bafe5833eef@canb.auug.org.au>
References: <20131210140218.645eaf6983481bafe5833eef@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Dec_2013_15_06_59_+1100_WXNZN3jEeHVUfqkU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Dec_2013_15_06_59_+1100_WXNZN3jEeHVUfqkU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Tue, 10 Dec 2013 14:02:18 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the pinctrl tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> sound/soc/fsl/eukrea-tlv320.c:28:28: fatal error: asm/mach-types.h: No su=
ch file or directory
>  #include <asm/mach-types.h>
>                             ^
>=20
> Probably caused by commit 6bca8471566c ("pinctrl: select dependency on OF
> for MSM driver").  the build of eukrea-tlv320.c depends on CONFIG_OF
> which is not normally set for as x86_64 build, but the above commit
> caused it to be selected (I think).
>=20
> I have used the pinctrl tree from next-20131206 again.

It turns out that this is build failure is actually caused by a commit in
the sound-asoc tree (436aa86f0414 "ASoC: eukrea-tlv320: Add DT support"),
but was exposed by the pinctrl tree commit.

So I am not sure if the pinctrl tree needs fixing (I think it did select
CONFIG_OF where it would normally not be).
--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Tue__10_Dec_2013_15_06_59_+1100_WXNZN3jEeHVUfqkU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSppNnAAoJEMDTa8Ir7ZwV3PYP/2BO9/2Tvu9AAV3zpPTv1HN1
EUO8tbbqEcwsEFSSY64/nPUGTOcyrN781203Os3zu/Dk8MkOE6wHxDDP5+0ui4Gq
1cre8xfv6dqhOQBopheBwyA5OWABCZ17rTZm54hXbZ4LyB/0E1AGJsYdVmzo59Kf
u9D9mtW7CQVO/cf9CoLYEjLv30B9HLUBQcber4f8ZaAONbIJMaPDrJQdOvlz8Wjd
Mmfoj5QDRDN7eU8TGfvTYr0f3iaKD8YSuDVRykyZcNmTGWITJdNL+y/IFyBbKBJY
uiCgWzWYNT8HRBPPiPMPS0E8uWVY76WJYWPqklm5FUlBThal4fBMdy2SCxMO94d8
JCiNIahAg65h6/7JzIC8fZfUXVLsLnWz7uE5jl8kz6suUw/nA5phS4NCo7gvlHJ/
B0exh6ak7O0UBYA6n6Yxwh1Yk+UUAOonP5jYKrmHnShTp6ddXWEcBMpo4mOhVCTL
zfZcy/Ny9QXq9X63Wg5atljmFGnhZxoC93u9Bb05je18K7MEe3qi2gXcMF355icJ
x5nA5OkwSTsm3rgGLOIfvxAMA0zFG+5FQ0HGuWVUbq7uKCnzvT4QO+rRn30XHEyL
w9+8y6q32W0WZ/QYJcKPpkhodtV6nuETpmyquDMjTOExdvsRySMs5SuyZ5kvcoAa
AtK4MuAIA+Qeufc9gyUM
=mwQG
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Dec_2013_15_06_59_+1100_WXNZN3jEeHVUfqkU--
