Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaCLKrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:47:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51694 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbaCLKrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:47:39 -0400
Message-ID: <53203B2D.6080201@ti.com>
Date: Wed, 12 Mar 2014 12:47:09 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <20140226110114.CF2C7C40A89@trevor.secretlab.ca> <531D916C.2010903@ti.com> <5427810.BUKJ3iUXnO@avalon> <20140312102556.GC21483@n2100.arm.linux.org.uk>
In-Reply-To: <20140312102556.GC21483@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="Iv5LSov5aWnroVpD6igHprpuPVbMBmESP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Iv5LSov5aWnroVpD6igHprpuPVbMBmESP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/03/14 12:25, Russell King - ARM Linux wrote:
> On Mon, Mar 10, 2014 at 02:52:53PM +0100, Laurent Pinchart wrote:
>> In theory unidirectional links in DT are indeed enough. However, let's=
 not=20
>> forget the following.
>>
>> - There's no such thing as single start points for graphs. Sure, in so=
me=20
>> simple cases the graph will have a single start point, but that's not =
a=20
>> generic rule. For instance the camera graphs=20
>> http://ideasonboard.org/media/omap3isp.ps and=20
>> http://ideasonboard.org/media/eyecam.ps have two camera sensors, and t=
hus two=20
>> starting points from a data flow point of view.
>=20
> I think we need to stop thinking of a graph linked in terms of data
> flow - that's really not useful.
>=20
> Consider a display subsystem.  The CRTC is the primary interface for
> the CPU - this is the "most interesting" interface, it's the interface
> which provides access to the picture to be displayed for the CPU.  Othe=
r
> interfaces are secondary to that purpose - reading the I2C DDC bus for
> the display information is all secondary to the primary purpose of
> displaying a picture.
>=20
> For a capture subsystem, the primary interface for the CPU is the frame=

> grabber (whether it be an already encoded frame or not.)  The sensor
> devices are all secondary to that.
>=20
> So, the primary software interface in each case is where the data for
> the primary purpose is transferred.  This is the point at which these
> graphs should commence since this is where we would normally start
> enumeration of the secondary interfaces.
>=20
> V4L2 even provides interfaces for this: you open the capture device,
> which then allows you to enumerate the capture device's inputs, and
> this in turn allows you to enumerate their properties.  You don't open
> a particular sensor and work back up the tree.

We do it the other way around in OMAP DSS. It's the displays the user is
interested in, so we enumerate the displays, and if the user wants to
enable a display, we then follow the links from the display towards the
SoC, configuring and enabling the components on the way.

I don't have a strong opinion on the direction, I think both have their
pros. In any case, that's more of a driver model thing, and I'm fine
with linking in the DT outwards from the SoC (presuming the
double-linking is not ok, which I still like best).

> I believe trying to do this according to the flow of data is just wrong=
=2E
> You should always describe things from the primary device for the CPU
> towards the peripheral devices and never the opposite direction.

In that case there's possibly the issue I mentioned in other email in
this thread: an encoder can be used in both a display and a capture
pipeline. Describing the links outwards from CPU means that sometimes
the encoder's input port is pointed at, and sometimes the encoder's
output port is pointed at.

That's possibly ok, but I think Grant was of the opinion that things
should be explicitly described in the binding documentation: either a
device's port must contain a 'remote-endpoint' property, or it must not,
but no "sometimes". But maybe I took his words too literally.

Then there's also the audio example Philipp mentioned, where there is no
clear "outward from Soc" direction for the link, as the link was
bi-directional and between two non-SoC devices.

 Tomi



--Iv5LSov5aWnroVpD6igHprpuPVbMBmESP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTIDstAAoJEPo9qoy8lh71l0oP/R3nG2J/mPrV1Pp97Y1KQOwA
W0gugFqX6X8RYugVomKVoJf6GMT9wE/CiCF501GkkhZ1KNS5WHQnk1ep+hdmxH0Z
r8HHgQYE6MiW4mGl5x/FO80GzZCu7o3vx+sTdg6ZeiZ5OJ2XGkZMsYCS81i9/gbN
U2xbvr8W5/jl8rpdYmLC8mSpdLZ0gExokXxaDgDeLkncT318vtEjwEf1+ZbGpoei
17AZZRe88oaTff4j7VYnD0beK3wtmFZGJ5ULUuJeZjQi3KM5nyT05iIs4xucwv+J
A1SkzCDEP9k4OfxwoRzyrtAWKyDjPYYFbxlomNYV33j4ysatX2Hv1wFMLMfwX/de
QhbQZ3LyZYC+CkhEi/+j/p6Gs+iwyMKjgMSPlKTaZhAapVkGaO+Qmab1j5wbl27j
jM8+xZCnilpeFO39wFUUCgBhzCksD6SKXwzOd2+3WXNwTvWTUbqmJq+BJeUHl3cK
kqygpeBpoKV9pgDI+wHtdAIZiqy73JkDa48y+4FUGq7yJB9WfBQygqCTGcvul3hP
+9HbNdJHfXRS4s2+Gnb7beUYyVU/G5qIS0ebv9j3nIYOYwKrCsRxrRbWqygFJfTF
X2oESq+k+WZdmz6A3HprztyPi99AbalulVzTO01HiL8PUDbYfops4RLobZCJMPsA
h3R692R+rXyQEKUhXmjT
=q9ei
-----END PGP SIGNATURE-----

--Iv5LSov5aWnroVpD6igHprpuPVbMBmESP--
