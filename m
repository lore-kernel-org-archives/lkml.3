Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaHKMiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:38:50 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58084 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaHKMis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:38:48 -0400
Date: Mon, 11 Aug 2014 13:38:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org
Message-ID: <20140811123840.GB17528@sirena.org.uk>
References: <1406808468-12559-1-git-send-email-broonie@kernel.org>
 <CAAVeFuKv_Qd2u60zSYYKicahDcH1wKs2BVQRGhNsF9civT_S2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t+rWpiKzV+NkZI0W"
Content-Disposition: inline
In-Reply-To: <CAAVeFuKv_Qd2u60zSYYKicahDcH1wKs2BVQRGhNsF9civT_S2g@mail.gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] gpiolib: Don't allow drivers to specify a base with DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t+rWpiKzV+NkZI0W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 04, 2014 at 01:21:57PM +0900, Alexandre Courbot wrote:
> On Thu, Jul 31, 2014 at 9:07 PM, Mark Brown <broonie@kernel.org> wrote:

> > DT based systems should have no reason to use fixed GPIO numbers but some
> > drivers that work on both DT and non-DT platforms specify them anyway. In
> > order to improve robustness in cases where drivers use gpio_is_valid() to
> > check for a valid GPIO on data initialized to zero as a default and avoid
> > bugs due to assuptions about fixed numbers creeping in ignore any specified
> > base when DT is in use.

> I agree that DT users should not use the base number at all - but the
> fact is some of them are doing it. Aren't we going to break some
> user-space users that will expect to find a GPIO under a given number?

Is this actually a realistic thing that people do with mainline - I'm
not convinced that it's going to be robust in general (a lot of DT
conversions will have broken things for entire architectures) and hard
coded numbers aren't the sort of things that make it into distros.

> Also, how is this going to help with gpio_is_valid() against
> zero-initialized data?

I should have said check for zero instead, sorry - though making 0 not
be a valid GPIO would help overall.

--t+rWpiKzV+NkZI0W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6LlNAAoJELSic+t+oim92IQQAJQuGuEvLDa7J718ovqAPkBq
hib7/EktnLGfFWo5MzM4X6KRzU3yDz3kn4ILr+ukMBYmZ9PLyAqwnRvzZBTdCb9x
1mfunBCwcTiN3MZ5GxOiSh/f7kfQI8NDJsbSGZGdouL7ZpLD6eT+wP1y71REta9z
/gsHPOcjgw6sahCNhRBZ5Ov8TpgscvDe6LfCBcj0mBySh1DKzjXO4KpxLW83VcTt
kstXHgn2F5MGXf0HLDHi54tUNucZaz2Yo/6jmoxZy2pUaOM8euXvpca0vlXvejdL
Ok4AGm0VQ1tJhz6zU41erq3AIE2zmqVT6z6E3nMNYBr1F8QJ8CmZIFgbtN/ZuuTq
Dz7JY92w1TPkkim++XWVNCye5vprgmBDnN3drMcCaAIjhH66Z3TXys2EM5Tl7jgH
bD9MbyKAitpzbdLb9eLIgI+zLuk45bm++i6bW6EorXkQzf/PQ9cdrMa3XzqAKtHD
cXi/R9Rptkgd4qG+oPgOd7tcCZ3Xme4GIT03WpBa0g1DDs86ayZ2G7dY+71YiUip
lb/pFKwcWezhowtqbDw93ddJoHvnS78nwd7FROmvypm0R/8mh2XM5KJvOoooJzi8
RCf+lf3SA2G0KS2bZanOPuhmH+WkmBhTte5xYCRk/GkzHJM42kbXVRFW0EZSOq2U
irhRmFjwd9aau+TM4tqc
=j+k+
-----END PGP SIGNATURE-----

--t+rWpiKzV+NkZI0W--
