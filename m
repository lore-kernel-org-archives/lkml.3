Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab3FZMBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:01:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51541 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3FZMA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:00:58 -0400
Date: Wed, 26 Jun 2013 13:00:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jonathan Austin <jonathan.austin@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, linus.walleij@linaro.org,
        Will Deacon <will.deacon@arm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130626120031.GN27646@sirena.org.uk>
References: <51C97F40.5030101@arm.com>
 <20130625184539.GB2718@n2100.arm.linux.org.uk>
 <20130626044842.GR23141@intel.com>
 <20130626081909.GD2718@n2100.arm.linux.org.uk>
 <20130626103930.GS23141@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ct8ez/PVgO98mXV4"
Content-Disposition: inline
In-Reply-To: <20130626103930.GS23141@intel.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: amba-pl08x and 'get_signal' namespace collision/build error
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ct8ez/PVgO98mXV4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 26, 2013 at 04:09:30PM +0530, Vinod Koul wrote:
> On Wed, Jun 26, 2013 at 09:19:09AM +0100, Russell King - ARM Linux wrote:

> > Except, that change probably is probably responsible for this new error:

> > drivers/dma/amba-pl08x.c: In function 'pl08x_request_mux':
> > drivers/dma/amba-pl08x.c:304:13: error: expected identifier before '(' token

> This was pushed four days ago and havent seen any error report expect this.

> Anyway I rebuild my -next and looks fine for me

>   CC      drivers/dma/dmaengine.o
>   CC      drivers/dma/virt-dma.o
>   CC      drivers/dma/iovlock.o
>   CC [M]  drivers/dma/dmatest.o
>   CC      drivers/dma/amba-pl08x.o
>   LD      drivers/dma/built-in.o

> Can you share your config which failed for you?

> Mark, I believe you are testing for this, have you seen above error?

No, that looks like the original error that was being fixed.  The driver
build tested OK for me at the time and currently in -next, though a tree
which has the additional include but not the rename away from get_signal
will obviously still have the issue.

BTW for build coverage it'd be handy if AMBA could be enabled without
having to be explicitly selected.

--ct8ez/PVgO98mXV4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRytfbAAoJELSic+t+oim9rz0P/jIE07y3XLVGQA6S3XcUgrCv
C8veysC68qYmGtYXnQbATnTkEgeCyYsn5zFHVIKT9C1QPHCGIJ1J92J2Ul+GTSQf
nVUSn7/Cjod/ZafjpnxGdkVBQZa+gdaLITkUh2mAPc6Kb9NkbjPqHtIlfW9B6+Wl
CwZ70TBIWHpWbRkB5Ja1nX0/JDMpldwqqYs1hTUWurapyFVaEUYhMbFhTk52/1lM
zBEFpOTdKMjjHQvhQqUQuXAY05HBDYY4VSMPssXM+mj9gLSLP7VHoaP+jXfa57Aa
el271F62tFHzNGKpZxOvRg3ofI/cz5Z3yGElvbtk9KempkX5gcHPz72mp3Qrt8bG
hnOdig2UWZMgEcT0t2Es0ZjXosnw35jLDxbw2814wOk+hlxkfEqyLe7cYQ5u5spJ
t5SISdXK5/5z7TZ/EVZQoG8xBxUG8SGe2yWRdQzkSTD1wE9J/htt7CTmtGTxspUk
Q3hR3ojcdinnOVY1MyK82od/lK+pYThKHKJoOZz3CVhkgMXSeK0puLXDllL1SoVM
caz8ocFvyAXCQJb6FVa/IlSjIXA2shEhICBkS/fSBxKSPm8PH5QRd8eLXn+44Qdb
+z3KLyS8si2QoOxt75oEuXmbWXiLMbtzPEOpcq5IeTtt4ubq/fNbj2rdRsNTcvCn
DWCJYqr6FvOMHmJSp9/u
=g42j
-----END PGP SIGNATURE-----

--ct8ez/PVgO98mXV4--
