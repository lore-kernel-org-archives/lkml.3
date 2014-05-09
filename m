Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbaEIKdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:33:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39063 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaEIKdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:33:31 -0400
Date: Fri, 9 May 2014 11:33:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chiau Ee Chew <chiau.ee.chew@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>
Message-ID: <20140509103315.GJ12304@sirena.org.uk>
References: <1399559431-2065-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oHvWihI+f7iV74d0"
Content-Disposition: inline
In-Reply-To: <1399559431-2065-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/pxa2xx: Prevent DMA from transferring too many bytes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oHvWihI+f7iV74d0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 08, 2014 at 05:30:31PM +0300, Mika Westerberg wrote:
> In case we are doing DMA transfer and the size of the buffer is not multiple
> of 4 bytes the driver truncates that to 4-byte boundary and tries to handle
> remaining bytes using PIO.

...

> While investigating this it turned out that the DMA hardware doesn't even
> have such limitation so we can solve this by dropping the code that tries
> to handle unaligned bytes.

Is this definitely the case for all of the IPs using this driver?  It
seems like something which might have been present in actual PXA
implemenetations but got fixed in later revisons used with x86.  Equally
well the current code is clearly broken either way so I'm not sure that
problems with older systems should be a barrier to merging the patch but
it seems better to check.

--oHvWihI+f7iV74d0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTbK7oAAoJELSic+t+oim9FMUP/jRlwTJTd0UsV/ppYjS0p3rc
B0P2rYKrGLP1KMCA0NLjyA7JjAOgsAGmqC/e/9k8uAxqUYQTk+hVpsASOAM2uIjh
OdXAHuU4nTqIBdTzBMwdaxiJx7y9LHCtbCVgEmkkfFbHtMFroXhXsqM3LmGzujZe
GQK24PUL1feOQlbqfb87NKq100K8vdTiqXqFIM0CWvHjGRQAAgtLzEe/5erW047H
HY2I3NN24xTmkGFFCDfhqkaeoJGCP3JTe4nOiKvF4iFCGzJ+iShB0yu9BB8EHEba
rHG4JwQUh5uPYAUuQgpo2IK5WSyr9RJEh+kBGf6vyZrJ9XioLkqHZ6G2YrcWZCbR
2Up4mT7LzmZzajpoc0VWX+xkeM2MuBkfoarl/OpGM7NfEaw7CTDMboynESp5toLn
igL85zJAwRZgTadnnX3c9o5Kd83Kplhb1TXKe5a7XYszqUFULjNWvheE/zotDjqE
1X6vuNaEbKvCxqtnvll78HL3ouhjuRPry7PMyi9gQszh1PBG1ehpLUat/AumJHXr
84GJlPcQzPNUgyuS3Fs57SQnCacOoUhkRaPX1VvQxgSm+nQA/l53PktLK4vdsm6R
heNwu22tIQIgqEqzWmz/OkHSLU78BgxNYMBZThXTp6ui2ITyg3PKTpJ5k3PNeq3T
f2ruHOJNzy5l75iqdgGX
=xhCJ
-----END PGP SIGNATURE-----

--oHvWihI+f7iV74d0--
