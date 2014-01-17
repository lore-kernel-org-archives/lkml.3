Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaAQStN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:49:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56130 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaAQStK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:49:10 -0500
Date: Fri, 17 Jan 2014 18:48:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140117184857.GH17314@sirena.org.uk>
References: <1389861887-32721-1-git-send-email-Li.Xiubo@freescale.com>
 <52D854A3.5090109@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PK5kSfjks5jzTD3m"
Content-Disposition: inline
In-Reply-To: <52D854A3.5090109@metafoo.de>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: core: Use devm_kzalloc() instead
 kzalloc()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PK5kSfjks5jzTD3m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 16, 2014 at 10:52:35PM +0100, Lars-Peter Clausen wrote:
> On 01/16/2014 09:44 AM, Xiubo Li wrote:
> >Makes the code slightly shorter

> >Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>

> I don't like this. I don't think it is a good design pattern to call
> devm function from within (especial non-devm) library functions. It
> creates an asymmetric API. The memory is allocated when
> snd_dmaengine_pcm_register() is called, but it is not freed when
> snd_dmaengine_pcm_unregister() is called. This goes against the
> principle of least surprise.

Yes, I tend to agree - unless we only support managed registration the
API shouldn't do managed things internally.

--PK5kSfjks5jzTD3m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2XsVAAoJELSic+t+oim9uNsQAJ2JwxMmow9JY0Vy0YCjZCNh
mqQB0CRPLmYrQGUXv9iqCEcLfHxkB1t8TTeTGMvTqCW8Xhomc0GWUDXMRAi5x8wr
PPMdpxrBtb0qFHUynnovgyBEN7XOBT9/rBt5c5PLTabh3+Qqjl0cx/Z9zMDMvDWE
5b++M+uqonqvTsewDoW1lF8wSLJVMDsvgojnMINKeJPfuTcd5Np41uoUbutdHlf2
XFWcOGQ5Ky2HiRBvOqpIi1XGJwdqAUa0OrwqjPRpiBh9z27F8ZoDBg8l6SGE3q2p
6TgK6pBVQTa5n78pc+ixvORCGWE3GSXtkDH+nqP/PaxG2QBLRUCKWkT2P8QlAUtF
j4IIVoTjOhB2uo37uRLwJBNJPZXL6qePomTv4HBd7J1yXxEUbsNGHLfWHO3PA5O7
3pcqlXXR3H0hlcEV7YsNs88lAh/G8W4eJGdBbbQ+6AqvuevrwGwdK3h2xxHNa4YM
iAGSQrbQw3jim3O8xkDwsuvB1/SYPMsKS9IVjHD4sP1QtjBq8Cg/lBH6pop7lI0Q
Ka3vu4p7WSUh27o+iz+/WUZc9yeljgWr485oQtqU/+z+d5vvkhTh2+gsHdFVU3mf
KPpPAZB8QhnRPUbAHvhDvc+6quD6u+KV6iF+rq09l1pF6nJ7rvilgEnfQPQ911xS
EsT9FxYGZl/KBimmXsq3
=5UKI
-----END PGP SIGNATURE-----

--PK5kSfjks5jzTD3m--
