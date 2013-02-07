Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab3BGQkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:40:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32993 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758321Ab3BGQkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:40:03 -0500
Date: Thu, 7 Feb 2013 16:39:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 37/77] i2c: convert to idr_alloc()
Message-ID: <20130207163958.GY4720@opensource.wolfsonmicro.com>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-38-git-send-email-tj@kernel.org>
 <20130207152831.GA14797@sirena.org.uk>
 <20130207163247.GL2875@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B5JjOzmn0Nsc+m1x"
Content-Disposition: inline
In-Reply-To: <20130207163247.GL2875@htj.dyndns.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B5JjOzmn0Nsc+m1x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 07, 2013 at 08:32:47AM -0800, Tejun Heo wrote:
> On Thu, Feb 07, 2013 at 03:28:31PM +0000, Mark Brown wrote:
> > On Wed, Feb 06, 2013 at 11:40:09AM -0800, Tejun Heo wrote:
> > > Convert to the much saner new idr interface.

> > > Only compile tested.

> > This broke I2C for me in -next today, I saw a spinlock bad magic error
> > calling pm_runtime_enable(). =20

> Hmmm... weird, can't see where the difference in behavior would come
> from.  The only material difference would be if id < 0 && id !=3D -1 in
> i2c_add_numbered_adapter(), which now would trigger WARN_ON_ONCE()
> inside idr_alloc() instead of silently returning -EINVAL.

> Can you please elaborate the failure?  I can't see how the idr
> conversion would lead to spinlock bad magic error.  Does reverting
> this patch make the problem go away?

Yes, reverting the patch made the issue vanish.  I've no more
diagnostics I'm afraid, just a 10s timeout then bad magic - it looks
like memory corruption.  I'll try to find time to dig in more but not
sure when that'll happen.

--B5JjOzmn0Nsc+m1x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRE9jHAAoJELSic+t+oim9xVoP/0s+G7iNeKQHqJUuf4iIFECG
oxUSEGTNj0aYPCH5V4C2HMgHDCshevWAHvTEd6s3qTMfwHn5wU6FHMVzPuCg6thJ
+8DEw9TPPj4CwV8qk1QLGbKeIeKK43Ox70mqk70f8/UVZT27tJktW1Xe7DMO9Wrf
rhw0Ry0z+vcUpf1KSPkiv8Eotvnd6L0zqKh/+YW0gePvvM9dCWNGwG014fhPwSLu
7wMvilhSg1JhdBm9gQRT7nP65czBR/qEwKVe+A4DJupJ6ZpqBI7KKAGRpHTWP66+
3kP7iP+YIEmwvrg6dQ6HveBCUytFYfWMMIHhNIKBCdRRCmJ0C/DlhhBf1QRsEsdC
DN9N7ZvMtBFTK9t4MxjRv3id3K4AeOT04nGBE5DvJ6sDpqXJOwPV7wsjiLEdR4Yc
TFaQQGfTngMuLaPZ/p76+2juHAGAF79fml7GAyVPIkE5xYgyULgMkNrX83rkDKzI
IKXfJMTkQxmAaMCtD01FgCZmXGxoXif9wlC7XdqOeKHs4utgkL44ndhlhP/zJwvm
G1rLbXeg0ItsXtwxMjv/G0oSbuTG29Tm4diXDs1BcDvwXMlcNET0OOn24UEXIQdV
iewpju0mrItMrBcQ/Rslh2BKXanwz4t7uoblEyAsGBQdm9oillYXW3FEFZanPQSz
oKAzx+OCN3b0VCwiQRnp
=APFk
-----END PGP SIGNATURE-----

--B5JjOzmn0Nsc+m1x--
