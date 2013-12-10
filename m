Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3LJDCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 22:02:31 -0500
Received: from ozlabs.org ([203.10.76.45]:52979 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab3LJDC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 22:02:28 -0500
Date: Tue, 10 Dec 2013 14:02:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the pinctrl tree
Message-Id: <20131210140218.645eaf6983481bafe5833eef@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Dec_2013_14_02_18_+1100_PhEk+3RnDkr7UcKm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Dec_2013_14_02_18_+1100_PhEk+3RnDkr7UcKm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the pinctrl tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/fsl/eukrea-tlv320.c:28:28: fatal error: asm/mach-types.h: No such=
 file or directory
 #include <asm/mach-types.h>
                            ^

Probably caused by commit 6bca8471566c ("pinctrl: select dependency on OF
for MSM driver").  the build of eukrea-tlv320.c depends on CONFIG_OF
which is not normally set for as x86_64 build, but the above commit
caused it to be selected (I think).

I have used the pinctrl tree from next-20131206 again.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Dec_2013_14_02_18_+1100_PhEk+3RnDkr7UcKm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSpoQ+AAoJEMDTa8Ir7ZwV980QAJDdUNKcY9U/BplxM6mee8Ge
iH+sZUW/DIX4ANyoGZ79QYwS9Ch8pN3sihZ3jHOlAceRduMQ8D9SPDCqM3UF735b
PA0qeE0YpM0LJCYwGUIzJha5hCdgYCchsMGeoDuDMV9t61mTpZkWC3dVV/fDjPqZ
ZuRFr3pQo5T9bXtgx6f/UyULoUgrmso2Hx7+m5hZBY++f7l0cxOMHtzQIy8knmHV
wb2t3rqgsEuX+z14AHZcaMULU7uksMy4daq1MVLM5RvnyKOOgFrNGIbYMlFsPw2Q
MCRTBub44s789pvSrJv3R+VibXospb/k5SmmK2wOqFOBcHOgd9SvtMrA/GndOBCW
X7YnVEr/F/HkOC6j2zhsuKjafndZI7hgJKkhQNyEjgkc4Y6y8wdfKAujUN4BEPsS
U83j10kEyIMLXBbhByiZLiuSDJEgPf+hGEFHDOgc8lbojLaW3mP8e4vS4NA0q26h
5XvxmQ3pdxtTBDHkJrcrrnr2aK1HKm1WRYyyRYfBNUkqmxfKbl7dcZLSodufJupc
ddgKZMvKCmcCfdWWKE2X/m9B83bEZnj6nozM0SZUDEm/TJhaZ1OYsXkiZyq/IMvg
IMS5FnlpYHQgfyy+73978h0XRWMEPW55stWBeRPdyro80CZmgkCrJ7Co0mBPLn/b
wXKq5OplicIMVHcLAPnp
=gzsx
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Dec_2013_14_02_18_+1100_PhEk+3RnDkr7UcKm--
