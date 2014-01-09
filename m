Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaAINfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 08:35:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50006 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaAINfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:35:06 -0500
Date: Thu, 9 Jan 2014 13:34:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20140109133456.GN31886@sirena.org.uk>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
 <1387815830-8794-7-git-send-email-pawel.moll@arm.com>
 <20131224124538.GZ30815@sirena.org.uk>
 <1389272911.23721.49.camel@hornet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ALNRjWLfQTkRYwC"
Content-Disposition: inline
In-Reply-To: <1389272911.23721.49.camel@hornet>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 06/18] regmap: Formalise use of non-bus context
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0ALNRjWLfQTkRYwC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 09, 2014 at 01:08:31PM +0000, Pawel Moll wrote:
> On Tue, 2013-12-24 at 12:45 +0000, Mark Brown wrote:

> > The obvious question here is why is this callback useful
> > - what is being allocated in a regmap specific context that needs to be
> > lifetime managed separately to the thing doing the creation?  I can't
> > see any obvious reason why this would ever get used.

> First of all, it's just a generalization of the free_context already
> existing in regmap_bus (and used by regmap-mmio). And in case of this
> series it is being used to release extra resource added allocated for a
> "busless" regmap_config. Briefly, I'm using devm_regmap_init() to
> "attach" a custom regmap configuration to a device when it is being
> created (which is then dev_get_regmap()-ed in the driver, as you saw in
> the regulator patch) and its context is a pointer to kzallocated data.
> free_context is used to release it when devm resource is being removed.

> Does it make any sense?

To be honest not really - the above sounds like you should've allocated
the memory using devm_kzalloc() or just embedding the allocated data in
the driver data for the parent.  Internal things need to clean up after
themselves but users should already have a larger context of some kind.

--0ALNRjWLfQTkRYwC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzqV9AAoJELSic+t+oim9Pr8P/3cIcr3AKBd8gBSKfzrdXaMC
ppZbslr6845G6/qGZCg2GIw7QQ+JCSOjJKEvCZvN0DcV38CnfcpquBe/NyuTO6Hb
InleH+qfHGJFjrb5wonF0mUEM3bsoEpU+531HL+aivKBK5A2YGy2zTChE0xt+H22
wiSuw8zOgiVtvjhWGj+1FftTzp2Q91vw1wrsNiQDR/rPFw2pVu7H5/f/tsvmbPif
uM317VRT+P+nkVaA5RdOnhAYb0IkvpfCHATbys6yyy11fHBbgAjKj0/6VogdvV3x
TWWDDPWIl+SBG+igGX3NSVYJI9Iw5Ak7yw2ILT/Y95gvtEC133mHPW2420IBh8do
Pf1hntjcgEt8s6ZS6Q7i795CxHvyYcXW3QADlhsAWryP6BCZCPNyFY/ggFZw19n2
1fZ/fpwWqNVam5twizeVgfW3poJwhBar5venrqBsD2yF5XtEAJdGVGYa7B++1bas
1Qu6P/DT9xfLJeeYI8TqUhVrrW3f4rd+7bmcOLkGh5hOuo00ynXm19WzyEJYaiZO
rIKF4ElRsY8anai20NbiIDHlD357FgYNsEMVBm6u6hzM0yXJDsgedKFmWY8Ti4SA
zl5AxfPz7aRRLrPPubuf2ODyoaenRK3WlLCXf+hPYq/IOE/j5+HOfVUnTIUSJMcH
Mc6AG4XqGEzumc5TNZvL
=UFqw
-----END PGP SIGNATURE-----

--0ALNRjWLfQTkRYwC--
