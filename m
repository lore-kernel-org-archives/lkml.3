Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3GOR5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:57:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56894 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab3GOR5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:57:49 -0400
Date: Mon, 15 Jul 2013 18:57:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130715175726.GA11538@sirena.org.uk>
References: <1373906531-6938-1-git-send-email-lars@metafoo.de>
 <20130715172643.GZ11538@sirena.org.uk>
 <20130715165721.GV16653@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LG5jgFgJbJFFiAfj"
Content-Disposition: inline
In-Reply-To: <20130715165721.GV16653@intel.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 1/2] ASoC: dmaengine-pcm: Add support for querying DMA
 capabilities
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LG5jgFgJbJFFiAfj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 15, 2013 at 10:27:21PM +0530, Vinod Koul wrote:
> On Mon, Jul 15, 2013 at 06:26:43PM +0100, Mark Brown wrote:
> > On Mon, Jul 15, 2013 at 06:42:10PM +0200, Lars-Peter Clausen wrote:

> > > +	hw.period_bytes_min = 16;
> > > +	hw.period_bytes_max = dma_caps.max_sg_len;

> > We can't read the minimum period size from dmaengine? Seems like
> > something might have a restriction other than 16 bytes here.

> max would be how many list items the engine supports so queried therotical min
> would be 1 byte, not sure how 16 bytes is assumed above but my guess is that if
> engine is able to push min burst lengths which would be 1 and give you
> interrupt. But seriously, that would not be practical. So this should be a
> realistic limit which system can cope with.

Right, we probably want to set an artificial floor here but it still
seems like we should be checking that the device actually supports this.
If the hardware can only support 64 bytes then the above code won't work
properly.

--LG5jgFgJbJFFiAfj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5DgDAAoJELSic+t+oim9OuUP/ArcS/0NdnJ7kanUhVn7Ax0/
/caC6QIKNerQWOD48ly7PxKtsG9EBPCj/UEbQkAi9GpcsIaCOvmV+n0tFhpTzgPO
OoJAzgxFMYsMCXjzQnyFZpHbsniz+Pkliz8cCX5xgkmXac9kYGd8DYshkQO9Ws5+
Z9FAkYt9VlE14e8q9jVd3tMNilkCWbo1nE3LhZiuQ9OoezZHWaZtCCBvx8/6VqwE
bLnDLfoP96kVxFq7Fb7CD/rNyPk3NynrFOiAdgCuwJDGCSR6d6KxJnKdUucD/xoE
laj3cVDMRPUGJpeSI/1d27SHFiDZJwPKOmaKs2k62qaNavN8vgAQnnO6oDxIkP9T
duN/+QQrdjNhX6zjTFXbIgUxtKZeF4BHN4W6I7nJUn/gPYOPZWt9vXju41wXdWQF
6WwJaBlXVg+aKGWFHZQidZBpeOkgVTyNZGPF7wS7cdhFxMUxZp0A6B9ondOS5MRz
fPlczj7vd2REJ5BDf+QfZXScSWn4EJQWXwqUHI5flXhlMHyJ9v/k7RSIgJI3SX95
zkTElOOU2pYOdnQlZgnElkUJUt5D6P/IEmYlgkMtPOlmIIHv1OU5IRTght7pcdjc
gWB0aKPjbZrurThLfqLbeddDtlq7z9Qe5vxEM/e5FXoBgCzxJLUNn2Q96+GrWY8C
fAhD9sB9Of3VeocJoedn
=h2Cj
-----END PGP SIGNATURE-----

--LG5jgFgJbJFFiAfj--
