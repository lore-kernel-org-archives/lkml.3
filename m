Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab3JHN7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:59:02 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:37582 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3JHN67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:58:59 -0400
Date: Tue, 8 Oct 2013 15:56:54 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: swarren@wwwdotorg.org, ian.campbell@citrix.com, mark.rutland@arm.com,
        pawel.moll@arm.com, rob.herring@calxeda.com
Cc: r65073@freescale.com, s.hauer@pengutronix.de, t.figa@samsung.com,
        grant.likely@linaro.org, linux@arm.linux.org.uk, rob@landley.net,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Subject: Re: [PATCHv5 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM.
Message-ID: <20131008135654.GB16550@ulmo.nvidia.com>
References: <1380521611-2764-1-git-send-email-Li.Xiubo@freescale.com>
 <1380521611-2764-5-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <1380521611-2764-5-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2013 at 02:13:31PM +0800, Xiubo Li wrote:
> This adds the Document for Freescale FTM PWM driver under
> Documentation/devicetree/bindings/pwm/.
>=20
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        | 33 ++++++++++++++++=
++++++
>  1 file changed, 33 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt

Can someone of the device tree bindings maintainers review and ACK this?
I think it'd be good to squash this patch with the driver patch (patch 1
of this series). I can do that when I apply this.

Thierry

>=20
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt b/Docu=
mentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> new file mode 100644
> index 0000000..2c6969a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> @@ -0,0 +1,33 @@
> +Freescale FTM PWM controller
> +
> +Required properties:
> +- compatible: Should be "fsl,vf610-ftm-pwm"
> +- reg: Physical base address and length of the controller's registers
> +- #pwm-cells: Should be 3. See pwm.txt in this directory for a descripti=
on of
> +  the cells format.
> +- clock-names : Includes the following module clock source entries:
> +    "ftm0" (system clock),
> +    "ftm0_fix_sel" (fixed frequency clock),
> +    "ftm0_ext_sel" (external clock)
> +- clocks : Must contain a clock specifier for each entry in clock-names.
> +- fsl,pwm-counter-clk: The FTM PWM counter clock source, should be one o=
f the
> +  entries in clock-names.
> +- pinctrl-names: must contain a "default" entry.
> +- pinctrl-NNN: One property must exist for each entry in pinctrl-names.
> +  See ../pinctrl/pinctrl-bindings.txt for details of the property values.
> +
> +
> +Example:
> +
> +pwm0: pwm@40038000 {
> +		compatible =3D "fsl,vf610-ftm-pwm";
> +		reg =3D <0x40038000 0x1000>;
> +		#pwm-cells =3D <3>;
> +		clock-names =3D "ftm0", "ftm0_fix_sel", "ftm0_ext_sel";
> +		clocks =3D <&clks VF610_CLK_FTM0>,
> +			<&clks VF610_CLK_FTM0_FIX_SEL>,
> +			<&clks VF610_CLK_FTM0_EXT_SEL>;
> +		pinctrl-names =3D "default";
> +		pinctrl-0 =3D <&pinctrl_pwm0_1>;
> +		fsl,pwm-counter-clk =3D "ftm0_ext_sel";
> +};
> --=20
> 1.8.0
>=20
>=20

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVA8mAAoJEN0jrNd/PrOhEHUP/1PxtT0TcuUa+I4RW/539+Vj
8dp3U4etNyWLxHJlKcipx4RiFpfh7FnadMoU7vT/qpATGCs9BlVsAn6gOsqh/lXu
GfdQB76PjFUu6e+l36AVEiiLcj5vxhU4ypZQ1/2Ycb1ZGWM17mbajpMZvlj8AaXH
k2ALm47v89c/RJw5q1xql9z0fHehlRzSov5eBbJCmVYnXCU2S4sFa2KVSbcfHNvF
jt5ZQ1/OzM5v5lP3grK8bfWZLc/rSTeFthTvKEGBAdBQjpgWNn+vzrEux/nnGxpV
h/n3dXJ6Rg04/r7WQAMZxt3AjvG2XvdniWIiGyYJbj207/J3P9rysZmvifqERrI2
JTDNeBEoqKz1m+hIH1wgNpCmwDbJ1b5+BhmP9285hDgEHVCwLIliklVDLKSlq/Fx
7CssL/ML43aMoVmRSd647cV2RR8COC2TtD2xyGV5m3aa9zP2lBvBieY4ZMXuO14W
M7kV6MxjvPJK+7gkpFY7IknlfKAks3b15y22WLKzRjIvSXqRMuIdtUtDQ/ksfH0v
NuWps9G7R7xoSsVBmo+WDuRlKGuYGY51gIue3pKCLrCjL7mT/iloSKq85MPHcsAO
XIp9X/mYvbsZYQznn8k9Mibf1jKO4gZV9GUrv0CXYQ4bzuHR+vyB7wt9ojcowglf
FloPCF6bhwtINt02V4sh
=lW13
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
