Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaJTIRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:17:42 -0400
Received: from sauhun.de ([89.238.76.85]:53283 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbaJTIRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:17:40 -0400
Date: Mon, 20 Oct 2014 10:18:22 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Andreas Werner <andreas.werner@men.de>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, johannes.thumshirn@men.de
Subject: Re: [PATCH 1/2] drivers/misc/eeprom/men_eeprod: Introduce MEN Board
 Information EEPROM driver
Message-ID: <20141020081822.GA1413@katana>
References: <cover.1413416105.git.andreas.werner@men.de>
 <d169930cfe45d4c05c79f7dd00471d732441529d.1413416105.git.andreas.werner@men.de>
 <20141016085835.GA1273@katana>
 <20141016102126.GB23256@awelinux>
 <20141016095910.GC1273@katana>
 <20141016114401.GA22506@awelinux>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20141016114401.GA22506@awelinux>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Most customers wants just to have a running system without installing any=
thing.
> And for me an EEPROM is so simple and should not need a complicated way
> to access it.

As I pointed out, there are ways to do it other than a seperate driver.

> Yes of course there are a lot of possibilities. This was just an example
> what we currently use and what was developed years ago.

And please notice that this solution you chose is not acceptible for
upstream. We can't have n copies of the at24 driver with just some minor
differences. This is a maintenance nightmare.

Yes, I know it was easiest to start with and it works, but that does not
help here.

> With a driver like this you can also define read only attributes to preve=
nt customer
> to write or modify the data in the production section. With i2ctools you =
can just
> write any data to it you want.

i2cget won't modify any data. i2cset does, if anyone wants to do that.
BTW it does that also after you removed your driver, so basically no big
difference here.

> > I am not talking about runtime here, I don't care about that. I am
> > talking about the ABI we create and we have to maintain basically
> > forever. And with vendor specific configuartion data I have doubts with
> > that being stable.
> >=20
>=20
> Ok, but i do not think that we can make a "general" ABI definition for th=
ose kind
> of devices because every vendor will have its own data in the EEPROM whic=
h he want
> to have.

Exactly, that was what I was saying.

What we probably should have in at24 is regions which should not be
exposed to userspace, because they contain config data. That would be
nice.

I'm not sure if we can add table based decoding to at24, that needs some
experiments. But it will really need such experiments and some more
effort.

> > These is a HUGE difference. If I read tempX_input, I don't need to care
> > if the sensor is I2C or SPI or whatever. The kernel abstracts that away.
> > The files you create are for your I2C EEPROM only. Data gets
> > "reformatted" and access gets hidden, but nothing is abstracted away.
> > It would be different if we had a generic convention for "serial_id" or
> > stuff like that. But as configuration data is highly specific I don't
> > see this coming.
> >=20
>=20
> For a standard sysfs interface it is a huge difference yes. At the point
> of few from the EEPROM device it is a device like a temp sensor which
> could be different from vendor to vendor.

Here it gets frustrating. It seems you have no idea what an OS is for,
not even after I tried to describe it :(


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJURMVOAAoJEBQN5MwUoCm2phEP/A4cn8ZB/jF5322DNIUUCyUv
LB8DVwjgua6ce0JHZPFsqPI792lSXOk7sWYlORw3bvgARs2zg5bkdkb925vpUc5g
1uCtWOFGjRmOEFWWzJjJe6Ky7OXO8IMImN/GJQNYYYjDh+ciMWgMQUWeImbk7gL/
imMeSHJVtrQ34snA/Rglqksa6cOWv48fm06nqoMH+GaIZ8b9AXs3BtSeQePq9uN2
8ok8/vcy42q2AxVBHWadfCjbFvamF8cvhky6Abjg73OqHoiN3t3u6fWT5e/ww/FR
Yx2TknuIAttdhk51VgqZVv+hkeuhubB3ncP8OLOePgb3ODSjuAwwCdEhWowTRXqM
wNbAiWku0bxA72d56gEV3CPFLD3lUaJxs5OKyiFluwo5g/myYIRxVi/qcwSF9wuZ
K4jAaO+jQs3um8mPEk5CTXt33XaRRc+/AaGNSPkqmNBZGbZl9QwUdzLdAjUjrTr9
1Xtxbe1Topysib1p3lSg3Lky/MESBbB5+PKvHjgRM0i3c3jp1FZPtfanj8P8Vmnd
+F+sD4PE3tLNQCefvPcUCTq3hRz3WTmFVwYD2McLoQAKeWSA5Qnci1exiqgj9Xyo
dml1rXp+lqEsU3b8AO6WPac2ehd+3Fa81WfAY47MB3y5qE2F7AsVIEUsyPgiUzar
eoIFP1Je25mJfZVNrq+G
=nbb5
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
