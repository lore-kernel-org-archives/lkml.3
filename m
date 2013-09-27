Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab3I0DQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:16:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58532 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab3I0DQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:16:12 -0400
Message-ID: <5244F836.3070102@ti.com>
Date: Thu, 26 Sep 2013 23:15:02 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 00/18] device thermal limits represented in device tree
 nodes (v4)
References: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="SsWncKjtLd7kNI9MEQsiOB2CHuaOOeP8a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SsWncKjtLd7kNI9MEQsiOB2CHuaOOeP8a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 26-09-2013 23:13, Eduardo Valentin wrote:
> Hello all,
>=20
> Here is the continuation of work of representing hardware thermal prope=
rties
> in device tree infrastructure. The present patch series is the fourth v=
ersion
> of this work. Previous versions were sent as RFCs and can be found here=
:
> V3:=20

Too fast, hit send too early. For those interested, here is the link to V=
3:
https://lkml.org/lkml/2013/9/15/122

> RFCv2: http://lkml.org/lkml/2013/8/23/594
> RFCv1: http://lkml.org/lkml/2013/7/22/319
>=20
> Major difference from V3 is on the parser itself. I have updated the bi=
nding
> documentation and improved the code accordingly to previous comments ma=
inly
> from Mark R. and Joe P.
>=20
> The changes on hwmon drivers have been accepted by Guenter, and in this=

> series I am including his Acked-by, as I didn't change anything on that=
 side.
>=20
> I also found a bug while using all involved code built as modules, thus=

> I have reworked a bit the cooling device registration part. This is why=

> there are two new patches in this series (patches 02 and 04).
>=20
> Tests were done, just like in V3, on TI OMAP4430, OMAP4460, OMAP5430 an=
d DRA7,
> although this series is not including the DRA7 part (I will be sending =
separately).
>=20
> Thanks all who have been contributing reviewing this code.
>=20
> All best,
>=20
> Eduardo Valentin (18):
>   thermal: allow registering without .get_temp
>   thermal: core: allow binding via .bind when tzp is present
>   thermal: introduce device tree parser
>   thermal: core: introduce thermal_of_cooling_device_register
>   thermal: cpu_cooling: introduce of_cpufreq_cooling_register
>   cpufreq: cpufreq-cpu0: add dt node parsing for cooling device
>     properties
>   hwmon: lm75: expose to thermal fw via DT nodes
>   hwmon: tmp102: expose to thermal fw via DT nodes
>   thermal: ti-soc-thermal: use thermal DT infrastructure
>   arm: dts: add omap4 CPU thermal data
>   arm: dts: add omap4430 thermal data
>   arm: dts: add omap4460 thermal data
>   arm: dts: add cooling properties on omap4430 cpu node
>   arm: dts: add cooling properties on omap4460 cpu node
>   arm: dts: add omap5 GPU thermal data
>   arm: dts: add omap5 CORE thermal data
>   arm: dts: add omap5 thermal data
>   arm: dts: add cooling properties on omap5 cpu node
>=20
>  .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |   7 +
>  .../devicetree/bindings/thermal/thermal.txt        | 537 +++++++++++++=

>  arch/arm/boot/dts/omap4-cpu-thermal.dtsi           |  41 +
>  arch/arm/boot/dts/omap443x.dtsi                    |  15 +-
>  arch/arm/boot/dts/omap4460.dtsi                    |  15 +-
>  arch/arm/boot/dts/omap5-core-thermal.dtsi          |  28 +
>  arch/arm/boot/dts/omap5-gpu-thermal.dtsi           |  28 +
>  arch/arm/boot/dts/omap5.dtsi                       |  15 +-
>  drivers/cpufreq/Kconfig                            |   2 +-
>  drivers/cpufreq/cpufreq-cpu0.c                     |  16 +
>  drivers/hwmon/lm75.c                               |  35 +-
>  drivers/hwmon/tmp102.c                             |  19 +
>  drivers/thermal/Kconfig                            |  14 +
>  drivers/thermal/Makefile                           |   1 +
>  drivers/thermal/cpu_cooling.c                      |  56 +-
>  drivers/thermal/of-thermal.c                       | 845 +++++++++++++=
++++++++
>  drivers/thermal/thermal_core.c                     |  79 +-
>  drivers/thermal/thermal_core.h                     |   9 +
>  drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  77 +-
>  include/dt-bindings/thermal/thermal.h              |  27 +
>  include/linux/cpu_cooling.h                        |  25 +
>  include/linux/thermal.h                            |  32 +-
>  22 files changed, 1880 insertions(+), 43 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/thermal/thermal.t=
xt
>  create mode 100644 arch/arm/boot/dts/omap4-cpu-thermal.dtsi
>  create mode 100644 arch/arm/boot/dts/omap5-core-thermal.dtsi
>  create mode 100644 arch/arm/boot/dts/omap5-gpu-thermal.dtsi
>  create mode 100644 drivers/thermal/of-thermal.c
>  create mode 100644 include/dt-bindings/thermal/thermal.h
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--SsWncKjtLd7kNI9MEQsiOB2CHuaOOeP8a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJE+DkACgkQCXcVR3XQvP0YugEAndpUoFu9iRor2W5i3z46e8rz
jsB7+ioqEgdpK+q3mIYBAILdLpqvErZt2fh9WKrWWNS1K8PB/NOs4oaVseP+yl7a
=+Qmq
-----END PGP SIGNATURE-----

--SsWncKjtLd7kNI9MEQsiOB2CHuaOOeP8a--
