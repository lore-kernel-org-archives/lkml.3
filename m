Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbaHEQg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:36:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:48234 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbaHEQg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:36:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,805,1400050800"; 
   d="asc'?scan'208";a="572061480"
Date: Tue, 5 Aug 2014 21:55:45 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
 dma controller API
Message-ID: <20140805162545.GX8181@intel.com>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140730160607.GM8181@intel.com>
 <20140731074440.GY3952@lukather>
 <20140731115628.GQ8181@intel.com>
 <20140731162330.GE3952@lukather>
 <20140801171306.GF8181@intel.com>
 <20140802144925.GJ3952@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cN519qCC4CN1mUcX"
Content-Disposition: inline
In-Reply-To: <20140802144925.GJ3952@lukather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cN519qCC4CN1mUcX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 02, 2014 at 04:49:25PM +0200, Maxime Ripard wrote:
> > - residue callculation, though situation is much better now but still l=
ots
> >   of driver do it worng and folks do get it wrong
>=20
> What mistake in often made regarding the residue calculation?
- residue is for the descriptor asked
- not for the current active one
- we can store the size locally and return that when not processing
- arg txstate can be null

> Another extra questions arose during starting this.
>=20
> In the case of the call to device_control, especially in the
> DMA_SLAVE_CONFIG case, but that also applies to pause/resume, are the
> changes supposed to be immediates or can they happen later?
>=20
> I actually have in mind the case where we would use a vchan, that
> might or might not be actually mapped to a physical channel at the
> moment where the DMA_SLAVE_CONFIG call is made. In the case where it's
> not mapped and not transfering anything, it's pretty trivial, to
> handle, but in the case where it's actually mapped to a physical
> channel, should we push the new configuration to the physical channel
> right away, or can it wait until the transfer ends ?
Ah no. The model doesn't assume the config will be written runtime. So the
descriptor which are already prepared doesn't change with DMA_SLAVE_CONFIG
call. Only new descriptors will take those values

But yes the pause/resume would be syncronous

HTH
--=20
~Vinod


--cN519qCC4CN1mUcX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJT4QWJAAoJEHwUBw8lI4NHd1EP/RSVwsr4gPAE+kzSsB8xR/NS
yjJ3YrgZHeVLCMYN4v0LDT949j1A/t2kSKKDqf6a1TaXyNOgHHz2LtEdbMreUjyb
b/14R1JCAbfo4L5mZOtcMVaJogEE8MajI5d/WGsstBlqygPU9aoC28LEwYUu1maU
VSuI3A8hylQyM6oXOVETpaHSnQTTzu9NLq97aNLxFznRPiJG7Xk3eaGvkX7NMCxP
yIbNGCgMW2zicdCq4YrIsy8HzjuHV8APc6yKflqBQpYtjDF4KCB6LYT+ucZ5Yv3K
o+f0k6AMOOPT9qyHOs1l20fGqOXLRIzJR2L75hirIAoJALtYIKwpBCcSKdxXZIlj
SF7GVxdFc0DAfKOGhuXtYqEQ5JN6OkRl67XtDmQgqP1gOiu+Xc9uRu5sQnW+CiPx
q4BNYE2gDC1I3zMkMyq7qaxcJ/9+J+E1C49DH1z3Q6t2UZCE7/S5H8GuJdGbrwE/
j+WsM5qHP4Pv03t7bPebNdttSm7Qa63NonESWd/KxvA0C6Je5bKIM2e3Q7yzSJdH
QEhGvTKwpx+xT8p5+KtLU3h8REAQWymwJO7i/ZMTytB7IQ46Rth2oxsgwMG0huuy
9NmKvDBR4feeRsKlcsjiHkuuivUpfcZhHu1s4EmMxPFPSCMQxQ5h204SW3g6WBkF
4Xd2Lu9RIttH8QL2g4ot
=OTKw
-----END PGP SIGNATURE-----

--cN519qCC4CN1mUcX--
