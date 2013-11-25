Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3KYPxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:53:51 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60734 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab3KYPxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:53:45 -0500
Message-ID: <5293720D.5070605@ti.com>
Date: Mon, 25 Nov 2013 11:51:41 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <rui.zhang@intel.com>, <linux@roeck-us.net>, <mark.rutland@arm.com>,
        <khali@linux-fr.org>
CC: <wni@nvidia.com>, <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <eduardo.valentin@ti.com>
Subject: Re: [GIT PULL] Thermal and Device tree
References: <1385390669-7613-1-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1385390669-7613-1-git-send-email-eduardo.valentin@ti.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="mvwbXfjrFbP5pBBjSG5jtMbGHFlL58mj5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mvwbXfjrFbP5pBBjSG5jtMbGHFlL58mj5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Hello again Rui,

On 25-11-2013 10:44, Eduardo Valentin wrote:
> Hello Rui,
>=20
> Please consider the following changes for 3.14. It contains the work of=

> representing hardware thermal using device tree. It also contains
> three examples on how to use the new representation on sensor devices,
> using three different drivers to accomplish it. One driver is on therma=
l
> subsystem, the TI SoC thermal, and the other two drivers are in hwmon
> subsystem. I also included a change on cpu cooling device, which requir=
ed
> also a change on cpufreq-cpu0 driver. The change on this cooling device=

> still keeps in one piece its usage on different platforms.
>=20
> Because it is a controversial topic due to the lack of standards, and
> because it touches different subsystems, it took way longer than I expe=
cted.
> However, I've been discussing in different channels, and I believe I go=
t
> enough entropy now to go forward. We have acks from cpufreq folks (on A=
RM side)
> and from hwmon folks too. Raphael W., Jean D. and Mark R. have also
> reviewed this series. They agree with the core idea of the work.

FYI, Mark R. also acked the work on device tree binding behalf. And
after a couple of improvements on binding document suggested by Thomasz
F. and Mark. R, I uploaded in the same branch the resulting series.

Let me know if you have troubles pulling the series.

>=20
> It has been agreed that this is not the end of it. As I said I started
> with only three examples, but there are other potential drivers to use
> this API. So, I have agreed with Jean D., for instance, that this
> series would be first step of the complete work. Next would be to check=

> other potential drivers to be converted and then validate the proposed
> API. Currently the thermal framework would be polling for device
> temperature, but we could implement a couple of call backs to setup
> update rate, thresholds and hysteresis too, for instance.
>=20
> On the other hand, I don't think the principle and concept would break
> after converting the remaining drivers. That is why I am sending this p=
ull
> request.
>=20
> Another point is, as you can see, there are several points in this pull=

> request that do not belong to thermal subsystem. It has been suggested
> by Guenter R. that in such cases, it is recommended to send the complet=
e
> series via one single subsystem. Thus, I am sending via your queue.
>=20
> Lastly, I've also volunteered to maintain the upcoming thermal bindings=
=2E
> Then, you can see I am adding thermal bindings to our MAINTAINERS entry=
 too.
>=20
>=20
> All best,
>=20
> The following changes since commit 86e0a0bdf81c2dfa2a5a258dbb52f49c40eb=
c197:
>=20
>   Merge branches 'intel_powerclamp', 'tmon' and 'misc' of .git into nex=
t (2013-11-07 08:45:54 +0800)
>=20
> are available in the git repository at:
>=20
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-ther=
mal.git next
>=20
> for you to fetch changes up to 14d653c8ffc85c4aea7e50baa9a3c198b4fcf9c5=
:
>=20
>   MAINTAINERS: add thermal bindings entry in thermal domain (2013-11-25=
 10:19:12 -0400)
>=20
> ----------------------------------------------------------------
> Eduardo Valentin (20):
>       thermal: allow registering without .get_temp
>       thermal: introduce device tree parser
>       thermal: core: introduce thermal_of_cooling_device_register
>       thermal: cpu_cooling: introduce of_cpufreq_cooling_register
>       cpufreq: cpufreq-cpu0: add dt node parsing for cooling device pro=
perties
>       hwmon: lm75: expose to thermal fw via DT nodes
>       hwmon: tmp102: expose to thermal fw via DT nodes
>       thermal: ti-soc-thermal: use thermal DT infrastructure
>       arm: dts: add omap4 CPU thermal data
>       arm: dts: add omap4430 thermal data
>       arm: dts: add omap4460 thermal data
>       arm: dts: add cooling properties on omap4430 cpu node
>       arm: dts: add cooling properties on omap4460 cpu node
>       arm: dts: add omap5 GPU thermal data
>       arm: dts: add omap5 CORE thermal data
>       arm: dts: add omap5 thermal data
>       arm: dts: add cooling properties on omap5 cpu node
>       arm: dts: make OMAP443x bandgap node to belong to OCP
>       arm: dts: make OMAP4460 bandgap node to belong to OCP
>       MAINTAINERS: add thermal bindings entry in thermal domain
>=20
>  .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |   7 +
>  .../devicetree/bindings/thermal/thermal.txt        | 589 +++++++++++++=
+
>  MAINTAINERS                                        |   1 +
>  arch/arm/boot/dts/omap4-cpu-thermal.dtsi           |  41 +
>  arch/arm/boot/dts/omap443x.dtsi                    |  23 +-
>  arch/arm/boot/dts/omap4460.dtsi                    |  29 +-
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
>  drivers/thermal/of-thermal.c                       | 849 +++++++++++++=
++++++++
>  drivers/thermal/thermal_core.c                     |  77 +-
>  drivers/thermal/thermal_core.h                     |   9 +
>  drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  77 +-
>  include/dt-bindings/thermal/thermal.h              |  17 +
>  include/linux/cpu_cooling.h                        |  25 +
>  include/linux/thermal.h                            |  32 +-
>  23 files changed, 1939 insertions(+), 51 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/thermal/thermal.t=
xt
>  create mode 100644 arch/arm/boot/dts/omap4-cpu-thermal.dtsi
>  create mode 100644 arch/arm/boot/dts/omap5-core-thermal.dtsi
>  create mode 100644 arch/arm/boot/dts/omap5-gpu-thermal.dtsi
>  create mode 100644 drivers/thermal/of-thermal.c
>  create mode 100644 include/dt-bindings/thermal/thermal.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--mvwbXfjrFbP5pBBjSG5jtMbGHFlL58mj5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKTcg0ACgkQCXcVR3XQvP2ZUgEA2LhYLuEl+x4LOy1EeN2PgoTA
bSA9jEPwTV1GvGXTgdYBAN8/b5lR8R4l2QtUNkzHzzIRPFfK0WbfcFKPzCs7tl5r
=0vgz
-----END PGP SIGNATURE-----

--mvwbXfjrFbP5pBBjSG5jtMbGHFlL58mj5--
