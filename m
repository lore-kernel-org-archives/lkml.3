Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaKXU0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:26:30 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:43803 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaKXU01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:26:27 -0500
Date: Mon, 24 Nov 2014 16:18:12 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, zyf@rock-chips.com,
        dianders@chromium.org, linux-rockchip@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, cf@rock-chips.com,
        dmitry.torokhov@gmail.com, huangtao@rock-chips.com, fzf@rock-chips.com
Subject: Re: [PATCH v19 0/5] Rockchip soc thermal driver
Message-ID: <20141124201807.GA20404@developer>
References: <1416805142-27304-1-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <1416805142-27304-1-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Caesar,

On Mon, Nov 24, 2014 at 12:58:57PM +0800, Caesar Wang wrote:
> This series patchs tested on rk3288 SDK board and pinky-v1,v2 board.
> I believe the driver can be used on the rk3288-evb board.
>=20
> Add this driver, The system will shutdown when
> the thermal temperture over 100C.If for some reason we are unable to
> shut it down in orderly fashion (kernel is stuck holding a lock or simila=
r)
> then hardware will reset it.
>=20
> The patchs 1/5,2/5 can applay Eduardo's Branch
> git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.=
git=09
> [branch "next-kernel"]
> 	remote =3D origin
> 	merge =3D refs/heads/next
>=20

I applied your patches 1 and 2 in my -linus branch, and luckily will be
accepted for 3.19.

Thanks.

>=20
> The patchs 3/5,4/5,5/5 can apply Heiko's Branch=20
> https://github.com/mmind/linux-rockchip.git


For 3 - 5 you can add my:
Acked-by: Eduardo Valentin <edubezval@gmail.com>

Cheers,

Eduardo Valentin

> [branch "3.19-armsoc/dts"]
> 	remote =3D origin
> 	merge =3D refs/heads/wip/v3.19-armsoc/dts
>=20
> Changes in v19:
> 	- update driver to fit Eduardo new API design.
> 	https://patchwork.kernel.org/patch/5329801/
>=20
> Changes in v18:
> 	* address comments from Eduardo Valentin and Dmitry Torokhov.
> 	- we need reset tsadc-controller before enable tsadc auto mode,
> 	  when we add the thermal function in coreboot,we always enable tsadc co=
ntroller.
> 	  So we need reset tsadc-controller to avoid the TSADC is abnormal.
> 	- put the document behind the driver.
> 	- Tested on pinky1,2,jeffy board,we will fix cooling-map temperature fro=
m 80C to 70C,
> 	  critical temperature from 100C to 90C.
>=20
> Changes in v17:
> 	* address comments from Heiko Stubner and .
> 	- rename the tshut property
> 	- the critiacal temperature only indeed 100C when add the cooling map,
> 	  it's for the more secure,fix the temperature from 120C to 100C.
>=20
> Changes in v16:
> 	* address comments from Dmitry Torokhov.
> 	- add thermal->chip->control(thermal->regs, false) in remove()
> 	- adjust TSHUT in resume().
>=20
> Changes in v15:
> 	* address comments from Dmitry Torokhov.
> 	- enable TSHUT move into rk_tsadcv2_tshut_temp().
> 	- drop the id argument in rk_tsadcv2_control().
>=20
> Changes in v14:
> 	* address comments from Dmitry Torokhov.
> 	- adjust-alarm-rate-depending-on-clock.
> 	- 0001-rockchip-thermal-do-not-register-cpufreq-cooling-dev.
>=20
> Changes in v13:
> 	- add cooling-maps for cpu-thermal.
> 	- put tshut polarity in device tree.
>=20
> Changes in v12:
> 	* address comments from Dmitry Torokhov and Vladimir Zapolskiy.
> 	- split-sensor-handling.
> 	- rename-rockchip_tsadc_platform_data.
>=20
> Changes in v11:
> 	* address comments from Vladimir Zapolskiy.
> 	- fix cpufreq_cooling_unregister() to put in correct position.
> 	- fix "data->chn",at least can get valid Tsensor temp.
>=20
> Changes in v10:
> 	* address comments from Doug Anderson.
> 	- fix TSHUT polarity,ensure support TSHUT.
> 	- add the decription for rk_tsadcv2_initialize().
>=20
> Changes in v9:
> 	* address comments from Dmitry Torokhov.
> 	- fix some style be defined
> 	- remove some unused code.
> 	- clk_disable_unprepare->clk_disable in suspend()
>=20
> Changes in v8:
> 	* address comments from Dmitry Torokhov and Doug Anderson.
> 	- add three Teperture Sensors.
> 	- support CRU and GPIO reset chip.
> 	- rename rk3xxx-cpu-thermal.dtsi as rk3288-thermal.dtsi
> 	- alarm-temp via set_trips() callback
> 	- remove "reset-gpios"
>=20
> Changes in v7:
> 	- fix get data->clk=3D0 when in probe() function.
> 	- fix some style code.
> 	- modify dts,main add rk3xxx-cpu-thermal.dtsi
>=20
> Changes in v6:
> 	* address comments from Tomeu Vizoso.
> 	- use thermal's generic framework.
>=20
> Changes in v5:
> 	* address comments from Eduardo Valentin,rui.zhang and Heiko Stubner:
> 	- with BIT() macro
> 	- manage clocks in suspend/resume.
> 	- license is fixed as GPLv2.
> 	- #include "thermal_core.h"->#include <linux/thermal.h>
> 	- use the generic trip-points.the hw-shut-temp isn't generic trip-points.
> 	- The method of binding and unbinding be fixed.
> 	- The pin-name tsadc->otp_out
>=20
> Changes in v4:
> 	* address comments from Jonathan Cameron,huangtao and zhaoyifeng:
> 	- this series thermal driver still be put in driver/thermal/
> 	- modify the thermal driver description.
>=20
> Changes in v3:(add dts configure)
> 	* address comments from Dmitry Torokhov and Arnd Bergmann:
> 	- fix clock-names in rockchip-thermal.txt
> 	- remove rockchip_thermal_control() in rockchip_set_mode()
> 	- fix some code style.
> 	- add dts configure.
>=20
> Changes in v2:
> 	* address comments from Heiko Stubner:
> 	- fix dt-bindings in rockchip-thermal.txt
> 	- remove Author mark
> 	- rename TSADC_XXX->TSADCV2_XXX,it eill ready to merge compatible other =
SoCs.
> 	- fix a identation
> 	- remove clk_set_rate(),it's no necessary.
> 	- fix the SIMPLE_DEV_PM_OPS() function  style.
>=20
> Caesar Wang (5):
>   thermal: rockchip: add driver for thermal
>   dt-bindings: document Rockchip thermal
>   ARM: dts: add RK3288 Thermal data
>   ARM: dts: add main Thermal info to rk3288
>   ARM: dts: enable Thermal on rk3288-evb board
>=20
>  .../bindings/thermal/rockchip-thermal.txt          |  45 ++
>  arch/arm/boot/dts/rk3288-evb.dtsi                  |   5 +
>  arch/arm/boot/dts/rk3288-thermal.dtsi              |  58 ++
>  arch/arm/boot/dts/rk3288.dtsi                      |  23 +
>  drivers/thermal/Kconfig                            |   9 +
>  drivers/thermal/Makefile                           |   1 +
>  drivers/thermal/rockchip_thermal.c                 | 628 +++++++++++++++=
++++++
>  7 files changed, 769 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-th=
ermal.txt
>  create mode 100644 arch/arm/boot/dts/rk3288-thermal.dtsi
>  create mode 100644 drivers/thermal/rockchip_thermal.c
>=20
> --=20
> 1.9.1
>=20
>=20

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUc5J1AAoJEMLUO4d9pOJWfJwH/Rvhdv/6aWK9Q6zlrt8+BnqS
SIBGqMmwjAC/AxlxPd5EYjH/VaP41hPMVcIJicG1UVj9iGfOh+rYME7osooWcUrg
CPqULtDnGrd2PEouz28wUFTEL+O7Mm0s2pnP4J7xRQTeoYPefdNv0h7+wFpIfEq7
zqRPCdvmgIsxR9zQj/83V/hZfWkewp9jjk81av7t7hWYI4Ocgz67aUtBDInfeCQT
Jpd7J+wH7fxTrFuNF49RbmqoJ6qScKNwdGp896rnOSN6uxzebz1xF+xviPQEBhsP
qxtcvWg1B8c8j0K6s5d8si5GnADXKEkwYg3YtM80m6X2Vk82ATLgvUnuzFvYKqE=
=k4ha
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
