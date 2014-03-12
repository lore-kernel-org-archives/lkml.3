Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbaCLBx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:53:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54305 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162AbaCLBx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:53:56 -0400
Date: Wed, 12 Mar 2014 01:53:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        linux-spi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20140312015342.GL28112@sirena.org.uk>
References: <1394541891-26469-1-git-send-email-jcmvbkbc@gmail.com>
 <1394541891-26469-2-git-send-email-jcmvbkbc@gmail.com>
 <20140311194959.GB28112@sirena.org.uk>
 <CAMo8BfLTn+pneF6_7XkP66+LzpZgcefnAo_FkwxpvtYdt9yduA@mail.gmail.com>
 <20140312003401.GE28112@sirena.org.uk>
 <CAMo8Bf+dePYf0jW6zaH-4Qiy5oF-bBzHjkfzL1u6pyTS1OE46w@mail.gmail.com>
 <20140312010858.GI28112@sirena.org.uk>
 <CAMo8BfL6dwgZitRBZQEU6HCRVMRoYhPkiJWW5QTpS-cu-njR5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xfe3G8JgwIlIkDdn"
Content-Disposition: inline
In-Reply-To: <CAMo8BfL6dwgZitRBZQEU6HCRVMRoYhPkiJWW5QTpS-cu-njR5A@mail.gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] spi: add xtfpga SPI controller driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Xfe3G8JgwIlIkDdn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 12, 2014 at 05:43:49AM +0400, Max Filippov wrote:
> On Wed, Mar 12, 2014 at 5:08 AM, Mark Brown <broonie@kernel.org> wrote:

> > That's buggy, drivers should never configure anything more than 8 bits
> > per word with regmap.

> Ok, so the driver should allow for 8 bit transfers and regmap will arrange
> transfers as 8-bit pairs, making CS to be asserted for 16 bits, right?

> Hmmm... I see the only way to support that with that hardware: advertise
> 8 bit support, buffer bytes up to 16 bits, send 16 bit words on CS deassertion
> request, log violations verbosely. Other ideas?

That's about it.  Like I keep saying for any sort of generic use you
really want to support 8 bits per word.

> > You're missing the point.  The controller chip select line can do what
> > it likes, it's not connected to the target device if a GPIO is being
> > used.

> In my case SPI controller is wired directly to the codec with three
> wires: SDIN, SCLK and CS. There are no registers that can control
> either of these wires independently of others.

Right, but other users are likely to exist and the framework has support
for this so it's not much work to support.

--Xfe3G8JgwIlIkDdn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH74iAAoJELSic+t+oim99ZgP/2XblUxQAnMnwczoMFjcMCDV
8/k3lRBjIe/dYU8weCOAkgbEOCpp4s2jkogSIbaw44I6f16W8odIZc/gIcuatrfm
plWllTSF/BFPhQ5BCNLIfmTFNRndsHPDM21Df6hXU4P5P8ub0kqKyoeQ7xLO7bY4
eE1DOSZgwWNUNKO1oN2Gp4wNhLMurGP+CBTrttFdxLW44S64K0U1ZrC41yUiqPHK
Eme8YCw+9hKeb+8IY19JadSSIgPIdsOvvoAP3PIgosq25hytGQJ/PSf3XE7sCiA7
qcY9VwmiwhET/w+OSPGltRByXrFadJLFXieni5h6Z2AAucljv8lGRj2AcAHb1lD/
gK0+Ttn11V79+n1uzHl53H4s/g3kg2RFcQpVdROrokEFBlzClNSHdUBpusMeezGi
5HGfKEJRyHPEeH437mlvRveAwtCLsjHa7I8KFQ1lLYHEGtkK+XbQl9AQVAUrlxvv
ve4JlpFOHTcUSv1fyaB8X3m236zooOXRNlHnfS8yzRr8g8YH38RUw4jTM8BZ3kvn
KWD8dtp7bhmEVx48HprfmjaYh37NzJiIgRocgTAKDIwXRiPa0k2IbEzwa7g2KfDt
13GluGMhHeizDktISxISJGHs0sSt64boeUOaYOZGKrG1Q6A4VPkPmEkxmR5xzDIQ
dyBWFiujLYmWEuirYw2n
=TgE+
-----END PGP SIGNATURE-----

--Xfe3G8JgwIlIkDdn--
