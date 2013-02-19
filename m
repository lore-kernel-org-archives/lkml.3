Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab3BSQHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:07:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33249 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab3BSQHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:07:46 -0500
Message-ID: <5123A32D.4030005@pengutronix.de>
Date: Tue, 19 Feb 2013 17:07:09 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: balbi@ti.com
CC: Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        linux@arm.linux.org.uk, mchehab@redhat.com, davem@davemloft.net,
        tony@atomide.com, gregkh@linuxfoundation.org,
        broonie@opensource.wolfsonmicro.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon <kishon@ti.com>,
        eballetbo@gmail.com, santosh.shilimkar@ti.com,
        linux-arm-kernel@lists.infradead.org, rob@landley.net,
        netdev@vger.kernel.org, swarren@nvidia.com, javier@dowhile0.org,
        linux-omap@vger.kernel.org, akpm@linux-foundation.org,
        cesarb@cesarb.net
Subject: Re: [PATCH v2 0/5] Generic PHY Framework
References: <1361253198-7401-1-git-send-email-kishon@ti.com> <201302191233.54677.arnd@arndb.de> <20130219131258.GV23197@arwen.pp.htv.fi> <201302191434.40495.arnd@arndb.de> <20130219150500.GG4390@arwen.pp.htv.fi>
In-Reply-To: <20130219150500.GG4390@arwen.pp.htv.fi>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2SBDGRJPVQCFTOJOJDENK"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2SBDGRJPVQCFTOJOJDENK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/19/2013 04:05 PM, Felipe Balbi wrote:
> Hi,
>=20
> On Tue, Feb 19, 2013 at 02:34:40PM +0000, Arnd Bergmann wrote:
>> On Tuesday 19 February 2013, Felipe Balbi wrote:
>>> On Tue, Feb 19, 2013 at 12:33:54PM +0000, Arnd Bergmann wrote:
>>>>> Currently drivers/phy and drivers/net/phy are independent and are n=
ot=20
>>>>> related to each other. There are some fundamental differences on ho=
w=20
>>>>> these frameworks work. IIUC, the *net* uses bus layer (MDIO bus) to=
=20
>>>>> match a PHY device with a PHY driver and the Ethernet device uses t=
he=20
>>>>> bus layer to get the PHY.
>>>>> The Generic PHY Framework however doesn't have any bus layer. The P=
HY=20
>>>>> should be like any other Platform Devices and Drivers and the frame=
work=20
>>>>> will provide some APIs to register with the framework. And there ar=
e=20
>>>>> other APIs which any controller can use to get the PHY (for e.g., i=
n the=20
>>>>> case of dt boot, it can use phandle to get a reference to the PHY).=

>>>>
>>>> Hmm, I think the use of a bus_type for a PHY actually sounds quite
>>>> appropriate. The actual PHY device would then be a child of the
>>>
>>> really ? I'm not so sure, the *bus* used by the PHY is ULPI, UTMI,
>>> UTMI+, PIP3, I2C, etc... adding another 'fake' bus representation is =
a
>>> bit overkill IMO.
>>>
>>> Imagine an I2C-controlled PHY driver like isp1301, that driver will h=
ave
>>> to register i2c_driver and phy_driver, which looks weird to me. If th=
e
>>> only substitute for class is a bus, we can't drop classes just yet, I=
'm
>>> afraid.
>>>
>>> Imagine a regulator bus, a pwm bus, an LED bus etc. They don't make
>>> sense IMHO.
>>
>> It's a fine line, but I think a phy is something that resembles a devi=
ce
>> more than an LED does. When I read patch 1, I also noticed and comment=
ed
>> on the fact that it does use a 'class'. Now, according to Greg, we sho=
uld
>> use 'bus_type' instead of 'class' in new code. I originally disagreed =
with
>> that concept, but he's the boss here and it's good if he has a vision
>> how things should be lined out.
>>
>> In practice, there is little difference between a 'bus_type' and a 'cl=
ass',
>> so just replace any instance of the former with the latter in your hea=
d
>> when reading the code ;-)
>=20
> it's not so simple :-) if we must use bus_type we need to introduce all=

> the device/driver matching mechanism which isn't necessary with a class=
=2E

You have the code for phy <-> device matching in your framework anyway.
Using the bus infrastructure brings changes the open coded matching into
bus callbacks.

regards,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2SBDGRJPVQCFTOJOJDENK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlEjozAACgkQjTAFq1RaXHP6mQCfQGmyi8YvXxLTOUA7hgRMJgDU
KNMAoJm7X9hyPcfnCsdwPwAhuTppFTmV
=csaX
-----END PGP SIGNATURE-----

------enig2SBDGRJPVQCFTOJOJDENK--
