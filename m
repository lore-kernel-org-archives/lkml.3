Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3GQLqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:46:54 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50016 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab3GQLqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:46:52 -0400
Date: Wed, 17 Jul 2013 13:46:50 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>, linux-sunxi@googlegroups.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, andy.shevchenko@gmail.com,
        linux@arm.linux.org.uk, linus.walleij@linaro.org,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [linux-sunxi] Re: [PATCH 1/2] Initial support for Allwinner's
 Security ID fuses
Message-ID: <20130717114650.GN3125@lukather>
References: <51C87DC7.50005@schinagl.nl>
 <20130624181509.GA8847@kroah.com>
 <51C8B84C.3020200@schinagl.nl>
 <20130624214615.GA17604@kroah.com>
 <51CAA709.4060801@schinagl.nl>
 <20130626175144.GC2222@kroah.com>
 <51D674BF.9030207@schinagl.nl>
 <20130706193646.GB9778@kroah.com>
 <51E466A3.4010503@schinagl.nl>
 <20130716064107.GA10868@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qYrsQHciA3Wqs7Iv"
Content-Disposition: inline
In-Reply-To: <20130716064107.GA10868@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qYrsQHciA3Wqs7Iv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2013 at 11:41:07PM -0700, Greg KH wrote:
> On Mon, Jul 15, 2013 at 11:16:19PM +0200, Oliver Schinagl wrote:
> > So using these new patches for binary attributes, how can I pass data=
=20
> > between my driver and the sysfs files using a platform_driver? Or are=
=20
> > other 'hacks' needed and using the .groups attribute from=20
> > platform_driver->device_driver->groups is really the wrong approach.
> >=20
> > I did ask around and still haven't figured it out so far, so I do=20
> > apologize if you feel I'm wasting your precious time.
>=20
> How is the platform device not the same thing that was passed to your
> probe function?

One thing I don't get here is why it should be set in the
platform_driver structure. From my understanding of the device model,
and since what Oliver is trying to do is exposing a few bytes of memory
to sysfs, shouldn't the sysfs file be attached to the device instead?

I mean, here, the sysfs file will be created under something like
=2E../drivers/sunxi-sid/eeprom. What happens when you have several
instances of that driver loaded? I'd expect it to have several sysfs
files created, one for each instance. So to me, it should be in the
device structure, not the driver one.

Couldn't that be also the reason of Oliver's NULL pointer? If the kobj
is attached to the platform_driver and not to the platform_device, it
should definitely get nasty when we try to cast it and retrieve data
=66rom it (and that would match the different pointers stuff as well.)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--qYrsQHciA3Wqs7Iv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR5oQqAAoJEBx+YmzsjxAgK0UP/0bgj+M8xwNNvjG1Xw0swJs1
y0dI/iGSDNc/KdNKNnYIsFercufhmqpfxLK7qd/xUWwoWsp9vf0gxlTsCXmhbNYf
u+UQcTF2/MVizQ41GUoCfq3sB2G7RSJmJYhxMvqng5Vlgmi/vQ5dkfhLMR3wc7jp
isIM4sJZBiKZsPc1pHUY0R4UYFanR6XMkUBasBZJ83iEWGzvTHKbj6jT78sikoBi
FwP/uBKAmrIHyFWx7fAmZeL++5LF5GWEBrRVmLWeJ8edbLaciIvqBhT3jwnC6+w0
82ywGp4tR98dMjB0F5KBfmj5+1KOROqY+6DOhot95QIDjCyGb17hE8B7O2fw07ge
TTSSIq7KjQ1TiDl4GxVi1TOcUJj6hm7+M476Fr3HvWAkG6V9hQGbsyTIgUx+16fY
2ez0RJrTt/T9dVG+qksTs9AZSb9JgQue9LVWu84sRsCS4cRZRTRWKyPBJfYUN/3O
qCa8yK4b8ycRJCAd15PqM5IV56dd60ALzUdaEDygRJ1iMuV1q+U2e1mn5amCJipf
rcZgB876LqXhixrNg8K6fiEl7cP3rW8q4PR7PQUxXmkpQCfRROtQ3efe9ctOIjsV
jzwm7NtJO1nGFGscV4KmJtir9XmR9JYVul6tQH/ShtMRtHLFB0BXLgb5DC/chRNn
2l09/D9WymE5RjCu+53K
=KT0E
-----END PGP SIGNATURE-----

--qYrsQHciA3Wqs7Iv--
