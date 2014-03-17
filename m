Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbaCQNPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:15:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32798 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaCQNPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:15:16 -0400
Date: Mon, 17 Mar 2014 13:14:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Harini Katakam <harinik@xilinx.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        michals@xilinx.com
Message-ID: <20140317131453.GF11706@sirena.org.uk>
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
 <CAL_JsqKacetGytGUJir7ky3qOgCy-3ny1pT_Bx4eCYV2wMgcTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nYySOmuH/HDX6pKp"
Content-Disposition: inline
In-Reply-To: <CAL_JsqKacetGytGUJir7ky3qOgCy-3ny1pT_Bx4eCYV2wMgcTg@mail.gmail.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] SPI: Add driver for Cadence SPI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nYySOmuH/HDX6pKp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 17, 2014 at 07:47:24AM -0500, Rob Herring wrote:

Please delete irrelevant context from your replies, it makes it easier
to find the new content.

> On Mon, Mar 17, 2014 at 7:05 AM, Harini Katakam <harinik@xilinx.com> wrote:

> > +/* Macros for the SPI controller read/write */
> > +#define cdns_spi_read(addr)    readl_relaxed(addr)
> > +#define cdns_spi_write(addr, val)      writel_relaxed((val), (addr))

> Just use readl/writel directly.

Or make them static inline structures which take the driver data
structure and an offset within the register map for the device and do
the maths to resolve the actual address.

> > +static SIMPLE_DEV_PM_OPS(cdns_spi_dev_pm_ops, cdns_spi_suspend,
> > +                        cdns_spi_resume);

> > +/* Work with hotplug and coldplug */
> > +MODULE_ALIAS("platform:" CDNS_SPI_NAME);

> Not sure, but I don't think this should be needed.

It won't be used by DT systems but it is good practice, especially with
something like this that clearly is a generic IP which could be used on
non-DT systems too (it's not like it costs anything meaningful).

--nYySOmuH/HDX6pKp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTJvVKAAoJELSic+t+oim9NoMP/3CVL2JtmNVGnAlppFjd9mMJ
LtioqcpAiBYfuq/ayoHIQ1JaZYmjTPMvMty9TFetCAhGy2g6lFnlNll15vtnKj/g
Y9El2X3L8HwNw48jkcV180vBxi5yxGtWjoaM4o1wCewsTwhNiZwC5F0M/ytagORb
BUJgptmgAv9/dF1Nq+nxJONmJ8avR48PKPeY06950oWtrwWFNJ05g0yC04ZQCzoF
w3yoPdYXQANLT4HMI4St7qVu+CO6+q/0u+sqB9Ugi5aQijF7Q5kA7/mZHxtXAvif
mrBHru2O/Qh2E76rzu98xyq79IJ8Jb5vYR+hLauvPsO1wB1xmQ+iNu8bZc62fyId
APABMGlqcB+o/PbbQ1znnAjuaXWOs06nIGv62MEpI1ar+vrwgwVVow/rc8FN9K5o
OrzSYSdAR71CmLnW4upTnOsnV2TyBrwTEFt4cLQXsXWuo4g7Qg04DbPmILS5UYjM
NCkww40V+lnETl/IWUeVoIYzm+hU6Nr9J69oKAmt6XKbTkWl7lk4LQGM23rN6/po
4+ui+gkkHzeJfJS3RQGZNi2QVxjPWV6IEbBOaWVaGmxOPmI/CH5JS331pwSSLY0S
2oaY0MgLrsmtLACJn3G3iFfJ5PLalenlr1JKERm4LTCwLgvcLtVdQwSMn7kjhCFL
K5N9uzM0yG3kkWZHuQTJ
=ISNL
-----END PGP SIGNATURE-----

--nYySOmuH/HDX6pKp--
