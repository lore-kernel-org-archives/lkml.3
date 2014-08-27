Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaH0ITF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 04:19:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35537 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaH0ITA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 04:19:00 -0400
Date: Wed, 27 Aug 2014 09:18:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140827081848.GT17528@sirena.org.uk>
References: <1409061793-10495-1-git-send-email-jarkko.nikula@linux.intel.com>
 <1409061793-10495-2-git-send-email-jarkko.nikula@linux.intel.com>
 <s5hk35vpc18.wl-tiwai@suse.de>
 <53FD7210.606@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zGlgLj+CIucDe5uN"
Content-Disposition: inline
In-Reply-To: <53FD7210.606@linux.intel.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH 1/2] regmap: cache: Fix regcache_sync_block
 for	non-autoincrementing devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zGlgLj+CIucDe5uN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 27, 2014 at 08:52:16AM +0300, Jarkko Nikula wrote:

> I don't know. I was thinking that also but was unsure about it since
> regcache_sync_block_raw() and regcache_sync_block_single() code paths use
> different regmap write functions. regcache_sync_block_raw() ends up calling
> _regmap_raw_write() which takes care of page select operation when needed
> and regcache_sync_block_single() uses _regmap_write() which doesn't.

> Which makes me thinking should the regcache_sync_block_single() also use
> _regmap_raw_write() in order to take care of page selects?

We can't use raw_write() for everything since not every bus can do a raw
write.  We probably need to push the select_page() operation into the
_regmap_write() path though, it looks like it's getting missed at the
minute.  I ought to redo a lot of that code to simplify it, it's got too
many tentacles at the minute.

--zGlgLj+CIucDe5uN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/ZRlAAoJELSic+t+oim9HV8P/30CkoMraUeiG5vGAUAlXjar
6lKmydP6DqdX3N0DI0yvAgwycNXH4FPIItkiAcHK/rIaNr/+1J4zYt1WYqSrqR4O
vs6uHjY7vTW10Ezcxm6Gzf4NPRApM23HiWeV6r0INLhULp+8O8NEgCJUV6kFTx13
+69dedhwjR65umLc1z3wrwJeQp7or3Rcriree3SMh6mXgE2Kw8odVAQHfhsvtge7
LyHqCyXFtYvbDVve3hDtFWCRkrovu2+fzOeKCB2hR+FM99fJe6MW/G80REp1iPIC
Qxq+15J0S7FqPOm46WOBA2TT2JpT+1JgcQ3DwF7roYn6kIIhs0sNiOX6WcYIAwIk
78Epx9wLl5eScN6dXN8mMMRZBBLFoGx0JxnAQGlL369u2iimx4APgu5q1rBxWL5V
zkcWzo7uB6A8KRvaBty8QTaAjTtG201lTEfLYAaQDVmdHcXg3FRxmREcQURdAAJa
WhmKNGo+cluGEf8hyidgojFpfS8339WQ9q8TR1Y18bl0S5mTPbWH1KMRPGhiifiW
Qpc7LxrusZnFRMlgjxnn4ojHhpQCT8g8Kq2AAerEZ3LY83Y50RV1QxdbFWhysQVk
6S5vaEgIBQzxXtMr1p5tcVLVzGHiP+UnkkNcHou13tdF1p/5pNVZRA/5mNB5DmAI
BjGR4asHwFObqokqP6Ha
=IL0F
-----END PGP SIGNATURE-----

--zGlgLj+CIucDe5uN--
