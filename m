Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaKFQDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:03:19 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46512 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaKFQDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:03:11 -0500
Date: Thu, 6 Nov 2014 16:02:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Rosin <peda@axentia.se>
Cc: Peter Rosin <peda@lysator.liu.se>, Lars-Peter Clausen <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141106160241.GM8509@sirena.org.uk>
References: <1415278441-27866-1-git-send-email-peda@lysator.liu.se>
 <1415278441-27866-2-git-send-email-peda@lysator.liu.se>
 <20141106133720.GG8509@sirena.org.uk>
 <8798d3c4cf124aa9879225d08d8477f5@EMAIL.axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m8OSOHsVCl6s45tG"
Content-Disposition: inline
In-Reply-To: <8798d3c4cf124aa9879225d08d8477f5@EMAIL.axentia.se>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: tfa9879: New driver for NXP Semiconductors
 TFA9879 amplifier.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m8OSOHsVCl6s45tG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 06, 2014 at 02:37:31PM +0000, Peter Rosin wrote:
> Mark Brown wrote:

> > > +	if (tfa9879->lsb_justified)
> > > +		TFA9879_REG(codec, SERIAL_INTERFACE_1, I2S_SET, i2s_set);

> > Why does this need to be reset every time, shouldn't we just be setting the
> > register in set_fmt().?

> Yes, I'd sure like to do that, but how do I get to the width in set_fmt()?

Oh, this has some width related thing in it?

> > > +	{ TFA9879_MISC_STATUS,		0x0000 }, /* 0x15, read-only */
> > > +};

> > > +static bool tfa9879_volatile_register(struct device *dev, unsigned
> > > +int reg) {
> > > +	return reg == TFA9879_MISC_STATUS;

> > If the register is volatile it shouldn't have a default value provided.

> Then I misunderstood what volatile was meant to do. I'll just nuke the
> function. It works fine anyway...

A volatile register is one that the chip may change autonomously (eg, an
interrupt status register).

--m8OSOHsVCl6s45tG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUW5ugAAoJECTWi3JdVIfQqWYH/1ePW+CKQjzMlhMYefy/HF2F
NQlY6DOpUFOpxNYtFIVeWYXgP3YlcyHGLlT9Ym/Cpu2unSVq4Edoqvt66OMn4jx+
QF4BE2AJvohaPPZYb30ndZfBQ3pdHW9A08fPeGLCp6LiTTZqulNk/z22VtIOF1M+
ib+8+eT5hXKEcDPv0JGE594RPKVWkWs7lh6GWtrZcg/ri6Up2XWRMMf9HJGiwBsw
1bpkORGhHzMfrVEm2wZv0wJUwtKgwMKfOuV4ff2/qSHoMhjTLH4pbL/RRtRD8VeK
po25v923vwFAjkMxoA1Z7W1YgRLPGGkldMzgPZ41DsWB7pByHRqy15Xz9hKVYXU=
=2ICw
-----END PGP SIGNATURE-----

--m8OSOHsVCl6s45tG--
