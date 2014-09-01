Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaIAMuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:50:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44709 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaIAMuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:50:09 -0400
Date: Mon, 1 Sep 2014 13:49:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
Cc: Dirk Behme <dirk.behme@de.bosch.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Message-ID: <20140901124947.GU29327@sirena.org.uk>
References: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com>
 <20140829190129.GZ29327@sirena.org.uk>
 <5404246E.4090908@de.bosch.com>
 <20140901101512.GK29327@sirena.org.uk>
 <54045FA6.70602@mentor.com>
 <20140901120602.GT29327@sirena.org.uk>
 <5404680F.3040308@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zltv+KEU+AMUCOPj"
Content-Disposition: inline
In-Reply-To: <5404680F.3040308@mentor.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: GPIO #0 is a valid GPIO
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zltv+KEU+AMUCOPj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 01, 2014 at 04:35:27PM +0400, Dmitry Eremin-Solenikov wrote:
> On 09/01/2014 04:06 PM, Mark Brown wrote:

> >Please consider my point about making users instantly buggy - it's not
> >practical to introduce a new field into existing platform data which
> >needs initialization.  Disallowing the use of 0 as a GPIO seems more
> >practical here (in that it's something the platform can control with
> >more reliable coordination).

> I think that this makes other users buggy - those, whose platforms use GPIO
> numbering starting from 0. IMX platform does. legacy platforms do.

It means that they can't use this feature for these specific GPIOs
unless someone writes some code to make it happen either by renumbering
or by adding generic code that provides a way to specify this, it
doesn't make anything worse than it is already.

> Consider NO_IRQ which is still defined to -1 on ARM platforms. If a device
> does not have a connected IRQ, it has to explicitly specify -1 instead of
> specifying logical default 0. Is it so? What is so different with GPIOs and
> regulators?

As I'm getting fed up of pointing out we can't make existing users buggy
- we couldn't do it when we added support for enable GPIOs and we can't
do it now.  Exactly the same problem would occur if adding platform data
to specify an interrupt where none was previously specified (which is
why there's a move away from NO_IRQ being -1).

Please, you need to care about other users.

--Zltv+KEU+AMUCOPj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBGtoAAoJELSic+t+oim9eK8P/jH/Wuo6BilJYiLXrSOtzLsa
RHt9qMGgsAXSLJti38oaEDfHNwSoFCHNp2+wepxDs9GygdHoVgcKoAh1uWIkAzV5
aYL6wZ5bcTNZeCsa99HLA83SSxix4jFuTrtplVaKpJ5tcxpgkj1wMFkLTjQS4oOa
mI4te7xaPUpSPUd9iiNSIRWts0bjGXVN4I1f6nEMEgkzRTriHwQeVT5bgVvR9Btd
ILQExZyRIh+3V3GXO1i8J3BnGca1zP7TZUtK4yatC3X53YUhzssx6YLsvv4dfixC
tfWBwfC0X31gF50Vr5Hzlx1bX+0ZyXeHD9l+rrER99Njr52sSWFdafbi/H88lb3j
r/U/ioXBmEREnuu9l+QLX/ds8SXtFat0vipjAcmtQ/jNV7aggnA08F2sDzFIWDd5
FEXA9XfBrGSEKK3S5elXmB6tdYy+3J0fHzh5YE+T2r/OOYTY91SauzsqwkOp9YmC
3CuvVa066f4znTbko1q6oc3rJNkMXP9Ls8Kv0/96k8ukDPt5C+1D9B5Js+CdcZyK
D68S898ki7FjfDMBeLEvrqi0Fx5g3zm6BYVy4CjKBUSjakzmgiKy9pBJB+FXiCnV
rshkK4S28wFVV1NH6Nx7OcGJ4plmXoPgZbQ/0YMTx/6fUwS1mRrBNnnnkPps1laE
P5jTV4C26D3XCHqbULGG
=UdWm
-----END PGP SIGNATURE-----

--Zltv+KEU+AMUCOPj--
