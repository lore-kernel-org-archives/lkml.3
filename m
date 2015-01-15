Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbbAOJpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:45:53 -0500
Received: from mout.gmx.net ([212.227.15.18]:61106 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbbAOJpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:45:51 -0500
Message-ID: <54B78C3C.1080109@rempel-privat.de>
Date: Thu, 15 Jan 2015 10:45:32 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: clk: add clk-asm9260 driver
References: <1417187120-23659-1-git-send-email-linux@rempel-privat.de> <1420707567-22760-1-git-send-email-linux@rempel-privat.de> <1420707567-22760-2-git-send-email-linux@rempel-privat.de> <20150114230217.22722.88458@quantum>
In-Reply-To: <20150114230217.22722.88458@quantum>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jLNBg8SoxtMTJCXhtk22ueR5qjI7rTK5f"
X-Provags-ID: V03:K0:1uUsjRyqh6CiHOZWaUTG5/f7xYZ4SCDrzOTy/g9fJUY6XfWeJ1t
 xU+4TuCNyy20C/9b646WqWM/28ho/TT98BFo7u7A7EUMt7dcPEpt0m4zs3rplS37iYRtP6g
 be7zGnWrF0nKZdMAzQcbOu2kwAZpB6uLtoHQ9bTHpIb2nIu0jzOGTGPjJKZFn2zyyY1MDNg
 GeS4eIUhDrtmbErMsMZ4A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jLNBg8SoxtMTJCXhtk22ueR5qjI7rTK5f
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 15.01.2015 um 00:02 schrieb Mike Turquette:
> Quoting Oleksij Rempel (2015-01-08 00:59:27)
>> diff --git a/drivers/clk/clk-asm9260.c b/drivers/clk/clk-asm9260.c
>> new file mode 100644
>> index 0000000..6b1c220
>> --- /dev/null
>> +++ b/drivers/clk/clk-asm9260.c
>=20
> <snip>
>=20
>> +static const char *clk_names[] =3D {
>> +       [REFCLK]        =3D "oscillator",
>> +       [SYSPLL]        =3D "pll",
>> +       [I2S0_MCLK]     =3D "i2s0_mclk",
>> +       [I2S1_MCLK]     =3D "i2s1_mclk",
>> +       [RTC_OSC]       =3D "rtc_osc",
>> +       [USB_PLL]       =3D "usb_pll",
>> +};
>=20
> Why keep this list of names? Only clk_names[REFCLK] is used below and i=
t
> is overwritten by the name supplied by DT.

Ok.

> <snip>
>=20
>> +static void __init asm9260_acc_init(struct device_node *np)
>> +{
>> +       struct clk *clk;
>> +       u32 rate;
>> +       int n;
>> +       u32 accuracy =3D 0;
>> +
>> +       base =3D of_io_request_and_map(np, 0, np->name);
>> +       if (!base)
>> +               panic("%s: unable to map resource", np->name);
>> +
>> +       /* register pll */
>> +       rate =3D (ioread32(base + HW_SYSPLLCTRL) & 0xffff) * 1000000;
>> +
>> +       clk_names[REFCLK] =3D of_clk_get_parent_name(np, 0);
>> +       accuracy =3D clk_get_accuracy(__clk_lookup(clk_names[REFCLK]))=
;
>> +       clk =3D clk_register_fixed_rate_with_accuracy(NULL, clk_names[=
SYSPLL],
>> +                       clk_names[REFCLK], 0, rate, accuracy);
>=20
> This is different. Why do the PLLs inherit REFCLKs accuracy? Please see=

> __clk_recalc_accuracies in drivers/clk/clk.c if you haven't already. We=

> propagate accuracy through the clock tree already.

clk_register_fixed_rate overwrite accuracy to 0. If i use
clk_register_fixed_rate, then half of my clocks has accuracy =3D 0.

>> +
>> +       if (IS_ERR(clk))
>> +               panic("%s: can't register REFCLK. Check DT!", np->name=
);
>> +

<snip>

>> +
>> +       /* register clk-provider */
>> +       clk_data.clks =3D clks;
>> +       clk_data.clk_num =3D MAX_CLKS;
>> +       of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
>> +       return;
>> +fail:
>> +       iounmap(base);
>> +}
>> +CLK_OF_DECLARE(asm9260_acc, "alphascale,asm9260-clock-controller",
>> +               asm9260_acc_init);
>=20
> Where is the DT binding definition for this clock provider?
>=20
> Thanks,
> Mike
>=20

do you mean this patch?
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/293147=
=2Ehtml
(probably not last version)
Should i resend it to you?

--=20
Regards,
Oleksij


--jLNBg8SoxtMTJCXhtk22ueR5qjI7rTK5f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlS3jEEACgkQHwImuRkmbWk2PQD/QTBvmUDuTDngUcn39mhLpKw2
OV+DvdIgbcol8rZO9XoA/2TPIEjlgSo7oZV2aPS51x5/Ypakv2V+7pbLkFP5EVeA
=MlKe
-----END PGP SIGNATURE-----

--jLNBg8SoxtMTJCXhtk22ueR5qjI7rTK5f--
