Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3DOPup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:50:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47352 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307Ab3DOPuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:50:44 -0400
Date: Mon, 15 Apr 2013 16:50:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <t-kristo@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC v1] regulator: core: introduce regulator chain locking
 scheme
Message-ID: <20130415155040.GD15837@opensource.wolfsonmicro.com>
References: <1366031015-17073-1-git-send-email-grygorii.strashko@ti.com>
 <1366031015-17073-2-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M38YqGLZlgb6RLPS"
Content-Disposition: inline
In-Reply-To: <1366031015-17073-2-git-send-email-grygorii.strashko@ti.com>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M38YqGLZlgb6RLPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 15, 2013 at 04:03:35PM +0300, Grygorii Strashko wrote:

> To achieve this goal:
> - abstract regulator locking out into helper functions;
> - use the root Regulator (which has no supply defined, like regA) in chain to
>   protect the whole chain;
> - implement regulator chain locking scheme as proposed by Thomas Gleixner for CCF
>   re-entrance in https://lkml.org/lkml/2013/3/27/171 and in the similar way as
>   it is done for CCF by Mike Turquette in https://lkml.org/lkml/2013/3/28/512

Split this into separate refactoring and other change commits - one
change per commit.

> In addition, such locking scheme allows to have access to the supplier
> regulator API from inside child's (consumer) regulator API.

I've still not seen any use case articulated for doing this...

--M38YqGLZlgb6RLPS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbCGbAAoJELSic+t+oim9+fkP/iJxTsb9t2VkYITycRgv7w/+
Wj6uASjqg/Dsq5TedvjYIKagr8nev7Ubx+VSJERO6k8ISjtUCeDSVN0bfn3mbH47
fE6G69y8XQ3pkWopqXTgoTqRD26Bx9cOgg5iTc73IXsbeO/kaGRxJAlwvCx1rypV
gIGuXlNgHZ68hOuyN/kptoICCuodA/IJFbckggZPPK0IN21WdskYRQVH5ueAVHXg
DlvKSPsRsbrFSXiTRevuJfT37SiyultzDiWLfwVyNedG+XZemVfVWq4rkZwSXuhO
SANqWRpo/vi+N0C2ikQBxCegXAWcf0eEEYljkZq+qOChqkfetnubb1ZtwdeB6jHk
cr6mLTDISriUQUEQjoKQtk+tPpeSLLXfawrjMoaYuPspacJymGWutveBQQm8YYS4
oJ9C8YbWOBrv+ve5CmnaSSqFR/hAd/HieWaOCTiToEGhMrxER4n/f3Nd19KgyHJp
KMHLy2TMzYhDKBV6UsqoDGp9ayTpoXSSSpg7VyZeG1PUIOaT0wACJRj50Xj7/KRs
/cyuxY6JY4SWZoO6wCtGSdu25xx1OBSI/56YB34YxNK+Nd7FqcjkVijZP61lOvFB
kydkGs0kfwSIOmxTU/1DgZTSMHHMZYEXy3l+bSpnOWnUIH57OJCU2LXxqGl/6/px
FN62TDxmWTJmORGfQb0Y
=mQF3
-----END PGP SIGNATURE-----

--M38YqGLZlgb6RLPS--
