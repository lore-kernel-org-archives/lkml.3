Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaFCKu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:50:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51704 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaFCKu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:50:57 -0400
Date: Tue, 3 Jun 2014 11:35:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140603103501.GX31751@sirena.org.uk>
References: <1401699704-17902-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20140602210117.GO31751@sirena.org.uk>
 <20140603094932.GF11951@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FhxWStFQ84VXWhXs"
Content-Disposition: inline
In-Reply-To: <20140603094932.GF11951@opensource.wolfsonmicro.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] mfd: core: Add the option to order destruction of
 MFD cells
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FhxWStFQ84VXWhXs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 03, 2014 at 10:49:32AM +0100, Charles Keepax wrote:
> On Mon, Jun 02, 2014 at 10:01:17PM +0100, Mark Brown wrote:

> > Probe deferral is supposed to handle removal too, we're supposed to be
> > able to walk the device list in reverse order and everything just work.

> I had considered this approach but was perhaps incorrectly too
> nervous about it. I was slightly concerned about breaking other
> MFD devices by changing the order things destroy in. Also the way

It seems vastly more likely that there's other drivers out there with
poorly tested removal paths than drivers relying on the current
behaviour.

> the child devices are iterated with device_for_each_child, there is
> lack of helpers to process the klist in reverse and it felt like
> code I probably shouldn't be modifying.

> I am happy to do a version that removes devices in reverse probe
> order, if that is preferrable? But any pointers if I am missing
> the obvious way to do that would be appreciated.

You probably need to write the helpers but I'd expect they should be
relatively straightforward.

--FhxWStFQ84VXWhXs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjaTSAAoJELSic+t+oim95aQP/1PXA6t9AjWBQGXLZCCNdqWT
1keeRygBDis3DG5lPvtxVKNxA0RYFNlz+tTCSEmW5MDLYaFewK/udkyA/AlGs203
13unI0+20VMR2y3+gdZwI7eaLe8PFSD/K63oWafquuXL8E6k7ewfOZXhJLOflrfx
NpmMb7phRuj5YvJRwoMXVIM7AwOA/Nv36VD4yUSt+jEYb4tKticNpgGQxu4KWSVj
y/uj/HdG5LwPdHxb52B0wPVs/iuT+SEOPWmDGKd0KUCPr5+EKW5fXhDtg+QLBpVv
+ZKbJXYAQuNC8mZ4wqahJaHQjGhI86r5XCrzm4RbBr1CcvBLr81unfUuw1MHthgX
WeLpK1UVff9a1KcEdKJGTToNh4VJGvfhMyezUgFZVuS07EF8VJfrwGm/6iCeiBIw
WDGDCfbTeP/XXnIua4r5CZE9QIwrwo5SgVx5wm++HbCgyhAm1zR9cTwR+oR/DcJd
+n+PFmEvDEsQT3NxbWf9UoJGa7HKLg08QaJ2MCa6+O992PFLIXsb1s/8ufGjXEPz
Dgmrn9Vsub0F/i/3KwBeQDTNwTrse/tGyjR/cSLF/cuF+dOOz/HAOhb5rBFMkvhG
Qu9pvBFROfi/GYNNB39WuqT+Y12e2Z3o1zMguCut37KXb6r8tLZGU90z7mEMZfNN
MfcBSgQtGuFrBk5ye36i
=zvFY
-----END PGP SIGNATURE-----

--FhxWStFQ84VXWhXs--
