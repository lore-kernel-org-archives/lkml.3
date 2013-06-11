Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3FKKtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 06:49:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40354 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab3FKKtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 06:49:35 -0400
Date: Tue, 11 Jun 2013 11:48:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux@arm.linux.org.uk,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Prisk <linux@prisktech.co.nz>,
        Alexander Shiyan <shc_work@mail.ru>,
        Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <20130611104841.GX1403@sirena.org.uk>
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com>
 <1370856118-6503-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7WMexqIhC8AwFtpM"
Content-Disposition: inline
In-Reply-To: <1370856118-6503-1-git-send-email-srinivas.kandagatla@st.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 03/11] regmap: Add regmap_field APIs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7WMexqIhC8AwFtpM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 10, 2013 at 10:21:58AM +0100, Srinivas KANDAGATLA wrote:
> It is common to access regmap registers at bit level, using
> regmap_update_bits or regmap_read functions, however the end user has to
> take care of a mask or shifting. This becomes overhead when such use
> cases are high. Having a common function to do this is much convenient
> and less error prone.

So this looks basically good.  A couple of smallish nits below, if you
could respin I'll apply this on a branch so it can be pulled in as
dependency for the other things that use it.

> +	regmap_field_init(rm_field, regmap, reg_field);
> +
> +	return rm_field;
> +
> +}
> +EXPORT_SYMBOL_GPL(devm_regmap_field_alloc);
> +/**
> + * regmap_field_alloc(): Allocate and initialise a register field

Needs a blank line between the two functions.

> +#include <linux/device.h>
> +#include <linux/slab.h>

> +static inline void regmap_field_free(struct regmap_field *field)
> +{
> +	kfree(field);
> +}

> +static inline void devm_regmap_field_free(struct device *dev,
> +	struct regmap_field *field)
> +{
> +	devm_kfree(dev, field);
> +}

Probably not worth inlining these, just put them in the code.

--7WMexqIhC8AwFtpM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtwCGAAoJELSic+t+oim9juYQAJPLATgvMslyR8CbZBdkMYrr
5JHA77lEL/wOXbk+rdvqP6W82d12p/3UGgKIOvINb2bvadCQXmkJr1wdpwXx3cHO
cCqQ1aOt49hx7QS7i751s/f9k6kMQbdEYH8AjvG/CzlSZ8HM0bHPoIbDSpTWutPL
scAzrnEHVKGGC2XPgNF6fjCDiIfg9KtaLf+vnCIL7Yddlj6uEtcv+j2LaZsqy9CM
ZuITB3V21AJ7uKpQRFvU3jhp9lbsTfWAt0vYZqU8ysuoMmKhRbrEy4pFosV9aTAQ
JEW28Wn8qqZPVO57GFCuEc6HPN2+Rjr2ap2CVeoHNK7Spobwv9Q+JaRjm340eU1E
FVjshYADBVejTSz4zwwuU7T1dZaGxJ6P02NHF3Wi/cvWla7s2KOAf9tG6MZueufu
kMneeHgJpzSNnHgJQyXHElGUDwJi9GFkz+yfnsnBs9tTxxAKs9GJtUp59K/Lv4JH
g0vpUOyNAXD/wl/LrTgS7197KSaGM+xnQDh3LtNvFfqvVAp1+qLLAiAzblcDSmLc
q3RRSAJ+mRZAv7MlpQyJP9fSykRZMjYU65eTewo/gwW7gS+/JVd+v+H/nT15Eotv
bgY/pnRfEr+Sw1Wb3WOARQbnTAZM/ieua3Ira44nNJqsl12u/k2DE5XK6lVOquee
aTYlrj01KDxafDg7vfka
=BL7K
-----END PGP SIGNATURE-----

--7WMexqIhC8AwFtpM--
