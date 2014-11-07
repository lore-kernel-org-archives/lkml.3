Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaKGBak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 20:30:40 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:60521 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKGBah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 20:30:37 -0500
Date: Thu, 6 Nov 2014 21:30:20 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, zyf@rock-chips.com,
        dianders@chromium.org, linux-rockchip@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, cf@rock-chips.com,
        dmitry.torokhov@gmail.com, dbasehore@chromium.org,
        huangtao@rock-chips.com, cjf@rock-chips.com, zhengsq@rock-chips.com,
        fzf@rock-chips.com
Subject: Re: [PATCH v17 1/5] thermal: rockchip: add driver for thermal
Message-ID: <20141107013017.GA10180@developer>
References: <1414809873-32227-1-git-send-email-caesar.wang@rock-chips.com>
 <1414809873-32227-2-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <1414809873-32227-2-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Caesar,

On Sat, Nov 01, 2014 at 10:44:29AM +0800, Caesar Wang wrote:
> Thermal is TS-ADC Controller module supports
> user-defined mode and automatic mode.
>=20
> User-defined mode refers,TSADC all the control signals entirely by
> software writing to register for direct control.
>=20
> Automaic mode refers to the module automatically poll TSADC output,
> and the results were checked.If you find that the temperature High
> in a period of time,an interrupt is generated to the processor
> down-measures taken;If the temperature over a period of time High,
> the resulting TSHUT gave CRU module,let it reset the entire chip,
> or via GPIO give PMIC.
>=20

First thing, very good progress in this driver!=20

> Signed-off-by: zhaoyifeng <zyf@rock-chips.com>
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Just for the sake of code / documentation history, this patch, which
adds the driver, should come after patch 2, which adds dt documentation.

> ---
>  drivers/thermal/Kconfig            |   9 +
>  drivers/thermal/Makefile           |   1 +
>  drivers/thermal/rockchip_thermal.c | 711 +++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 721 insertions(+)
>  create mode 100644 drivers/thermal/rockchip_thermal.c

<big cut>

> +static int
> +rockchip_thermal_register_sensor(struct platform_device *pdev,
> +				 struct rockchip_thermal_data *thermal,
> +				 struct rockchip_thermal_sensor *sensor,
> +				 enum sensor_id id)
> +{
> +	const struct rockchip_tsadc_chip *tsadc =3D thermal->chip;
> +	int error;
> +
> +	tsadc->set_tshut_mode(id, thermal->regs, thermal->tshut_mode);
> +	tsadc->set_tshut_temp(id, thermal->regs, thermal->tshut_temp);
> +
> +	sensor->thermal =3D thermal;
> +	sensor->id =3D id;
> +	sensor->tzd =3D thermal_zone_of_sensor_register(&pdev->dev, id, sensor,
> +						rockchip_thermal_get_temp,
> +						NULL,
> +						rockchip_thermal_set_trips);

So, did I miss something here? Looks like you have extended the of
thermal, and I haven't seen the patch.
  CC [M]  drivers/thermal/rockchip_thermal.o
  drivers/thermal/rockchip_thermal.c: In function
  `rockchip_thermal_register_sensor':
  drivers/thermal/rockchip_thermal.c:482:7: error: too many arguments to
  function `thermal_zone_of_sensor_register'
         rockchip_thermal_set_trips);



--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXCCHAAoJEMLUO4d9pOJWleQIAJ6EwZupFBB6tPWGOH22wHu9
sbk39SNWEjaX1AejKiRrbOvFp9FMugIKfDX1VQVKpT8glFLsvhQo1YH7JCgRG9rh
PJKEWmOEvnNZOtjURbS+eRxwnuL1ocVZQFBSoiXPgASjj7xT8L+1bd23OwM18T38
7ix7IO0r6EcbTVmDntg+4wa8hsP7Yg78/h3XzljB6qdWHhjfKrBWGaPvHG06v2Lm
XnTklL30SDS5SXY04i7r3PTTbK8r6fnfNk+luAxo04EhwB4xygZdwUAFK8chP7j2
JW6S2a9GFi5GUlZPvRCFrh1kt6VPcVM9O4LXIief6TsXYs1cNed8uWpSWt23iw0=
=tbh4
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
