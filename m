Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaGHO4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:56:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52957 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaGHO4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:56:03 -0400
Date: Tue, 8 Jul 2014 16:52:49 +0200
From: Mark Brown <broonie@kernel.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Fabio Estevam <festevam@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>
Message-ID: <20140708145249.GX30458@sirena.org.uk>
References: <20140706070800.GA2927@himangi-Dell>
 <20140707144832.GL30458@sirena.org.uk>
 <alpine.DEB.2.10.1407071655171.4757@hadrien>
 <CAOMZO5AiFCnfTzo4TyB5e5c+xiHQiHUbhRVY7z=AbjOWZDX3NA@mail.gmail.com>
 <alpine.DEB.2.10.1407071721270.4757@hadrien>
 <20140708080232.GQ30458@sirena.org.uk>
 <alpine.DEB.2.10.1407081012400.2347@hadrien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4HoONH8zr3Mj5MZN"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1407081012400.2347@hadrien>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: sgtl5000: Use devm_ functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4HoONH8zr3Mj5MZN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2014 at 10:15:20AM +0200, Julia Lawall wrote:
> On Tue, 8 Jul 2014, Mark Brown wrote:

> > It should be fairly clear given what they do I'd have thought - the
> > devm_ functions tie the deallocation of a resource to the unbinding of
> > a driver from a device so they can only be used to replace things that
> > get cleaned up in a device model unbind path.  There's not usually a
> > great deal of indirection going on in those.

> It is completely clear what they do.  What is not clear is what device
> libraries are set up to call the freeing functions at what point.  For
> example, I know that that platform drivers are set up for this, but once I
> tried to find the lines of code that would justify that, but I could not.
> Perhaps I was not patient enough or missed something.

All devices do this - it's done as part of the driver model core code so
there is no need for individual buses to do anything.

--4HoONH8zr3Mj5MZN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvAW+AAoJELSic+t+oim9l4kP+gMyAI7aRB54VgUJHgGmKoiW
LDPoVsZtHJwF/iMP8zI7ORoDOVu/wWazgVojBYqaRxbzTpL9sbUaA5ILFLuimBF4
xm3FOQMBLmeujw28naIUNubqQN69USZKyXxMPKxvX8+1Ki4+S8HjhVZ7rsmdzJiD
8YSuQoS20aq/9TOYFcTZncK5IbG3y2QgBYRx9Hwh1pFilrVIGWjejw/hBQgt2zb/
W28gSpEjNkgz8rsHQNJEU/p0wRVyBjI+sFPmmkobz136I+o9ULbUbwhb2IXc8NVX
RGpSeWYwPAtzWmhFh23uqr80MYK23UAYNiGmkh1npP0Hmaajaz0J2QCYXJtFp4tS
U/RiynIeiayz4FqDeiLL0lF+7usAqlNYTBV2XlI7npgbtHYrYfx9nsmC0Ej6seKm
HVn8Old8faRi7k/cVB7Rjx4q8t/oNalQgn19u1/6sPoM7qkBBpZWFJAjWigyXITU
4tdVX7A2v3Hp0UgHeqGy8zThWcsmVfUl1GyXTh2pVbe52QZG8Tu6b4jk1wHW+d4i
7aAfDUN1wjK+xgWVjlNrtlwXJiMHAGFsyIeOeOYD2uZ9x5UGPFak9+45SuUF3CGp
QyW2sW4hXxLJ4E76YHZL9kCA9zn20M7KiYO5BmxzXozWMTTL8Ig150bF1mRNPxj4
DgIHggUWlq9ZQo6ZrcQj
=CReu
-----END PGP SIGNATURE-----

--4HoONH8zr3Mj5MZN--
