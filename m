Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaANVGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:06:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54335 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaANVGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:06:23 -0500
Date: Tue, 14 Jan 2014 21:06:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Yi Zhang <yizhang.mrvl@gmail.com>
Cc: Yi Zhang <yizhang@marvell.com>, hongfeng@marvell.com,
        linux-kernel@vger.kernel.org, zhouqiao@marvell.com
Message-ID: <20140114210618.GZ15567@sirena.org.uk>
References: <CAK=oMXebE=OKzGbaRH_baOvRyhPXnw0MZuRrcZYLpeR73=XdqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dZHW955j1vPFHE0Q"
Content-Disposition: inline
In-Reply-To: <CAK=oMXebE=OKzGbaRH_baOvRyhPXnw0MZuRrcZYLpeR73=XdqA@mail.gmail.com>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Question] Should we make the primary interrupt handler
 configurable for regmap_add_irq_chip()?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dZHW955j1vPFHE0Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 11, 2014 at 12:15:21PM +0800, Yi Zhang wrote:

> I met a scenario:
> As soon as the interrupt is triggered, a wakelock is needed to be held
> until the threaded handler finishes,
> I think we may hold it in the primary interrupt handler, but now it's
> NULL by default;

This sounds like something we should just support in the core, though to
be honest I'd expect the interrupt core to hold a wakelock itself during
interrupt processing.  If we're doing it in regmap then allowing the
caller to set a wakelock to hold seems better than making them all write
the code to take and release it.

--dZHW955j1vPFHE0Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1abGAAoJELSic+t+oim9Xy0P/iCmbzvKomK/nUB7FSX4OLC6
CIAnNVHou/ospwi1Q189tz5G2bYtDkw4VVHeW+fqT8bOTu48YPoYTQ88B8ILWARv
9lztCdBkEXoHujcn3+3O6Vh9eLwh2Dr/vFN8kep6YcV5f5wCknuM9aJLUsMTdGOR
1H43mGeYOaLn/VlME8Uj++7rV9I1RDpy474rt2H1/zXSpUN00TOtE6o2kmZTQCDZ
0vwEAHznkv+aAciKTgCKtmiQwNH+XtG1UQvkcWL45tbvXbbYIN0ZXw4BJ4KI+nV6
wxSyxjyLyncGD0KFZgZU7HJi7ahwgjZlfgwxz08wN+aP32ued1PqP960XSPnBMsC
3twLgEGz9hKSobID7i7Gvemo2+PUck83jlwTDy/Ma+u66fB2Bg3hBOe14nEXi20u
G3CZyCY0gvpOfzUdh69PK2xOTQXawKtMvl7SCiOsQLCjybmVxnv+GTbx91vhlwdW
S8XKkENxQ0pY7oNQQOT4Mvx33tQgKtRHUi+VizCXJs5prdVMnQOQD5EppwoBtpSa
asbpHKBAGWWuxYg8qGxf90h6461080XkJ+M8vezy82xmTJMXVhpV5jujUm/DrwL0
g8sBVT1lXmGqBAKQ4j5Urz/bhxmOf0DeudbRA7Xk0tCfwCSkuvGIQHxE72vlDLLv
j97Nt/lZ8Js5ZuseAOOQ
=FJhK
-----END PGP SIGNATURE-----

--dZHW955j1vPFHE0Q--
