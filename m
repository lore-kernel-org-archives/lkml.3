Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3IMKCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 06:02:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48591 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3IMKCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 06:02:04 -0400
Date: Fri, 13 Sep 2013 11:02:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20130913100202.GB29403@sirena.org.uk>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <52323AC8.30403@gmail.com>
 <523266EC.1060501@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OMnfC9oq5hdMsh0V"
Content-Disposition: inline
In-Reply-To: <523266EC.1060501@intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client
 devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OMnfC9oq5hdMsh0V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2013 at 09:14:20AM +0800, Aaron Lu wrote:
> On 09/13/2013 06:06 AM, Sylwester Nawrocki wrote:

> > So there is currently no way to avoid this behaviour, i.e. to have the=
=20
> > adapter
> > not activated before any of its client devices is probed, but only late=
r on,
> > after explicit call to pm_runtime_get*(&client->dev) in the client driv=
er ?

> The above pm_runtime_get_sync is used to make sure when the client I2C
> device is going to be probed, its host adapter device is turned on(or we
> will fail the probe). It doesn't affect the adapter's status before the
> probe of I2C client device.

The expecation is that if the adaptor needs to do anything to transfer
it'll do that when asked to transfer - that way it can sit in a low
power state when the bus is idle.

--OMnfC9oq5hdMsh0V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMuKWAAoJELSic+t+oim9pnEP/01pgNIbFRloFV0EFiAZ9e80
LBHLuQDPvL8wCsk+VcF5TnQ/AsaECoM3a2w4BGqRTAqiUQC/nQe9tEyc8VwAFy7k
e9DeroLlsVajQTGiFSZ0JlPYiFpNwWM2b7YMu9eDZHDKzHPe5KzZQtcECmNOXLLy
PIf6hamhX453X822h1JMPDLZ9diiaw5ujYha1a4MLQMcAQ0nUptUjEyoajvD29hV
jyTBzDS0q6DJK4f17D/ArEPsmuHoLrbN9q489WOfhoHydShwF2jRtme+m0b+hqcC
0yfa7dF36X+/ZEuggEpxNbRSPT8OJx79qELAMNzkktH9zw+18pkuefJcUEs0a+se
4wQVLnxWZv2UKReykscIN2WHwQ0umNVDQiu+4TtLJlmtDm9+amKJaNffXUj4l7t8
yNOOgoB/2vUGtfg3IHFS3GwJrw7F43bm/kzRsdj36diXescR9xLay7wVbzUIXOLR
TPV5uE4DvA7z5oul3in4R0Y1Htpj6PBvMcCC+maqUGP/oR6K/uS8afTQMulTe1sC
fU5cSBfP7xyMHfDwD0NHkyvtIWi5xdIhc9HM33D1yK/vWbPOHL6SUX0Vf5tf+Mtx
ZIrGGIZnEDxTDOXnxCS0A7fNeSGiyoRSYmUHJefqfCy+2cZESbVmnAgUV6P/T65F
mODwsA/83Yo1jFtaVqTD
=3xDW
-----END PGP SIGNATURE-----

--OMnfC9oq5hdMsh0V--
