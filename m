Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaJ2KDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:03:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54866 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbaJ2KDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:03:05 -0400
Date: Wed, 29 Oct 2014 10:01:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Message-ID: <20141029100142.GR18557@sirena.org.uk>
References: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
 <1414411911-5539-4-git-send-email-k.kozlowski@samsung.com>
 <20141028223121.GH18557@sirena.org.uk>
 <1414574413.18868.6.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w0wZBAr4bXcLEtGS"
Content-Disposition: inline
In-Reply-To: <1414574413.18868.6.camel@AMDC1943>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 3/4] regulator: max77686: Add suspend disable for some
 LDOs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w0wZBAr4bXcLEtGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 29, 2014 at 10:20:13AM +0100, Krzysztof Kozlowski wrote:
> On wto, 2014-10-28 at 22:31 +0000, Mark Brown wrote:

> > This looks wrong, you're using the regular enable operation as suspend
> > enable.  How does that work without disrupting the current runtime
> > state?

> Currently it shouldn't disrupt state of regulator because during runtime
> it may only be only: on (0x3) or off (0x0). Suspend enable in max77686
> writes 0x3 to the register which means - always on.

> If regulator was disabled before suspend then it has to be enabled
> during suspend_enable() call which is exactly what max77686_enable does.
> If it was enabled then nothing happens.

No, this isn't suspend enable control - this is normal, standard enable
control and the device has no suspend enable control.

--w0wZBAr4bXcLEtGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUULsFAAoJECTWi3JdVIfQiuYH/iWJKED6NduyTeJ3iAPinvaV
Up12xpaV2BREaXLUmKREHa9baR916FjDK0llYKsXMc834nPX1OMcQZ0qnE5ntV0h
UOkzG0HeziKpXS8FPQKrRhTvmjgrD3yazQX7mtExLOFX6Hq1iEOC0IwOogrfeNYH
HpyXwUUlz1xjH1BCyIF5A6T6XOfZTeC/d/azIKfTilwUOb7IkZnLRPedvQlf+nxG
nA+70NoeXk5gNUFbywNp+aLkAT80Qva59FMGT/y2xyC/9I24ybLByTkOsQiRw69C
HrONRFWRSXxqe7JTU6n7262RDd2BetmKeLrC7K+x4F/s067NQ50Y7srCnrkQvDY=
=huVf
-----END PGP SIGNATURE-----

--w0wZBAr4bXcLEtGS--
