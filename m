Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3GQPML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:12:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39725 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab3GQPMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:12:08 -0400
Message-ID: <51E6B3FE.2010000@ti.com>
Date: Wed, 17 Jul 2013 11:10:54 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <wni@nvidia.com>,
        <l.stach@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 0/9] thermal: introduce DT thermal zone build
References: <1374073374-30946-1-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1374073374-30946-1-git-send-email-eduardo.valentin@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2TXBWLCJPUHKTMKLIHDHX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2TXBWLCJPUHKTMKLIHDHX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 17-07-2013 11:02, Eduardo Valentin wrote:
> Hello all,
>=20


Looks like I sent duplicated series. Please consider the series
containing 9 patches. I will resend with proper set.


> As you noticed, I am working in a way to represent thermal data
> using device tree [1]. Essentially, this should be a way to say
> what to do with a sensor and how to associate (cooling) actions
> with it.
>=20
> The motivation to create such infrastructure is:
> (i) - to reuse the existing temperature sensor code base;
> (ii) - have a way to easily describe thermal data across different
> boards for the same sensor. Say you have an i2c temp sensor,
> which is placed close to your battery on board A but on
> board B, another instance of this same senor is placed
> close to your display, for instance.
>=20
> This series introduces then a DT parser. The data expected in
> DT must contain the needed properties to build a thermal zone
> out of the desired sensor. All properties are documented and
> they are derived from the existing requirements of current
> thermal API.
>=20
> In order to perform a binding with cooling devices,
> the new thermal zone built using DT nodes will use
> the existing thermal API that uses binding parameters. This is
> the current proposed way to register thermal zones with platform
> information, written by Durga.
>=20
> There are some virtual concepts that are pushed to device tree,
> I know. But I believe using device tree to do this makes sense
> because we are still describing the HW and how they are related
> to each other. Things like cooling devices are not represented
> in device tree though, as I believe that will cause a lot of
> confusion with real devices (as already does).
>=20
> So the series is short but I think it makes sense to describe
> how it is organized, as it touches several places. First four
> patches are a preparation for this parser. There is a change
> on cpufreq-cpu0, so that it knows now how to load its
> corresponding cooling device. There is a change on thermal_core
> to split its hwmon code, because I think we may need to improve
> this code base when we start to integrate better with hwmon
> temperature sensors. Then, another needed preparation is to
> improve the bind_params, so that we are able to bind with
> upper and lower limits. The remaining patches are the changes
> with the proposed DT parser. A part from the DT thermal zone
> builder itself (patch 05), I also changed the ti-soc-thermal
> driver to use this new API and the omap4430 bandgap DT node,
> as an example (this has been tested on panda omap4430); and also change=
d
> the hwmon drivers lm75 and tmp102 to have the option to build
> a thermal zone using DT. I haven't touched any dts file using
> lm75 or tmp102 because this should come on a need basis.
>=20
> I believe this code is pretty usable the way it is, but might
> need to be revisited, in case the enhancement proposed by Durga
> get in. This is because representing virtual thermal zones
> built out of several sensors may need a different representation
> in DT.
>=20
> [1] - RFC of this work:
> http://comments.gmane.org/gmane.linux.power-management.general/35874
>=20
> Changes from RFC:
> - Added a way to load cpufreq cooling device out of DT
> - Added a way to bind with upper and lower limits using bind_params
> - Added a way to specify upper and lower binding limits on DT
> - Added DT thermal builder support to lm75 and tmp102 hwmon drivers
> - Changed ERANGE to EDOM
> - Added thermal constants for zone type and bind limit, so that
>   dts file could be more readable
>=20
> Tested on panda omap4430 (3.11-rc1 with minor changes for getting cpufr=
eq working)
>=20
> BR,
>=20
> Eduardo Valentin (9):
>   cpufreq: cpufreq-cpu0: add dt node parsing for 'needs-cooling'
>   thermal: hwmon: move hwmon support to single file
>   thermal: thermal_core: allow binding with limits on bind_params
>   arm: dts: flag omap4430 with needs-cooling for cpu node
>   thermal: introduce device tree parser
>   thermal: ti-soc-thermal: use thermal DT infrastructure
>   arm: dts: add omap4430 thermal data
>   hwmon: lm75: expose to thermal fw via DT nodes
>   hwmon: tmp102: expose to thermal fw via DT nodes
>=20
>  .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |   3 +
>  .../devicetree/bindings/thermal/thermal.txt        | 133 ++++++
>  Documentation/thermal/sysfs-api.txt                |   7 +
>  arch/arm/boot/dts/omap443x.dtsi                    |  32 +-
>  drivers/cpufreq/cpufreq-cpu0.c                     |   8 +
>  drivers/hwmon/lm75.c                               |  29 ++
>  drivers/hwmon/tmp102.c                             |  25 ++
>  drivers/thermal/Kconfig                            |  22 +
>  drivers/thermal/Makefile                           |   4 +
>  drivers/thermal/thermal_core.c                     | 274 +-----------
>  drivers/thermal/thermal_dt.c                       | 458 +++++++++++++=
++++++++
>  drivers/thermal/thermal_hwmon.c                    | 269 ++++++++++++
>  drivers/thermal/thermal_hwmon.h                    |  49 +++
>  drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  46 ++-
>  include/dt-bindings/thermal/thermal.h              |  27 ++
>  include/linux/thermal.h                            |  13 +
>  16 files changed, 1129 insertions(+), 270 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/thermal/thermal.t=
xt
>  create mode 100644 drivers/thermal/thermal_dt.c
>  create mode 100644 drivers/thermal/thermal_hwmon.c
>  create mode 100644 drivers/thermal/thermal_hwmon.h
>  create mode 100644 include/dt-bindings/thermal/thermal.h
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2TXBWLCJPUHKTMKLIHDHX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHms/4ACgkQCXcVR3XQvP2NPgEAjlxYm3M25SYAUisafjXTvnyi
OZiWDjph1p2AhufqesoBAMMoOW8oTHWPvr4tWbMHkC5Hp1tzEn2yVA0a+vR1cGnS
=7JzG
-----END PGP SIGNATURE-----

------enig2TXBWLCJPUHKTMKLIHDHX--
