Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaDVMKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:10:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41409 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbaDVMKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:10:10 -0400
Date: Tue, 22 Apr 2014 13:09:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Chew Chiau Ee <chiau.ee.chew@intel.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140422120948.GT12304@sirena.org.uk>
References: <1397751967-20250-1-git-send-email-chiau.ee.chew@intel.com>
 <1397751967-20250-3-git-send-email-chiau.ee.chew@intel.com>
 <20140418163054.GH12304@sirena.org.uk>
 <20140422115716.GP30677@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gMNETGfM6h1fx+eQ"
Content-Disposition: inline
In-Reply-To: <20140422115716.GP30677@intel.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi/pxa2xx-pci: Pass host clock rate info from PCI
 glue layer
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gMNETGfM6h1fx+eQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 22, 2014 at 02:57:17PM +0300, Mika Westerberg wrote:
> On Fri, Apr 18, 2014 at 05:30:54PM +0100, Mark Brown wrote:

> > As you mention we already have a clock API for passing around
> > information about clocks, it would be much better to fix the fact that
> > this isn't enabled on x86 than to add custom code to deal with clocks
> > (even simple things like this) - this is far from the only place where
> > it causes issues.

> We actually have clock API enabled on x86 if CONFIG_X86_INTEL_LPSS is
> selected.

Why is this conditional?  It's really unhelpful for writing generic code
handling clocks that the API isn't available as standard.  Allowing the
user to disable it if it's not required makes sense but not making it
available at all is just unhelpful.

> In this case the question is more like, where do we create clocks for PCI
> enumerated devices? Surely we don't want to have board files to do this.

> In ACPI mode, we do it in drivers/acpi/acpi_lpss.c but not sure where we
> could do that in PCI code.

As far as I can tell the clock here is part of the same glue that allows
the generic pxa2xx support to be instantiated from PCI.  I would
therefore expect the glue to also instantiate the clock.  Or if it's a
standard PCI clock then perhaps the PCI subsystem ought to be providing
it.

--gMNETGfM6h1fx+eQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTVlwIAAoJELSic+t+oim9qpsP/jeFc6kle0Yzi176iN5SgdXa
KIcDATpNyaYeJ7y5unDj7IbfqmKlT9fIzGstvQWrk37FeRKUIutfLM60ywVOJxaZ
UOzqoVQjDpJNAqLH/+BNFT+pHMLVqjHPVtTPk7qckSGcAhqahDOmVmoiETVKPWj+
PYyXQplm/EyrrmovF4gX9itg5i8DSfN7NhaAFSKmOI7S7IrUYQKcNvz6zs3tq1eu
RdTZQvW/eatZY2cECy8kTcwHoxE9P9yl2BFrDzia5ZrKlRLiVDZ3knElwDqCLs6W
HjTBM4exIRwlrRzil0QyRRZwRBnnigTEukpT+A0MXku7EmRPhhyNvGSwuUnW+n2N
8UTqb6RfgveNFd9vAdurRVclIQNhuww/khs8LKDUHIJlWk7NV0IJrciJCj+Ng+G1
y32prxpxPA2T0H8oerY5wsk6K71W5YfRnMabsiZAH4etqg8S8zYvsobqcAPfqMaV
X7xmywpTxF1WIG3Vl/QKo1wPjkNNrn2RiqO7+PQdwLxLfN1f2Eid2Ly/bld8rR1q
vKJAbi0Glr5yzWYVQBdoBaLxcpjODY5Vf5DXqizIgbwOCuh9UVsL53fHByx7SyH3
FzwMUp4MaImda0fA+hXOYILiH4GThvVkgZdyB/ZezjX3uXjcgJPw/Xh+rTb3pGz0
AZ98yEkEtSJ9C3q/zfQw
=WEXI
-----END PGP SIGNATURE-----

--gMNETGfM6h1fx+eQ--
