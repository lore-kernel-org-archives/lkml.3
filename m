Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab3DOQHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:07:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50456 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754453Ab3DOQH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:07:28 -0400
Date: Mon, 15 Apr 2013 17:07:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Bengt =?iso-8859-1?Q?J=F6nsson?= <bengt.g.jonsson@stericsson.com>
Cc: Axel Lin <axel.lin@ingics.com>, Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: ab8500: Fix get_mode for shared mode
 regulators
Message-ID: <20130415160726.GF15837@opensource.wolfsonmicro.com>
References: <1365424274.21989.2.camel@phoenix>
 <516BB444.7010508@stericsson.com>
 <CAFRkauDHn88Y8cAemTNVCXW6WUVqvFfhw1iY174nepNymiU8Nw@mail.gmail.com>
 <CAFRkauDhqwcHtJU_uBf8wMmKr8DohHZnU6DNPBnzZhTp9-eBfg@mail.gmail.com>
 <516BE5AE.3020703@stericsson.com>
 <CAFRkauBzvdGrYizNZXivrzCdQ0btUamFL2hLjLX4rzS6fWhsWA@mail.gmail.com>
 <516BF56A.5010401@stericsson.com>
 <CAFRkauDp7P5t6BrZ5d=shOCqc71-zHRV1X_8aHRioGLV+oFFMg@mail.gmail.com>
 <516C1323.9060302@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/aVve/J9H4Wl5yVO"
Content-Disposition: inline
In-Reply-To: <516C1323.9060302@stericsson.com>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/aVve/J9H4Wl5yVO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2013 at 04:48:03PM +0200, Bengt J=F6nsson wrote:

> Reverting 500b4ac90d1103 makes sense, but first I want to mention
> two things:

> 1. In some cases it is not even possible to know the actual current
> state of a regulator because it is controlled by HW as well as SW.
> We have several examples of this.

If we're getting diverging statuses here then we need to introduce a
separate function to report the actual hardware state.  The get/set
should be the request.

> 2. regulator_enable/disable also checks the current status before
> setting the regulator. Should these checks be removed as well?

No, the enable state should reflect the state of the request from the
AP.  regulator_get_status() should return the actual physical state.

--/aVve/J9H4Wl5yVO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbCWvAAoJELSic+t+oim9MocP/23V36k5bz8HbqcvN12oLWLn
Wkp39saVYD+CVXE01+VmBrDjL1dcXV/9TXFydxdIWb93iRW08VzT6F1xxeGd3v+G
yBgT1zVM+0/GPbVDJpIzqkk9YTilf3vP0auljv2RckMWXWm1UeRMGLnFOmsidPze
DERYJBoyFPAHUrHr9wgZW6RT2uaAjnmqIWZZgwYCgLF8kB6zU7mf3opS7kh0Akry
d1HuRN3VEKhqxJYeZXqsvPI7bdf3Epjxmllr9UUWhAzjBFM/fbqep53Nimft3EBr
9WEZsLtcq1GopEPvepZavBorh5UFEhT6hG0q4SWwQ2EfkNULO7+D4GINqVAyN/p9
oKlI4meXpcRkEqouv8WBmAwIIILjz8fqdkLUue2q67iZmJ+ylHgiPaMLlhl7lHVS
TcPnFGT5/KdkojWgI7vn+88vcuQTRJl162FDIOBTHJNQjbOIVshVHLZNUvKQ8tOV
vkK5zc6FG9247OiQW9ZXNHgmSSo2PQKk64eACRk7AwQ8WEnr2GcS3t84LL2H30ml
bHgcgSMT4rvFMSC67Au+oVHFmeuaD+f9noWZW8Zzhi63HHPj7CS5faHue0HguVqd
DORcxKNwMB5aHhunaJoWrflhYMgS6G2phYblYVZdmV3N/2rhn83j2igIJNBWcvat
03AfBjGg6kYsb5W3I0lS
=2AYQ
-----END PGP SIGNATURE-----

--/aVve/J9H4Wl5yVO--
