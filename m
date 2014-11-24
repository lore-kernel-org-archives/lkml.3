Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaKXR53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:57:29 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37003 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaKXR51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:57:27 -0500
Date: Mon, 24 Nov 2014 17:55:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Message-ID: <20141124175516.GM7712@sirena.org.uk>
References: <1416834123-23139-1-git-send-email-alban.bedel@avionic-design.de>
 <1416834123-23139-3-git-send-email-alban.bedel@avionic-design.de>
 <20141124152433.GD7712@sirena.org.uk>
 <20141124183204.79f3487e@avionic-0020>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SEFvVLxbW/dEDtN8"
Content-Disposition: inline
In-Reply-To: <20141124183204.79f3487e@avionic-0020>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] devicetree: add a binding for a group of regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SEFvVLxbW/dEDtN8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 06:32:04PM +0100, Alban Bedel wrote:

> Honestly my primary aim wasn't the sequencing, but rather to increase
> the usefulness of generic drivers. Generic driver generally only
> manipulate a single supply, however many hardware might have more,
> and won't need any specific power up ordering. Having to write a full
> new driver just because of an extra supply doesn't seems to make much
> sense to me.

I'm having a really hard time following the above - you say "generic
driver generally only manipulate a single supply" but that's absolutely
not the case.  A driver should control exactly as many supplies as the
device it is controlling does. =20

The nearest I can get to something that I think I can understand is a
device variant that has some changes in supplies but varaints aren't
something that we need to write entirely new drivers for, just new
device IDs and a few lines of conditional code.

It's possible that I'm missing something but I'm really struggling to
see the problem that you're trying to solve here or why this is an
abstraction that makes sense.

> As alternative solution to this problem I though about allowing a list
> of regulator for the supplies:

>  vin-supply =3D <&reg1>, <&reg2>;

> The API could still return a single consumer but it would operate on
> all the regulators in the list instead of just one. Would that be a
> better solution?

No, that's even worse - this is just hacking around whatever problem
you're facing.  The device tree should accurately describe the hardware
not some random thing that vaguely looks like the hardware because it
happens to let us shoehorn things onto it.

--SEFvVLxbW/dEDtN8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUc3EEAAoJECTWi3JdVIfQPEEH/RLOmYkaZrn1S5iAYK3KXtrx
tmfcUWVcfTsqjxGZD7uhFiz5eGm85mjWHoJkpQL6tD9q9pEJ9/hrydsoVGwVSu9T
oHXcBCZrc0ID/qjI0krbFdh5BGgq2icLKdkV8vrHkFr2FZ9F4WN9vWkXaMiLpdPO
84ES0JT0jmJ/2iU64AnuImgqHn2UOTt8TX8ZgZXk2XwDsMpjGO2OwFA+ZTUsQ0Io
iJff3QoTo33O8LcnOydynYdAWKAONBCIrMWPE0w79FwZpMrZzwnYWfUbvhW+PWHD
oArJSldXA6OksCl7AMct30z8aJ89Ygj8wHHE0kbFetBBC4foUk2aNxlLb+WB+sI=
=uMfH
-----END PGP SIGNATURE-----

--SEFvVLxbW/dEDtN8--
