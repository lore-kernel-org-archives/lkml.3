Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaIAKPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:15:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44369 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaIAKPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:15:33 -0400
Date: Mon, 1 Sep 2014 11:15:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Dirk Behme <dirk.behme@de.bosch.com>
Cc: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.com>
Message-ID: <20140901101512.GK29327@sirena.org.uk>
References: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com>
 <20140829190129.GZ29327@sirena.org.uk>
 <5404246E.4090908@de.bosch.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n95ggtiZmkwHBchJ"
Content-Disposition: inline
In-Reply-To: <5404246E.4090908@de.bosch.com>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: GPIO #0 is a valid GPIO
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n95ggtiZmkwHBchJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 01, 2014 at 09:46:54AM +0200, Dirk Behme wrote:
> On 29.08.2014 21:01, Mark Brown wrote:

> >No, read the archives

> Could you kindly give us a pointer to the relevant thread in the archive?

Not off the top of my head.

> >this will break boards using zero as default.
> >Any current boards should be using DT and so shouldn't be using fixed
> >GPIO numbers in the first place which will mean they'll not end up
> >getting zero as a valid GPIO.

> Hmm? What's wrong with a DT entry

> <&gpio1 0 0>;

> for ena_gpio resulting in zero as a valid GPIO?

If the platform has been converted to DT fully it's only going to happen
if there are exactly as many GPIOs in the system as there are slots in
the GPIO array which is unlikely to happen and trivial to deal with if
it does.  If the platform has been fully converted the GPIO numbers will
be dynamically allocated and the GPIO API starts from the top of the
GPIO range.

> >If you are using zero as a GPIO for some
> >reason provide a way to specify that the GPIO is a real GPIO and not
> >just the default value for the struct.

> Do you want to say that GPIO #0 (<&gpio1 0 0>;) isn't a valid GPIO for
> config->ena_gpio?

No, explicitly specifying GPIO 0 is a problem but that's really only
likely to happen if someone actually asks for it.

> I wonder how this fits to

> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/gpio/gpio-legacy.txt

> "GPIOs are identified by unsigned integers in the range 0..MAX_INT"

> "If you want to initialize a structure with an invalid GPIO number, use
> some negative number (perhaps "-EINVAL");"

> then?

There's no practical way to deploy that without breaking users - as soon
as you treat 0 as a valid GPIO you make all existing users relying on
the natural behaviour of treating 0 as default instantly buggy which is
not practical.  Really the GPIO API is badly specified here.

--n95ggtiZmkwHBchJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBEctAAoJELSic+t+oim9OekP/1v75v0R+07EsPxqK9oxzayM
FobQhqOe5+EwExuXUuCfJwFpT4lbvJJSdJbzb7lEqMIxI9YLLrThMQyAxND7M+2I
rGqy7ZOdDDUfNEYFpYaI/U/qa1c1Brtcko7TVk+9ku42RkJrEBLylOVhE+Kxae7e
gFx68UUVeBVnULaUZt5uwS/QiXC5TRI74juKN3qDiOs8bJeawcoYWSlM7druNml7
9oWXZDY3wzfwWckbGzCxYhtoHaNjh+cbzv1ECYmnhBz6e7MBndvvksIePO9tsw0U
b95CMD3ImY8ooQ/Xlzr24yqh8qP8w4niqTN1W/N2uMg4GYiNHkcMzqRGwpEhS2sQ
UnSxsKUC9o0Tv70xe7xVw3tTR9d9ElnXuwfjJk8RkuMlsKy32ysIFwNkbyWtCM9t
1ynYdZXFFElhV0V0JUZEu1V4va8eyjXdpytXNfA00tzzbxIdF0qz+JzQEhw4StqK
HjDRo+aL2MPUNMKIRmqV4HR20UOTDYdDijuBG5Y8D88q1pFRnorI0xieGyhzBjtl
7unmU5Cin2gyPq/0Ki3ePN9cCOVvvfAWTvBOdS5jQDc1kns9tnfRuIc9AD2qoL4E
xyaMX2h6y6fHOaHbTs8jZRr9wb7XtbUYRoafvtCrjaWK63SJpEqhRJtXnfEGb+0i
7OHZ5OMtvPpy+hcIBzvI
=brcy
-----END PGP SIGNATURE-----

--n95ggtiZmkwHBchJ--
