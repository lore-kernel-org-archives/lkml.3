Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab3HVNLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:11:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46852 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3HVNLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:11:16 -0400
Date: Thu, 22 Aug 2013 14:10:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-spi <linux-spi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Message-ID: <20130822131051.GI26118@sirena.org.uk>
References: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
 <b4458c93742bd9dfe69e3553cf377a703c945f81.1373290150.git.michal.simek@xilinx.com>
 <20130708144930.GG27646@sirena.org.uk>
 <51DADF3E.1000802@monstr.eu>
 <20130708162642.GM27646@sirena.org.uk>
 <51E00BF8.2020608@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H6o9R95t2FPeZmf3"
Content-Disposition: inline
In-Reply-To: <51E00BF8.2020608@monstr.eu>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 3/4] spi/xilinx: Simplify irq allocation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H6o9R95t2FPeZmf3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2013 at 04:00:24PM +0200, Michal Simek wrote:

> Just a follow up on this.

Sorry, this one fell through the cracks - apologies for the delay.

> Which function free private structures registered by spi_alloc_master function?
> Is it in spi_master_put()?

Yes, or spi_master_unregister() after it's been registered.

> The reason why I am asking is where clk_xx functions should be added.
> I see them between these two functions in sifr for example.

> And also I see in drivers in error probe path that drivers are calling kfree(master)
> but they are not doing in remove part (like spi-davinci.c).

> I just want to clear this in our zynq drivers before we send them out.

I'd not be surprised if there were errors in the error handling paths,
it's (hopefully!) not the best tested code out there.

--H6o9R95t2FPeZmf3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSFg3YAAoJELSic+t+oim9UIMQAJxTGqkFBYk9lZjcpLYgjWwt
KiBNY+7wL5EnzhgRutm1MLfSeCUmEk+Nej28c6q2zcaWa1nK8fmn2MeSIMvFcXfF
SzWhat4x/5MBNfrmDpHEuh6msLekFcLbp6EJkI9UILNnrrtVkXlPHm6BpL/+2tsJ
FWCF75koGTxrlLxL7GocQipEYZ+Q2ByfJMazhJY7EJCdscm4YmKIX368+NGvkbYY
r4ygI8iQQbBdWJlBlcL1M4n0XHxU+GrRA/PowFIA0cGD+Y6AfbEsgyhZrhxRohxm
qSrwxeHgglQlh+9btchYEmp7NyYufU5Mg6cLrje8c17IXLxnIWLnCxuKH54kRVnF
n/v+FFNBKo2t5wKEwnVY9NmPD8YeKureTNEq7bVOB4Kt6ZF9K0IMCv3lT/xpS2r5
KgPrsDxaqCzXPf+201eRhBXIjB99ImLkgAd/RyyyichTapeauLGYPkWwuY0dgm89
MDYCYi4f6w/ONjk3PN6mle/cTVTyDnSSPseGAK9eY6KE54l4YCk/z4kpzwMPY7Vo
L7aD83ZKgPpD30dv5RTRV8dfOYmSjsD9Bsj3z/HTyjAS+N+25qR1vK5KgkQecPdf
5h+1tTTneVHyEbuLWCORUJYM+7zpUKoBL+SfXYCVl/+t40dhBUKUmsOGlKs1QF3l
xE4T8Dq2XoIo4igR+3Mj
=FQKR
-----END PGP SIGNATURE-----

--H6o9R95t2FPeZmf3--
