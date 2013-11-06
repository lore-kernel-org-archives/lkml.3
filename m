Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab3KFLtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:49:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44438 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286Ab3KFLtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:49:14 -0500
Message-ID: <527A2C9C.4080409@ti.com>
Date: Wed, 6 Nov 2013 13:48:44 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH] clk: divider: fix rate calculation for fractional rates
References: <1383736008-22764-1-git-send-email-tomi.valkeinen@ti.com> <20131106111534.GW16735@n2100.arm.linux.org.uk>
In-Reply-To: <20131106111534.GW16735@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="WeSok8hTl6So1HH6OkqUqVKAPitKULhHs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WeSok8hTl6So1HH6OkqUqVKAPitKULhHs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-11-06 13:15, Russell King - ARM Linux wrote:
> On Wed, Nov 06, 2013 at 01:06:48PM +0200, Tomi Valkeinen wrote:
>> This means that the following code works a bit oddly:
>>
>> rate =3D clk_round_rate(clk, 123428572);
>> clk_set_rate(clk, rate);
>=20
> You're right, but the above sequence is quite a crass thing to do.  Why=
?

Do you mean that you think the fix is right, but the above example
sequence is silly, or that the fix is not needed either?

> clk_round_rate() returns the clock rate that clk_set_rate() would give
> you if you were to use this sequence:
>=20
> 	clk_rate_rate(clk, 123428572);
> 	rate =3D clk_get_rate(clk);
>=20
> The difference is that it doesn't change the actual clock rate itself;
> clk_round_rate() is meant to answer the question:
>=20
> 	"If I were to set _this_ rate, what clock rate would
> 	 the clock give me?"
>=20
> thereby providing a method for drivers to inquire what the effect would=

> be when changing such a clock without actually affecting it.
>=20
> So please, don't use clk_round_rate() followed by clk_set_rate().

Ok, if defined like that, then the current behavior is logical.

The comment in clk.h says "adjust a rate to the exact rate a clock can
provide", which does not contradict with what you said, but doesn't
really confirm it either. If I get "the exact rate a clock can provide"
I don't see why I can't use that exact clock rate for clk_set_rate.
Maybe the comment should be improved to state explicitly what it does.

However, how about the following sequence:

	clk_set_rate(clk, 123428572);
	rate =3D clk_get_rate(clk);
	clk_set_rate(clk, rate);

I didn't test that but it should result in the clock first set to
123428571, and then to 108000000. Obviously pointless if done exactly
like that, but I don't see why the above code sequence is wrong, yet it
gives a bit surprising result.

 Tomi



--WeSok8hTl6So1HH6OkqUqVKAPitKULhHs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSeiycAAoJEPo9qoy8lh71Ix4P/0T2N/a3T9ZmdQY6NhcffxL8
vKEUkm+MxvlGOg57bvT2NnwyUwuP3TD+PTTK4CxexWrJAgAexgKFJwH/n0nEAK/R
9YYZpzjW5qaBJwUqWx2ev21weDrRn6nB/oYcZfHe8NS5G9f/CFyG3we20DhyHW4V
4xXw3hYM1u8RPxtC7LIa/TB/W4thf+a41v6Bwn0Lz+UjSqHGSTw48cVJbIWdVFYD
VaZnCRN4a4zesIQ1/hCrbij0ZtlpXN0ANKF8mbpUqGZC9mdVsDyN55t3xJLjvKiO
IKuJ/6DVqPluxM/jY0zSSjJ9UygSH43BAd4meO07t8gBNNt4x/8TRgnaBy3CCHsT
TkE0Jp+ZU+AyZU8DwFSZXE2cqVQeGUfA5YnTmLfqCpr3C0VFyEdJpMWIDOsH3B72
j6nFv6k5Qvbl/XAczGDvVNjJ5I5RvL7vRagANZSQ4Q6u8CWc6tnSWGi/c2Vn2rEL
tGpZz9rdUkXKym55dINKojJ1dVb47PO++tLJI4MNIL30k6drYYf3pNNLDa07gY20
ChMzJeiC76/iBhJnoE0H5QXzzxkkXGVP655E04/RdAPe36/5+nR6aNqp+rrPzylN
l/B7eSyq4PUl3/FCfzMzfJMKZe7HClF1uvK+kMP1J9JQ8QKNqrDZJGuWFlylZtK5
AH65+A0F4Wy33rjSQP0E
=4+9g
-----END PGP SIGNATURE-----

--WeSok8hTl6So1HH6OkqUqVKAPitKULhHs--
