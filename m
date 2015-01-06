Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbbAFNHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:07:06 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36217 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbbAFNHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:07:03 -0500
Date: Tue, 6 Jan 2015 14:06:58 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-tegra@vger.kernel.org, Dylan Reid <dgreid@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: tegra: Move out nyan-generic parts out from the
 nyan-big DT
Message-ID: <20150106130656.GF31830@ulmo.nvidia.com>
References: <1420540653-14816-1-git-send-email-tomeu.vizoso@collabora.com>
 <1420540653-14816-3-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CXFpZVxO6m2Ol4tQ"
Content-Disposition: inline
In-Reply-To: <1420540653-14816-3-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CXFpZVxO6m2Ol4tQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Cc'ing Dylan and Olof. I've verified that the resulting nyan-big DTB
after this series is exactly the same as before (well, except where
changes were made on purpose), but I'd like an Ack from either of you
regarding the split into the nyan DTS include.

Quoting the full patch for Dylan and Olof, one comment below (near the
bottom).

On Tue, Jan 06, 2015 at 11:37:27AM +0100, Tomeu Vizoso wrote:
> In preparation for adding the DT for the nyan-blaze board.
>=20
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  arch/arm/boot/dts/tegra124-nyan-big.dts | 1131 +------------------------=
-----
>  arch/arm/boot/dts/tegra124-nyan.dtsi    | 1133 +++++++++++++++++++++++++=
++++++
>  2 files changed, 1136 insertions(+), 1128 deletions(-)
>  create mode 100644 arch/arm/boot/dts/tegra124-nyan.dtsi
>=20
> diff --git a/arch/arm/boot/dts/tegra124-nyan-big.dts b/arch/arm/boot/dts/=
tegra124-nyan-big.dts
> index 4752572..2041077 100644
> --- a/arch/arm/boot/dts/tegra124-nyan-big.dts
> +++ b/arch/arm/boot/dts/tegra124-nyan-big.dts
> @@ -1,1137 +1,12 @@
>  /dts-v1/;
> =20
> -#include <dt-bindings/input/input.h>
> -#include "tegra124.dtsi"
> +#include "tegra124-nyan.dtsi"
> =20
>  / {
>  	model =3D "Acer Chromebook 13 CB5-311";
> -	compatible =3D "google,nyan-big", "nvidia,tegra124";
> -
> -	aliases {
> -		rtc0 =3D "/i2c@0,7000d000/pmic@40";
> -		rtc1 =3D "/rtc@0,7000e000";
> -		serial0 =3D &uarta;
> -	};
> -
> -	memory {
> -		reg =3D <0x0 0x80000000 0x0 0x80000000>;
> -	};
> -
> -	host1x@0,50000000 {
> -		hdmi@0,54280000 {
> -			status =3D "okay";
> -
> -			vdd-supply =3D <&vdd_3v3_hdmi>;
> -			pll-supply =3D <&vdd_hdmi_pll>;
> -			hdmi-supply =3D <&vdd_5v0_hdmi>;
> -
> -			nvidia,ddc-i2c-bus =3D <&hdmi_ddc>;
> -			nvidia,hpd-gpio =3D
> -				<&gpio TEGRA_GPIO(N, 7) GPIO_ACTIVE_HIGH>;
> -		};
> -
> -		sor@0,54540000 {
> -			status =3D "okay";
> -
> -			nvidia,dpaux =3D <&dpaux>;
> -			nvidia,panel =3D <&panel>;
> -		};
> -
> -		dpaux@0,545c0000 {
> -			vdd-supply =3D <&vdd_3v3_panel>;
> -			status =3D "okay";
> -		};
> -	};
> -
> -	pinmux@0,70000868 {
> -		pinctrl-names =3D "boot";
> -		pinctrl-0 =3D <&pinmux_boot>;
> -
> -		pinmux_boot: common {
> -			dap_mclk1_pw4 {
> -				nvidia,pins =3D "dap_mclk1_pw4";
> -				nvidia,function =3D "extperiph1";
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			dap2_din_pa4 {
> -				nvidia,pins =3D "dap2_din_pa4";
> -				nvidia,function =3D "i2s1";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			dap2_dout_pa5 {
> -				nvidia,pins =3D "dap2_dout_pa5",
> -					      "dap2_fs_pa2",
> -					      "dap2_sclk_pa3";
> -				nvidia,function =3D "i2s1";
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			dvfs_pwm_px0 {
> -				nvidia,pins =3D "dvfs_pwm_px0",
> -					      "dvfs_clk_px2";
> -				nvidia,function =3D "cldvfs";
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			ulpi_clk_py0 {
> -				nvidia,pins =3D "ulpi_clk_py0",
> -					      "ulpi_nxt_py2",
> -					      "ulpi_stp_py3";
> -				nvidia,function =3D "spi1";
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			ulpi_dir_py1 {
> -				nvidia,pins =3D "ulpi_dir_py1";
> -				nvidia,function =3D "spi1";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			cam_i2c_scl_pbb1 {
> -				nvidia,pins =3D "cam_i2c_scl_pbb1",
> -					      "cam_i2c_sda_pbb2";
> -				nvidia,function =3D "i2c3";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,open-drain =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			gen2_i2c_scl_pt5 {
> -				nvidia,pins =3D "gen2_i2c_scl_pt5",
> -					      "gen2_i2c_sda_pt6";
> -				nvidia,function =3D "i2c2";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,open-drain =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			pg4 {
> -				nvidia,pins =3D "pg4",
> -					      "pg5",
> -					      "pg6",
> -					      "pi3";
> -				nvidia,function =3D "spi4";
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			pg7 {
> -				nvidia,pins =3D "pg7";
> -				nvidia,function =3D "spi4";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			ph1 {
> -				nvidia,pins =3D "ph1";
> -				nvidia,function =3D "pwm1";
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			pk0 {
> -				nvidia,pins =3D "pk0",
> -					      "kb_row15_ps7",
> -					      "clk_32k_out_pa0";
> -				nvidia,function =3D "soc";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			sdmmc1_clk_pz0 {
> -				nvidia,pins =3D "sdmmc1_clk_pz0";
> -				nvidia,function =3D "sdmmc1";
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			sdmmc1_cmd_pz1 {
> -				nvidia,pins =3D "sdmmc1_cmd_pz1",
> -					      "sdmmc1_dat0_py7",
> -					      "sdmmc1_dat1_py6",
> -					      "sdmmc1_dat2_py5",
> -					      "sdmmc1_dat3_py4";
> -				nvidia,function =3D "sdmmc1";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			sdmmc3_clk_pa6 {
> -				nvidia,pins =3D "sdmmc3_clk_pa6";
> -				nvidia,function =3D "sdmmc3";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			sdmmc3_cmd_pa7 {
> -				nvidia,pins =3D "sdmmc3_cmd_pa7",
> -					      "sdmmc3_dat0_pb7",
> -					      "sdmmc3_dat1_pb6",
> -					      "sdmmc3_dat2_pb5",
> -					      "sdmmc3_dat3_pb4",
> -					      "kb_col4_pq4",
> -					      "sdmmc3_clk_lb_out_pee4",
> -					      "sdmmc3_clk_lb_in_pee5",
> -					      "sdmmc3_cd_n_pv2";
> -				nvidia,function =3D "sdmmc3";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			sdmmc4_clk_pcc4 {
> -				nvidia,pins =3D "sdmmc4_clk_pcc4";
> -				nvidia,function =3D "sdmmc4";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			sdmmc4_cmd_pt7 {
> -				nvidia,pins =3D "sdmmc4_cmd_pt7",
> -					      "sdmmc4_dat0_paa0",
> -					      "sdmmc4_dat1_paa1",
> -					      "sdmmc4_dat2_paa2",
> -					      "sdmmc4_dat3_paa3",
> -					      "sdmmc4_dat4_paa4",
> -					      "sdmmc4_dat5_paa5",
> -					      "sdmmc4_dat6_paa6",
> -					      "sdmmc4_dat7_paa7";
> -				nvidia,function =3D "sdmmc4";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			pwr_i2c_scl_pz6 {
> -				nvidia,pins =3D "pwr_i2c_scl_pz6",
> -					      "pwr_i2c_sda_pz7";
> -				nvidia,function =3D "i2cpwr";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,open-drain =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			jtag_rtck {
> -				nvidia,pins =3D "jtag_rtck";
> -				nvidia,function =3D "rtck";
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			clk_32k_in {
> -				nvidia,pins =3D "clk_32k_in";
> -				nvidia,function =3D "clk";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			core_pwr_req {
> -				nvidia,pins =3D "core_pwr_req";
> -				nvidia,function =3D "pwron";
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			cpu_pwr_req {
> -				nvidia,pins =3D "cpu_pwr_req";
> -				nvidia,function =3D "cpu";
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			pwr_int_n {
> -				nvidia,pins =3D "pwr_int_n";
> -				nvidia,function =3D "pmi";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			reset_out_n {
> -				nvidia,pins =3D "reset_out_n";
> -				nvidia,function =3D "reset_out_n";
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			clk3_out_pee0 {
> -				nvidia,pins =3D "clk3_out_pee0";
> -				nvidia,function =3D "extperiph3";
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			gen1_i2c_sda_pc5 {
> -				nvidia,pins =3D "gen1_i2c_sda_pc5",
> -					      "gen1_i2c_scl_pc4";
> -				nvidia,function =3D "i2c1";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,open-drain =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			hdmi_cec_pee3 {
> -				nvidia,pins =3D "hdmi_cec_pee3";
> -				nvidia,function =3D "cec";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,open-drain =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			hdmi_int_pn7 {
> -				nvidia,pins =3D "hdmi_int_pn7";
> -				nvidia,function =3D "rsvd1";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_DOWN>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			ddc_scl_pv4 {
> -				nvidia,pins =3D "ddc_scl_pv4",
> -					      "ddc_sda_pv5";
> -				nvidia,function =3D "i2c4";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,rcv-sel =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			kb_row10_ps2 {
> -				nvidia,pins =3D "kb_row10_ps2";
> -				nvidia,function =3D "uarta";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			kb_row9_ps1 {
> -				nvidia,pins =3D "kb_row9_ps1";
> -				nvidia,function =3D "uarta";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			usb_vbus_en0_pn4 {
> -				nvidia,pins =3D "usb_vbus_en0_pn4",
> -					      "usb_vbus_en1_pn5";
> -				nvidia,function =3D "usb";
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,open-drain =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			drive_sdio1 {
> -				nvidia,pins =3D "drive_sdio1";
> -				nvidia,high-speed-mode =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,schmitt =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull-down-strength =3D <36>;
> -				nvidia,pull-up-strength =3D <20>;
> -				nvidia,slew-rate-rising =3D <TEGRA_PIN_SLEW_RATE_SLOW>;
> -				nvidia,slew-rate-falling =3D <TEGRA_PIN_SLEW_RATE_SLOW>;
> -			};
> -			drive_sdio3 {
> -				nvidia,pins =3D "drive_sdio3";
> -				nvidia,high-speed-mode =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,schmitt =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull-down-strength =3D <22>;
> -				nvidia,pull-up-strength =3D <36>;
> -				nvidia,slew-rate-rising =3D <TEGRA_PIN_SLEW_RATE_FASTEST>;
> -				nvidia,slew-rate-falling =3D <TEGRA_PIN_SLEW_RATE_FASTEST>;
> -			};
> -			drive_gma {
> -				nvidia,pins =3D "drive_gma";
> -				nvidia,high-speed-mode =3D <TEGRA_PIN_ENABLE>;
> -				nvidia,schmitt =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,pull-down-strength =3D <2>;
> -				nvidia,pull-up-strength =3D <1>;
> -				nvidia,slew-rate-rising =3D <TEGRA_PIN_SLEW_RATE_FASTEST>;
> -				nvidia,slew-rate-falling =3D <TEGRA_PIN_SLEW_RATE_FASTEST>;
> -				nvidia,drive-type =3D <1>;
> -			};
> -			codec_irq_l {
> -				nvidia,pins =3D "ph4";
> -				nvidia,function =3D "gmi";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			lcd_bl_en {
> -				nvidia,pins =3D "ph2";
> -				nvidia,function =3D "gmi";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_DOWN>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			touch_irq_l {
> -				nvidia,pins =3D "gpio_w3_aud_pw3";
> -				nvidia,function =3D "spi6";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			tpm_davint_l {
> -				nvidia,pins =3D "ph6";
> -				nvidia,function =3D "gmi";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			ts_irq_l {
> -				nvidia,pins =3D "pk2";
> -				nvidia,function =3D "gmi";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			ts_reset_l {
> -				nvidia,pins =3D "pk4";
> -				nvidia,function =3D "gmi";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			ts_shdn_l {
> -				nvidia,pins =3D "pk1";
> -				nvidia,function =3D "gmi";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			ph7 {
> -				nvidia,pins =3D "ph7";
> -				nvidia,function =3D "gmi";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			kb_col0_ap {
> -				nvidia,pins =3D "kb_col0_pq0";
> -				nvidia,function =3D "rsvd4";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			lid_open {
> -				nvidia,pins =3D "kb_row4_pr4";
> -				nvidia,function =3D "rsvd3";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			en_vdd_sd {
> -				nvidia,pins =3D "kb_row0_pr0";
> -				nvidia,function =3D "rsvd4";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			ac_ok {
> -				nvidia,pins =3D "pj0";
> -				nvidia,function =3D "gmi";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			sensor_irq_l {
> -				nvidia,pins =3D "pi6";
> -				nvidia,function =3D "gmi";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			wifi_en {
> -				nvidia,pins =3D "gpio_x7_aud_px7";
> -				nvidia,function =3D "rsvd4";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			en_vdd_bl {
> -				nvidia,pins =3D "dap3_dout_pp2";
> -				nvidia,function =3D "i2s2";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_DOWN>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			en_vdd_hdmi {
> -				nvidia,pins =3D "spdif_in_pk6";
> -				nvidia,function =3D "spdif";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_DOWN>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			soc_warm_reset_l {
> -				nvidia,pins =3D "pi5";
> -				nvidia,function =3D "gmi";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> -			};
> -			hp_det_l {
> -				nvidia,pins =3D "pi7";
> -				nvidia,function =3D "rsvd1";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -			};
> -			mic_det_l {
> -				nvidia,pins =3D "kb_row7_pr7";
> -				nvidia,function =3D "rsvd2";
> -				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> -				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> -				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> -			};
> -		};
> -	};
> -
> -	serial@0,70006000 {
> -		/* Debug connector on the bottom of the board near SD card. */
> -		status =3D "okay";
> -	};
> -
> -	pwm@0,7000a000 {
> -		status =3D "okay";
> -	};
> -
> -	i2c@0,7000c000 {
> -		status =3D "okay";
> -		clock-frequency =3D <100000>;
> -
> -		acodec: audio-codec@10 {
> -			compatible =3D "maxim,max98090";
> -			reg =3D <0x10>;
> -			interrupt-parent =3D <&gpio>;
> -			interrupts =3D <TEGRA_GPIO(H, 4) GPIO_ACTIVE_HIGH>;
> -		};
> -
> -		temperature-sensor@4c {
> -			compatible =3D "ti,tmp451";
> -			reg =3D <0x4c>;
> -			interrupt-parent =3D <&gpio>;
> -			interrupts =3D <TEGRA_GPIO(I, 6) IRQ_TYPE_LEVEL_LOW>;
> -
> -			#thermal-sensor-cells =3D <1>;
> -		};
> -	};
> -
> -	i2c@0,7000c400 {
> -		status =3D "okay";
> -		clock-frequency =3D <100000>;
> -	};
> -
> -	i2c@0,7000c500 {
> -		status =3D "okay";
> -		clock-frequency =3D <400000>;
> -
> -		tpm@20 {
> -			compatible =3D "infineon,slb9645tt";
> -			reg =3D <0x20>;
> -		};
> -	};
> -
> -	hdmi_ddc: i2c@0,7000c700 {
> -		status =3D "okay";
> -		clock-frequency =3D <100000>;
> -	};
> -
> -	i2c@0,7000d000 {
> -		status =3D "okay";
> -		clock-frequency =3D <400000>;
> -
> -		pmic: pmic@40 {
> -			compatible =3D "ams,as3722";
> -			reg =3D <0x40>;
> -			interrupts =3D <0 86 IRQ_TYPE_LEVEL_HIGH>;
> -
> -			ams,system-power-controller;
> -
> -			#interrupt-cells =3D <2>;
> -			interrupt-controller;
> -
> -			gpio-controller;
> -			#gpio-cells =3D <2>;
> -
> -			pinctrl-names =3D "default";
> -			pinctrl-0 =3D <&as3722_default>;
> -
> -			as3722_default: pinmux {
> -				gpio0 {
> -					pins =3D "gpio0";
> -					function =3D "gpio";
> -					bias-pull-down;
> -				};
> -
> -				gpio1 {
> -					pins =3D "gpio1";
> -					function =3D "gpio";
> -					bias-pull-up;
> -				};
> -
> -				gpio2_4_7 {
> -					pins =3D "gpio2", "gpio4", "gpio7";
> -					function =3D "gpio";
> -					bias-pull-up;
> -				};
> -
> -				gpio3_6 {
> -					pins =3D "gpio3", "gpio6";
> -					bias-high-impedance;
> -				};
> -
> -				gpio5 {
> -					pins =3D "gpio5";
> -					function =3D "clk32k-out";
> -					bias-pull-down;
> -				};
> -			};
> -
> -			regulators {
> -				vsup-sd2-supply =3D <&vdd_5v0_sys>;
> -				vsup-sd3-supply =3D <&vdd_5v0_sys>;
> -				vsup-sd4-supply =3D <&vdd_5v0_sys>;
> -				vsup-sd5-supply =3D <&vdd_5v0_sys>;
> -				vin-ldo0-supply =3D <&vdd_1v35_lp0>;
> -				vin-ldo1-6-supply =3D <&vdd_3v3_run>;
> -				vin-ldo2-5-7-supply =3D <&vddio_1v8>;
> -				vin-ldo3-4-supply =3D <&vdd_3v3_sys>;
> -				vin-ldo9-10-supply =3D <&vdd_5v0_sys>;
> -				vin-ldo11-supply =3D <&vdd_3v3_run>;
> -
> -				sd0 {
> -					regulator-name =3D "+VDD_CPU_AP";
> -					regulator-min-microvolt =3D <700000>;
> -					regulator-max-microvolt =3D <1350000>;
> -					regulator-min-microamp =3D <3500000>;
> -					regulator-max-microamp =3D <3500000>;
> -					regulator-always-on;
> -					regulator-boot-on;
> -					ams,ext-control =3D <2>;
> -				};
> -
> -				sd1 {
> -					regulator-name =3D "+VDD_CORE";
> -					regulator-min-microvolt =3D <700000>;
> -					regulator-max-microvolt =3D <1350000>;
> -					regulator-min-microamp =3D <2500000>;
> -					regulator-max-microamp =3D <4000000>;
> -					regulator-always-on;
> -					regulator-boot-on;
> -					ams,ext-control =3D <1>;
> -				};
> -
> -				vdd_1v35_lp0: sd2 {
> -					regulator-name =3D "+1.35V_LP0(sd2)";
> -					regulator-min-microvolt =3D <1350000>;
> -					regulator-max-microvolt =3D <1350000>;
> -					regulator-always-on;
> -					regulator-boot-on;
> -				};
> -
> -				sd3 {
> -					regulator-name =3D "+1.35V_LP0(sd3)";
> -					regulator-min-microvolt =3D <1350000>;
> -					regulator-max-microvolt =3D <1350000>;
> -					regulator-always-on;
> -					regulator-boot-on;
> -				};
> -
> -				vdd_1v05_run: sd4 {
> -					regulator-name =3D "+1.05V_RUN";
> -					regulator-min-microvolt =3D <1050000>;
> -					regulator-max-microvolt =3D <1050000>;
> -				};
> -
> -				vddio_1v8: sd5 {
> -					regulator-name =3D "+1.8V_VDDIO";
> -					regulator-min-microvolt =3D <1800000>;
> -					regulator-max-microvolt =3D <1800000>;
> -					regulator-boot-on;
> -					regulator-always-on;
> -				};
> -
> -				sd6 {
> -					regulator-name =3D "+VDD_GPU_AP";
> -					regulator-min-microvolt =3D <650000>;
> -					regulator-max-microvolt =3D <1200000>;
> -					regulator-min-microamp =3D <3500000>;
> -					regulator-max-microamp =3D <3500000>;
> -					regulator-boot-on;
> -					regulator-always-on;
> -				};
> -
> -				ldo0 {
> -					regulator-name =3D "+1.05V_RUN_AVDD";
> -					regulator-min-microvolt =3D <1050000>;
> -					regulator-max-microvolt =3D <1050000>;
> -					regulator-boot-on;
> -					regulator-always-on;
> -					ams,ext-control =3D <1>;
> -				};
> -
> -				ldo1 {
> -					regulator-name =3D "+1.8V_RUN_CAM";
> -					regulator-min-microvolt =3D <1800000>;
> -					regulator-max-microvolt =3D <1800000>;
> -				};
> -
> -				ldo2 {
> -					regulator-name =3D "+1.2V_GEN_AVDD";
> -					regulator-min-microvolt =3D <1200000>;
> -					regulator-max-microvolt =3D <1200000>;
> -					regulator-boot-on;
> -					regulator-always-on;
> -				};
> -
> -				ldo3 {
> -					regulator-name =3D "+1.00V_LP0_VDD_RTC";
> -					regulator-min-microvolt =3D <1000000>;
> -					regulator-max-microvolt =3D <1000000>;
> -					regulator-boot-on;
> -					regulator-always-on;
> -					ams,enable-tracking;
> -				};
> -
> -				vdd_run_cam: ldo4 {
> -					regulator-name =3D "+3.3V_RUN_CAM";
> -					regulator-min-microvolt =3D <2800000>;
> -					regulator-max-microvolt =3D <2800000>;
> -				};
> -
> -				ldo5 {
> -					regulator-name =3D "+1.2V_RUN_CAM_FRONT";
> -					regulator-min-microvolt =3D <1200000>;
> -					regulator-max-microvolt =3D <1200000>;
> -				};
> -
> -				vddio_sdmmc3: ldo6 {
> -					regulator-name =3D "+VDDIO_SDMMC3";
> -					regulator-min-microvolt =3D <1800000>;
> -					regulator-max-microvolt =3D <3300000>;
> -				};
> -
> -				ldo7 {
> -					regulator-name =3D "+1.05V_RUN_CAM_REAR";
> -					regulator-min-microvolt =3D <1050000>;
> -					regulator-max-microvolt =3D <1050000>;
> -				};
> -
> -				ldo9 {
> -					regulator-name =3D "+2.8V_RUN_TOUCH";
> -					regulator-min-microvolt =3D <2800000>;
> -					regulator-max-microvolt =3D <2800000>;
> -				};
> -
> -				ldo10 {
> -					regulator-name =3D "+2.8V_RUN_CAM_AF";
> -					regulator-min-microvolt =3D <2800000>;
> -					regulator-max-microvolt =3D <2800000>;
> -				};
> -
> -				ldo11 {
> -					regulator-name =3D "+1.8V_RUN_VPP_FUSE";
> -					regulator-min-microvolt =3D <1800000>;
> -					regulator-max-microvolt =3D <1800000>;
> -				};
> -			};
> -		};
> -	};
> -
> -	spi@0,7000d400 {
> -		status =3D "okay";
> -
> -		cros_ec: cros-ec@0 {
> -			compatible =3D "google,cros-ec-spi";
> -			spi-max-frequency =3D <3000000>;
> -			interrupt-parent =3D <&gpio>;
> -			interrupts =3D <TEGRA_GPIO(C, 7) IRQ_TYPE_LEVEL_LOW>;
> -			reg =3D <0>;
> -
> -			google,cros-ec-spi-msg-delay =3D <2000>;
> -
> -			i2c-tunnel {
> -				compatible =3D "google,cros-ec-i2c-tunnel";
> -				#address-cells =3D <1>;
> -				#size-cells =3D <0>;
> -
> -				google,remote-bus =3D <0>;
> -
> -				charger: bq24735@9 {
> -					compatible =3D "ti,bq24735";
> -					reg =3D <0x9>;
> -					interrupt-parent =3D <&gpio>;
> -					interrupts =3D <TEGRA_GPIO(J, 0)
> -							GPIO_ACTIVE_HIGH>;
> -					ti,ac-detect-gpios =3D <&gpio
> -							TEGRA_GPIO(J, 0)
> -							GPIO_ACTIVE_HIGH>;
> -				};
> -
> -				battery: sbs-battery@b {
> -					compatible =3D "sbs,sbs-battery";
> -					reg =3D <0xb>;
> -					sbs,i2c-retry-count =3D <2>;
> -					sbs,poll-retry-count =3D <10>;
> -					power-supplies =3D <&charger>;
> -				};
> -			};
> -		};
> -	};
> -
> -	spi@0,7000da00 {
> -		status =3D "okay";
> -		spi-max-frequency =3D <25000000>;
> -
> -		flash@0 {
> -			compatible =3D "winbond,w25q32dw";
> -			reg =3D <0>;
> -		};
> -	};
> -
> -	pmc@0,7000e400 {
> -		nvidia,invert-interrupt;
> -		nvidia,suspend-mode =3D <0>;
> -		nvidia,cpu-pwr-good-time =3D <500>;
> -		nvidia,cpu-pwr-off-time =3D <300>;
> -		nvidia,core-pwr-good-time =3D <641 3845>;
> -		nvidia,core-pwr-off-time =3D <61036>;
> -		nvidia,core-power-req-active-high;
> -		nvidia,sys-clock-req-active-high;
> -	};
> -
> -	hda@0,70030000 {
> -		status =3D "okay";
> -	};
> -
> -	sdhci@0,700b0000 { /* WiFi/BT on this bus */
> -		status =3D "okay";
> -		power-gpios =3D <&gpio TEGRA_GPIO(X, 7) GPIO_ACTIVE_HIGH>;
> -		bus-width =3D <4>;
> -		no-1-8-v;
> -		non-removable;
> -	};
> -
> -	sdhci@0,700b0400 { /* SD Card on this bus */
> -		status =3D "okay";
> -		cd-gpios =3D <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_LOW>;
> -		power-gpios =3D <&gpio TEGRA_GPIO(R, 0) GPIO_ACTIVE_HIGH>;
> -		wp-gpios =3D <&gpio TEGRA_GPIO(Q, 4) GPIO_ACTIVE_LOW>;
> -		bus-width =3D <4>;
> -		no-1-8-v;
> -		vqmmc-supply =3D <&vddio_sdmmc3>;
> -	};
> -
> -	sdhci@0,700b0600 { /* eMMC on this bus */
> -		status =3D "okay";
> -		bus-width =3D <8>;
> -		no-1-8-v;
> -		non-removable;
> -	};
> -
> -	ahub@0,70300000 {
> -		i2s@0,70301100 {
> -			status =3D "okay";
> -		};
> -	};
> -
> -	usb@0,7d000000 { /* Rear external USB port. */
> -		status =3D "okay";
> -	};
> -
> -	usb-phy@0,7d000000 {
> -		status =3D "okay";
> -		vbus-supply =3D <&vdd_usb1_vbus>;
> -	};
> -
> -	usb@0,7d004000 { /* Internal webcam. */
> -		status =3D "okay";
> -	};
> -
> -	usb-phy@0,7d004000 {
> -		status =3D "okay";
> -		vbus-supply =3D <&vdd_run_cam>;
> -	};
> -
> -	usb@0,7d008000 { /* Left external USB port. */
> -		status =3D "okay";
> -	};
> -
> -	usb-phy@0,7d008000 {
> -		status =3D "okay";
> -		vbus-supply =3D <&vdd_usb3_vbus>;
> -	};
> -
> -	backlight: backlight {
> -		compatible =3D "pwm-backlight";
> -
> -		enable-gpios =3D <&gpio TEGRA_GPIO(H, 2) GPIO_ACTIVE_HIGH>;
> -		power-supply =3D <&vdd_led>;
> -		pwms =3D <&pwm 1 1000000>;
> -
> -		default-brightness-level =3D <224>;
> -		brightness-levels =3D
> -			<  0   1   2   3   4   5   6   7
> -			   8   9  10  11  12  13  14  15
> -			  16  17  18  19  20  21  22  23
> -			  24  25  26  27  28  29  30  31
> -			  32  33  34  35  36  37  38  39
> -			  40  41  42  43  44  45  46  47
> -			  48  49  50  51  52  53  54  55
> -			  56  57  58  59  60  61  62  63
> -			  64  65  66  67  68  69  70  71
> -			  72  73  74  75  76  77  78  79
> -			  80  81  82  83  84  85  86  87
> -			  88  89  90  91  92  93  94  95
> -			  96  97  98  99 100 101 102 103
> -			 104 105 106 107 108 109 110 111
> -			 112 113 114 115 116 117 118 119
> -			 120 121 122 123 124 125 126 127
> -			 128 129 130 131 132 133 134 135
> -			 136 137 138 139 140 141 142 143
> -			 144 145 146 147 148 149 150 151
> -			 152 153 154 155 156 157 158 159
> -			 160 161 162 163 164 165 166 167
> -			 168 169 170 171 172 173 174 175
> -			 176 177 178 179 180 181 182 183
> -			 184 185 186 187 188 189 190 191
> -			 192 193 194 195 196 197 198 199
> -			 200 201 202 203 204 205 206 207
> -			 208 209 210 211 212 213 214 215
> -			 216 217 218 219 220 221 222 223
> -			 224 225 226 227 228 229 230 231
> -			 232 233 234 235 236 237 238 239
> -			 240 241 242 243 244 245 246 247
> -			 248 249 250 251 252 253 254 255
> -			 256>;
> -	};
> -
> -	clocks {
> -		compatible =3D "simple-bus";
> -		#address-cells =3D <1>;
> -		#size-cells =3D <0>;
> -
> -		clk32k_in: clock@0 {
> -			compatible =3D "fixed-clock";
> -			reg =3D <0>;
> -			#clock-cells =3D <0>;
> -			clock-frequency =3D <32768>;
> -		};
> -	};
> -
> -	gpio-keys {
> -		compatible =3D "gpio-keys";
> -
> -		lid {
> -			label =3D "Lid";
> -			gpios =3D <&gpio TEGRA_GPIO(R, 4) GPIO_ACTIVE_LOW>;
> -			linux,input-type =3D <5>;
> -			linux,code =3D <KEY_RESERVED>;
> -			debounce-interval =3D <1>;
> -			gpio-key,wakeup;
> -		};
> -
> -		power {
> -			label =3D "Power";
> -			gpios =3D <&gpio TEGRA_GPIO(Q, 0) GPIO_ACTIVE_LOW>;
> -			linux,code =3D <KEY_POWER>;
> -			debounce-interval =3D <30>;
> -			gpio-key,wakeup;
> -		};
> -	};
> -
> -	panel: panel {
> -		compatible =3D "auo,b133xtn01";
> -
> -		backlight =3D <&backlight>;
> -		ddc-i2c-bus =3D <&dpaux>;
> -	};
> -
> -	regulators {
> -		compatible =3D "simple-bus";
> -		#address-cells =3D <1>;
> -		#size-cells =3D <0>;
> -
> -		vdd_mux: regulator@0 {
> -			compatible =3D "regulator-fixed";
> -			reg =3D <0>;
> -			regulator-name =3D "+VDD_MUX";
> -			regulator-min-microvolt =3D <12000000>;
> -			regulator-max-microvolt =3D <12000000>;
> -			regulator-always-on;
> -			regulator-boot-on;
> -		};
> -
> -		vdd_5v0_sys: regulator@1 {
> -			compatible =3D "regulator-fixed";
> -			reg =3D <1>;
> -			regulator-name =3D "+5V_SYS";
> -			regulator-min-microvolt =3D <5000000>;
> -			regulator-max-microvolt =3D <5000000>;
> -			regulator-always-on;
> -			regulator-boot-on;
> -			vin-supply =3D <&vdd_mux>;
> -		};
> -
> -		vdd_3v3_sys: regulator@2 {
> -			compatible =3D "regulator-fixed";
> -			reg =3D <2>;
> -			regulator-name =3D "+3.3V_SYS";
> -			regulator-min-microvolt =3D <3300000>;
> -			regulator-max-microvolt =3D <3300000>;
> -			regulator-always-on;
> -			regulator-boot-on;
> -			vin-supply =3D <&vdd_mux>;
> -		};
> -
> -		vdd_3v3_run: regulator@3 {
> -			compatible =3D "regulator-fixed";
> -			reg =3D <3>;
> -			regulator-name =3D "+3.3V_RUN";
> -			regulator-min-microvolt =3D <3300000>;
> -			regulator-max-microvolt =3D <3300000>;
> -			regulator-always-on;
> -			regulator-boot-on;
> -			gpio =3D <&pmic 1 GPIO_ACTIVE_HIGH>;
> -			enable-active-high;
> -			vin-supply =3D <&vdd_3v3_sys>;
> -		};
> -
> -		vdd_3v3_hdmi: regulator@4 {
> -			compatible =3D "regulator-fixed";
> -			reg =3D <4>;
> -			regulator-name =3D "+3.3V_AVDD_HDMI_AP_GATED";
> -			regulator-min-microvolt =3D <3300000>;
> -			regulator-max-microvolt =3D <3300000>;
> -			vin-supply =3D <&vdd_3v3_run>;
> -		};
> -
> -		vdd_led: regulator@5 {
> -			compatible =3D "regulator-fixed";
> -			reg =3D <5>;
> -			regulator-name =3D "+VDD_LED";
> -			gpio =3D <&gpio TEGRA_GPIO(P, 2) GPIO_ACTIVE_HIGH>;
> -			enable-active-high;
> -			vin-supply =3D <&vdd_mux>;
> -		};
> -
> -		vdd_5v0_ts: regulator@6 {
> -			compatible =3D "regulator-fixed";
> -			reg =3D <6>;
> -			regulator-name =3D "+5V_VDD_TS_SW";
> -			regulator-min-microvolt =3D <5000000>;
> -			regulator-max-microvolt =3D <5000000>;
> -			regulator-boot-on;
> -			gpio =3D <&gpio TEGRA_GPIO(K, 1) GPIO_ACTIVE_HIGH>;
> -			enable-active-high;
> -			vin-supply =3D <&vdd_5v0_sys>;
> -		};
> -
> -		vdd_usb1_vbus: regulator@7 {
> -			compatible =3D "regulator-fixed";
> -			reg =3D <7>;
> -			regulator-name =3D "+5V_USB_HS";
> -			regulator-min-microvolt =3D <5000000>;
> -			regulator-max-microvolt =3D <5000000>;
> -			gpio =3D <&gpio TEGRA_GPIO(N, 4) GPIO_ACTIVE_HIGH>;
> -			enable-active-high;
> -			gpio-open-drain;
> -			vin-supply =3D <&vdd_5v0_sys>;
> -		};
> -
> -		vdd_usb3_vbus: regulator@8 {
> -			compatible =3D "regulator-fixed";
> -			reg =3D <8>;
> -			regulator-name =3D "+5V_USB_SS";
> -			regulator-min-microvolt =3D <5000000>;
> -			regulator-max-microvolt =3D <5000000>;
> -			gpio =3D <&gpio TEGRA_GPIO(N, 5) GPIO_ACTIVE_HIGH>;
> -			enable-active-high;
> -			gpio-open-drain;
> -			vin-supply =3D <&vdd_5v0_sys>;
> -		};
> -
> -		vdd_3v3_panel: regulator@9 {
> -			compatible =3D "regulator-fixed";
> -			reg =3D <9>;
> -			regulator-name =3D "+3.3V_PANEL";
> -			regulator-min-microvolt =3D <3300000>;
> -			regulator-max-microvolt =3D <3300000>;
> -			gpio =3D <&pmic 4 GPIO_ACTIVE_HIGH>;
> -			enable-active-high;
> -			vin-supply =3D <&vdd_3v3_run>;
> -		};
> -
> -		vdd_3v3_lp0: regulator@10 {
> -			compatible =3D "regulator-fixed";
> -			reg =3D <10>;
> -			regulator-name =3D "+3.3V_LP0";
> -			regulator-min-microvolt =3D <3300000>;
> -			regulator-max-microvolt =3D <3300000>;
> -			/*
> -			 * TODO: find a way to wire this up with the USB EHCI
> -			 * controllers so that it can be enabled on demand.
> -			 */
> -			regulator-always-on;
> -			gpio =3D <&pmic 2 GPIO_ACTIVE_HIGH>;
> -			enable-active-high;
> -			vin-supply =3D <&vdd_3v3_sys>;
> -		};
> -
> -		vdd_hdmi_pll: regulator@11 {
> -			compatible =3D "regulator-fixed";
> -			reg =3D <11>;
> -			regulator-name =3D "+1.05V_RUN_AVDD_HDMI_PLL";
> -			regulator-min-microvolt =3D <1050000>;
> -			regulator-max-microvolt =3D <1050000>;
> -			gpio =3D <&gpio TEGRA_GPIO(H, 7) GPIO_ACTIVE_LOW>;
> -			vin-supply =3D <&vdd_1v05_run>;
> -		};
> -
> -		vdd_5v0_hdmi: regulator@12 {
> -			compatible =3D "regulator-fixed";
> -			reg =3D <12>;
> -			regulator-name =3D "+5V_HDMI_CON";
> -			regulator-min-microvolt =3D <5000000>;
> -			regulator-max-microvolt =3D <5000000>;
> -			gpio =3D <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_HIGH>;
> -			enable-active-high;
> -			vin-supply =3D <&vdd_5v0_sys>;
> -		};
> -	};
> +	compatible =3D "google,nyan-big", "google,nyan", "nvidia,tegra124";
> =20
>  	sound {
> -		compatible =3D "nvidia,tegra-audio-max98090-nyan-big",
> -			     "nvidia,tegra-audio-max98090";
> -		nvidia,model =3D "Acer Chromebook 13";
> -
> -		nvidia,audio-routing =3D
> -			"Headphones", "HPR",
> -			"Headphones", "HPL",
> -			"Speakers", "SPKR",
> -			"Speakers", "SPKL",
> -			"Mic Jack", "MICBIAS",
> -			"DMICL", "Int Mic",
> -			"DMICR", "Int Mic",
> -			"IN34", "Mic Jack";
> -
> -		nvidia,i2s-controller =3D <&tegra_i2s1>;
> -		nvidia,audio-codec =3D <&acodec>;
> -
> -		clocks =3D <&tegra_car TEGRA124_CLK_PLL_A>,
> -			 <&tegra_car TEGRA124_CLK_PLL_A_OUT0>,
> -			 <&tegra_car TEGRA124_CLK_EXTERN1>;
> -		clock-names =3D "pll_a", "pll_a_out0", "mclk";
> -
> -		nvidia,hp-det-gpios =3D <&gpio TEGRA_GPIO(I, 7) GPIO_ACTIVE_HIGH>;
> +		nvidia,model =3D "Acer Chromebook 13 CB5-311";
>  	};
>  };
> -
> -#include "cros-ec-keyboard.dtsi"
> diff --git a/arch/arm/boot/dts/tegra124-nyan.dtsi b/arch/arm/boot/dts/teg=
ra124-nyan.dtsi
> new file mode 100644
> index 0000000..4c68658
> --- /dev/null
> +++ b/arch/arm/boot/dts/tegra124-nyan.dtsi
> @@ -0,0 +1,1133 @@
> +#include <dt-bindings/input/input.h>
> +#include "tegra124.dtsi"
> +
> +/ {
> +	compatible =3D "google,nyan", "nvidia,tegra124";
> +
> +	aliases {
> +		rtc0 =3D "/i2c@0,7000d000/pmic@40";
> +		rtc1 =3D "/rtc@0,7000e000";
> +		serial0 =3D &uarta;
> +	};
> +
> +	memory {
> +		reg =3D <0x0 0x80000000 0x0 0x80000000>;
> +	};
> +
> +	host1x@0,50000000 {
> +		hdmi@0,54280000 {
> +			status =3D "okay";
> +
> +			vdd-supply =3D <&vdd_3v3_hdmi>;
> +			pll-supply =3D <&vdd_hdmi_pll>;
> +			hdmi-supply =3D <&vdd_5v0_hdmi>;
> +
> +			nvidia,ddc-i2c-bus =3D <&hdmi_ddc>;
> +			nvidia,hpd-gpio =3D
> +				<&gpio TEGRA_GPIO(N, 7) GPIO_ACTIVE_HIGH>;
> +		};
> +
> +		sor@0,54540000 {
> +			status =3D "okay";
> +
> +			nvidia,dpaux =3D <&dpaux>;
> +			nvidia,panel =3D <&panel>;
> +		};
> +
> +		dpaux@0,545c0000 {
> +			vdd-supply =3D <&vdd_3v3_panel>;
> +			status =3D "okay";
> +		};
> +	};
> +
> +	pinmux@0,70000868 {
> +		pinctrl-names =3D "boot";
> +		pinctrl-0 =3D <&pinmux_boot>;
> +
> +		pinmux_boot: common {
> +			dap_mclk1_pw4 {
> +				nvidia,pins =3D "dap_mclk1_pw4";
> +				nvidia,function =3D "extperiph1";
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			dap2_din_pa4 {
> +				nvidia,pins =3D "dap2_din_pa4";
> +				nvidia,function =3D "i2s1";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			dap2_dout_pa5 {
> +				nvidia,pins =3D "dap2_dout_pa5",
> +					      "dap2_fs_pa2",
> +					      "dap2_sclk_pa3";
> +				nvidia,function =3D "i2s1";
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			dvfs_pwm_px0 {
> +				nvidia,pins =3D "dvfs_pwm_px0",
> +					      "dvfs_clk_px2";
> +				nvidia,function =3D "cldvfs";
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			ulpi_clk_py0 {
> +				nvidia,pins =3D "ulpi_clk_py0",
> +					      "ulpi_nxt_py2",
> +					      "ulpi_stp_py3";
> +				nvidia,function =3D "spi1";
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			ulpi_dir_py1 {
> +				nvidia,pins =3D "ulpi_dir_py1";
> +				nvidia,function =3D "spi1";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			cam_i2c_scl_pbb1 {
> +				nvidia,pins =3D "cam_i2c_scl_pbb1",
> +					      "cam_i2c_sda_pbb2";
> +				nvidia,function =3D "i2c3";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,open-drain =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			gen2_i2c_scl_pt5 {
> +				nvidia,pins =3D "gen2_i2c_scl_pt5",
> +					      "gen2_i2c_sda_pt6";
> +				nvidia,function =3D "i2c2";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,open-drain =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			pg4 {
> +				nvidia,pins =3D "pg4",
> +					      "pg5",
> +					      "pg6",
> +					      "pi3";
> +				nvidia,function =3D "spi4";
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			pg7 {
> +				nvidia,pins =3D "pg7";
> +				nvidia,function =3D "spi4";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			ph1 {
> +				nvidia,pins =3D "ph1";
> +				nvidia,function =3D "pwm1";
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			pk0 {
> +				nvidia,pins =3D "pk0",
> +					      "kb_row15_ps7",
> +					      "clk_32k_out_pa0";
> +				nvidia,function =3D "soc";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			sdmmc1_clk_pz0 {
> +				nvidia,pins =3D "sdmmc1_clk_pz0";
> +				nvidia,function =3D "sdmmc1";
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			sdmmc1_cmd_pz1 {
> +				nvidia,pins =3D "sdmmc1_cmd_pz1",
> +					      "sdmmc1_dat0_py7",
> +					      "sdmmc1_dat1_py6",
> +					      "sdmmc1_dat2_py5",
> +					      "sdmmc1_dat3_py4";
> +				nvidia,function =3D "sdmmc1";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			sdmmc3_clk_pa6 {
> +				nvidia,pins =3D "sdmmc3_clk_pa6";
> +				nvidia,function =3D "sdmmc3";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			sdmmc3_cmd_pa7 {
> +				nvidia,pins =3D "sdmmc3_cmd_pa7",
> +					      "sdmmc3_dat0_pb7",
> +					      "sdmmc3_dat1_pb6",
> +					      "sdmmc3_dat2_pb5",
> +					      "sdmmc3_dat3_pb4",
> +					      "kb_col4_pq4",
> +					      "sdmmc3_clk_lb_out_pee4",
> +					      "sdmmc3_clk_lb_in_pee5",
> +					      "sdmmc3_cd_n_pv2";
> +				nvidia,function =3D "sdmmc3";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			sdmmc4_clk_pcc4 {
> +				nvidia,pins =3D "sdmmc4_clk_pcc4";
> +				nvidia,function =3D "sdmmc4";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			sdmmc4_cmd_pt7 {
> +				nvidia,pins =3D "sdmmc4_cmd_pt7",
> +					      "sdmmc4_dat0_paa0",
> +					      "sdmmc4_dat1_paa1",
> +					      "sdmmc4_dat2_paa2",
> +					      "sdmmc4_dat3_paa3",
> +					      "sdmmc4_dat4_paa4",
> +					      "sdmmc4_dat5_paa5",
> +					      "sdmmc4_dat6_paa6",
> +					      "sdmmc4_dat7_paa7";
> +				nvidia,function =3D "sdmmc4";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			pwr_i2c_scl_pz6 {
> +				nvidia,pins =3D "pwr_i2c_scl_pz6",
> +					      "pwr_i2c_sda_pz7";
> +				nvidia,function =3D "i2cpwr";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,open-drain =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			jtag_rtck {
> +				nvidia,pins =3D "jtag_rtck";
> +				nvidia,function =3D "rtck";
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			clk_32k_in {
> +				nvidia,pins =3D "clk_32k_in";
> +				nvidia,function =3D "clk";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			core_pwr_req {
> +				nvidia,pins =3D "core_pwr_req";
> +				nvidia,function =3D "pwron";
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			cpu_pwr_req {
> +				nvidia,pins =3D "cpu_pwr_req";
> +				nvidia,function =3D "cpu";
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			pwr_int_n {
> +				nvidia,pins =3D "pwr_int_n";
> +				nvidia,function =3D "pmi";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			reset_out_n {
> +				nvidia,pins =3D "reset_out_n";
> +				nvidia,function =3D "reset_out_n";
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			clk3_out_pee0 {
> +				nvidia,pins =3D "clk3_out_pee0";
> +				nvidia,function =3D "extperiph3";
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			gen1_i2c_sda_pc5 {
> +				nvidia,pins =3D "gen1_i2c_sda_pc5",
> +					      "gen1_i2c_scl_pc4";
> +				nvidia,function =3D "i2c1";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,open-drain =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			hdmi_cec_pee3 {
> +				nvidia,pins =3D "hdmi_cec_pee3";
> +				nvidia,function =3D "cec";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,open-drain =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			hdmi_int_pn7 {
> +				nvidia,pins =3D "hdmi_int_pn7";
> +				nvidia,function =3D "rsvd1";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_DOWN>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			ddc_scl_pv4 {
> +				nvidia,pins =3D "ddc_scl_pv4",
> +					      "ddc_sda_pv5";
> +				nvidia,function =3D "i2c4";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,rcv-sel =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			kb_row10_ps2 {
> +				nvidia,pins =3D "kb_row10_ps2";
> +				nvidia,function =3D "uarta";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			kb_row9_ps1 {
> +				nvidia,pins =3D "kb_row9_ps1";
> +				nvidia,function =3D "uarta";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			usb_vbus_en0_pn4 {
> +				nvidia,pins =3D "usb_vbus_en0_pn4",
> +					      "usb_vbus_en1_pn5";
> +				nvidia,function =3D "usb";
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,lock =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,open-drain =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			drive_sdio1 {
> +				nvidia,pins =3D "drive_sdio1";
> +				nvidia,high-speed-mode =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,schmitt =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull-down-strength =3D <36>;
> +				nvidia,pull-up-strength =3D <20>;
> +				nvidia,slew-rate-rising =3D <TEGRA_PIN_SLEW_RATE_SLOW>;
> +				nvidia,slew-rate-falling =3D <TEGRA_PIN_SLEW_RATE_SLOW>;
> +			};
> +			drive_sdio3 {
> +				nvidia,pins =3D "drive_sdio3";
> +				nvidia,high-speed-mode =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,schmitt =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull-down-strength =3D <22>;
> +				nvidia,pull-up-strength =3D <36>;
> +				nvidia,slew-rate-rising =3D <TEGRA_PIN_SLEW_RATE_FASTEST>;
> +				nvidia,slew-rate-falling =3D <TEGRA_PIN_SLEW_RATE_FASTEST>;
> +			};
> +			drive_gma {
> +				nvidia,pins =3D "drive_gma";
> +				nvidia,high-speed-mode =3D <TEGRA_PIN_ENABLE>;
> +				nvidia,schmitt =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,pull-down-strength =3D <2>;
> +				nvidia,pull-up-strength =3D <1>;
> +				nvidia,slew-rate-rising =3D <TEGRA_PIN_SLEW_RATE_FASTEST>;
> +				nvidia,slew-rate-falling =3D <TEGRA_PIN_SLEW_RATE_FASTEST>;
> +				nvidia,drive-type =3D <1>;
> +			};
> +			codec_irq_l {
> +				nvidia,pins =3D "ph4";
> +				nvidia,function =3D "gmi";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			lcd_bl_en {
> +				nvidia,pins =3D "ph2";
> +				nvidia,function =3D "gmi";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_DOWN>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			touch_irq_l {
> +				nvidia,pins =3D "gpio_w3_aud_pw3";
> +				nvidia,function =3D "spi6";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			tpm_davint_l {
> +				nvidia,pins =3D "ph6";
> +				nvidia,function =3D "gmi";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			ts_irq_l {
> +				nvidia,pins =3D "pk2";
> +				nvidia,function =3D "gmi";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			ts_reset_l {
> +				nvidia,pins =3D "pk4";
> +				nvidia,function =3D "gmi";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			ts_shdn_l {
> +				nvidia,pins =3D "pk1";
> +				nvidia,function =3D "gmi";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			ph7 {
> +				nvidia,pins =3D "ph7";
> +				nvidia,function =3D "gmi";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			kb_col0_ap {
> +				nvidia,pins =3D "kb_col0_pq0";
> +				nvidia,function =3D "rsvd4";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			lid_open {
> +				nvidia,pins =3D "kb_row4_pr4";
> +				nvidia,function =3D "rsvd3";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			en_vdd_sd {
> +				nvidia,pins =3D "kb_row0_pr0";
> +				nvidia,function =3D "rsvd4";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			ac_ok {
> +				nvidia,pins =3D "pj0";
> +				nvidia,function =3D "gmi";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			sensor_irq_l {
> +				nvidia,pins =3D "pi6";
> +				nvidia,function =3D "gmi";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			wifi_en {
> +				nvidia,pins =3D "gpio_x7_aud_px7";
> +				nvidia,function =3D "rsvd4";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			en_vdd_bl {
> +				nvidia,pins =3D "dap3_dout_pp2";
> +				nvidia,function =3D "i2s2";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_DOWN>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			en_vdd_hdmi {
> +				nvidia,pins =3D "spdif_in_pk6";
> +				nvidia,function =3D "spdif";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_DOWN>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			soc_warm_reset_l {
> +				nvidia,pins =3D "pi5";
> +				nvidia,function =3D "gmi";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_DISABLE>;
> +			};
> +			hp_det_l {
> +				nvidia,pins =3D "pi7";
> +				nvidia,function =3D "rsvd1";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_NONE>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +			};
> +			mic_det_l {
> +				nvidia,pins =3D "kb_row7_pr7";
> +				nvidia,function =3D "rsvd2";
> +				nvidia,pull =3D <TEGRA_PIN_PULL_UP>;
> +				nvidia,tristate =3D <TEGRA_PIN_DISABLE>;
> +				nvidia,enable-input =3D <TEGRA_PIN_ENABLE>;
> +			};
> +		};
> +	};
> +
> +	serial@0,70006000 {
> +		/* Debug connector on the bottom of the board near SD card. */
> +		status =3D "okay";
> +	};
> +
> +	pwm@0,7000a000 {
> +		status =3D "okay";
> +	};
> +
> +	i2c@0,7000c000 {
> +		status =3D "okay";
> +		clock-frequency =3D <100000>;
> +
> +		acodec: audio-codec@10 {
> +			compatible =3D "maxim,max98090";
> +			reg =3D <0x10>;
> +			interrupt-parent =3D <&gpio>;
> +			interrupts =3D <TEGRA_GPIO(H, 4) GPIO_ACTIVE_HIGH>;
> +		};
> +
> +		temperature-sensor@4c {
> +			compatible =3D "ti,tmp451";
> +			reg =3D <0x4c>;
> +			interrupt-parent =3D <&gpio>;
> +			interrupts =3D <TEGRA_GPIO(I, 6) IRQ_TYPE_LEVEL_LOW>;
> +
> +			#thermal-sensor-cells =3D <1>;
> +		};
> +	};
> +
> +	i2c@0,7000c400 {
> +		status =3D "okay";
> +		clock-frequency =3D <100000>;
> +	};
> +
> +	i2c@0,7000c500 {
> +		status =3D "okay";
> +		clock-frequency =3D <400000>;
> +
> +		tpm@20 {
> +			compatible =3D "infineon,slb9645tt";
> +			reg =3D <0x20>;
> +		};
> +	};
> +
> +	hdmi_ddc: i2c@0,7000c700 {
> +		status =3D "okay";
> +		clock-frequency =3D <100000>;
> +	};
> +
> +	i2c@0,7000d000 {
> +		status =3D "okay";
> +		clock-frequency =3D <400000>;
> +
> +		pmic: pmic@40 {
> +			compatible =3D "ams,as3722";
> +			reg =3D <0x40>;
> +			interrupts =3D <0 86 IRQ_TYPE_LEVEL_HIGH>;
> +
> +			ams,system-power-controller;
> +
> +			#interrupt-cells =3D <2>;
> +			interrupt-controller;
> +
> +			gpio-controller;
> +			#gpio-cells =3D <2>;
> +
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&as3722_default>;
> +
> +			as3722_default: pinmux {
> +				gpio0 {
> +					pins =3D "gpio0";
> +					function =3D "gpio";
> +					bias-pull-down;
> +				};
> +
> +				gpio1 {
> +					pins =3D "gpio1";
> +					function =3D "gpio";
> +					bias-pull-up;
> +				};
> +
> +				gpio2_4_7 {
> +					pins =3D "gpio2", "gpio4", "gpio7";
> +					function =3D "gpio";
> +					bias-pull-up;
> +				};
> +
> +				gpio3_6 {
> +					pins =3D "gpio3", "gpio6";
> +					bias-high-impedance;
> +				};
> +
> +				gpio5 {
> +					pins =3D "gpio5";
> +					function =3D "clk32k-out";
> +					bias-pull-down;
> +				};
> +			};
> +
> +			regulators {
> +				vsup-sd2-supply =3D <&vdd_5v0_sys>;
> +				vsup-sd3-supply =3D <&vdd_5v0_sys>;
> +				vsup-sd4-supply =3D <&vdd_5v0_sys>;
> +				vsup-sd5-supply =3D <&vdd_5v0_sys>;
> +				vin-ldo0-supply =3D <&vdd_1v35_lp0>;
> +				vin-ldo1-6-supply =3D <&vdd_3v3_run>;
> +				vin-ldo2-5-7-supply =3D <&vddio_1v8>;
> +				vin-ldo3-4-supply =3D <&vdd_3v3_sys>;
> +				vin-ldo9-10-supply =3D <&vdd_5v0_sys>;
> +				vin-ldo11-supply =3D <&vdd_3v3_run>;
> +
> +				sd0 {
> +					regulator-name =3D "+VDD_CPU_AP";
> +					regulator-min-microvolt =3D <700000>;
> +					regulator-max-microvolt =3D <1350000>;
> +					regulator-min-microamp =3D <3500000>;
> +					regulator-max-microamp =3D <3500000>;
> +					regulator-always-on;
> +					regulator-boot-on;
> +					ams,ext-control =3D <2>;
> +				};
> +
> +				sd1 {
> +					regulator-name =3D "+VDD_CORE";
> +					regulator-min-microvolt =3D <700000>;
> +					regulator-max-microvolt =3D <1350000>;
> +					regulator-min-microamp =3D <2500000>;
> +					regulator-max-microamp =3D <4000000>;
> +					regulator-always-on;
> +					regulator-boot-on;
> +					ams,ext-control =3D <1>;
> +				};
> +
> +				vdd_1v35_lp0: sd2 {
> +					regulator-name =3D "+1.35V_LP0(sd2)";
> +					regulator-min-microvolt =3D <1350000>;
> +					regulator-max-microvolt =3D <1350000>;
> +					regulator-always-on;
> +					regulator-boot-on;
> +				};
> +
> +				sd3 {
> +					regulator-name =3D "+1.35V_LP0(sd3)";
> +					regulator-min-microvolt =3D <1350000>;
> +					regulator-max-microvolt =3D <1350000>;
> +					regulator-always-on;
> +					regulator-boot-on;
> +				};
> +
> +				vdd_1v05_run: sd4 {
> +					regulator-name =3D "+1.05V_RUN";
> +					regulator-min-microvolt =3D <1050000>;
> +					regulator-max-microvolt =3D <1050000>;
> +				};
> +
> +				vddio_1v8: sd5 {
> +					regulator-name =3D "+1.8V_VDDIO";
> +					regulator-min-microvolt =3D <1800000>;
> +					regulator-max-microvolt =3D <1800000>;
> +					regulator-boot-on;
> +					regulator-always-on;
> +				};
> +
> +				sd6 {
> +					regulator-name =3D "+VDD_GPU_AP";
> +					regulator-min-microvolt =3D <650000>;
> +					regulator-max-microvolt =3D <1200000>;
> +					regulator-min-microamp =3D <3500000>;
> +					regulator-max-microamp =3D <3500000>;
> +					regulator-boot-on;
> +					regulator-always-on;
> +				};
> +
> +				ldo0 {
> +					regulator-name =3D "+1.05V_RUN_AVDD";
> +					regulator-min-microvolt =3D <1050000>;
> +					regulator-max-microvolt =3D <1050000>;
> +					regulator-boot-on;
> +					regulator-always-on;
> +					ams,ext-control =3D <1>;
> +				};
> +
> +				ldo1 {
> +					regulator-name =3D "+1.8V_RUN_CAM";
> +					regulator-min-microvolt =3D <1800000>;
> +					regulator-max-microvolt =3D <1800000>;
> +				};
> +
> +				ldo2 {
> +					regulator-name =3D "+1.2V_GEN_AVDD";
> +					regulator-min-microvolt =3D <1200000>;
> +					regulator-max-microvolt =3D <1200000>;
> +					regulator-boot-on;
> +					regulator-always-on;
> +				};
> +
> +				ldo3 {
> +					regulator-name =3D "+1.00V_LP0_VDD_RTC";
> +					regulator-min-microvolt =3D <1000000>;
> +					regulator-max-microvolt =3D <1000000>;
> +					regulator-boot-on;
> +					regulator-always-on;
> +					ams,enable-tracking;
> +				};
> +
> +				vdd_run_cam: ldo4 {
> +					regulator-name =3D "+3.3V_RUN_CAM";
> +					regulator-min-microvolt =3D <2800000>;
> +					regulator-max-microvolt =3D <2800000>;
> +				};
> +
> +				ldo5 {
> +					regulator-name =3D "+1.2V_RUN_CAM_FRONT";
> +					regulator-min-microvolt =3D <1200000>;
> +					regulator-max-microvolt =3D <1200000>;
> +				};
> +
> +				vddio_sdmmc3: ldo6 {
> +					regulator-name =3D "+VDDIO_SDMMC3";
> +					regulator-min-microvolt =3D <1800000>;
> +					regulator-max-microvolt =3D <3300000>;
> +				};
> +
> +				ldo7 {
> +					regulator-name =3D "+1.05V_RUN_CAM_REAR";
> +					regulator-min-microvolt =3D <1050000>;
> +					regulator-max-microvolt =3D <1050000>;
> +				};
> +
> +				ldo9 {
> +					regulator-name =3D "+2.8V_RUN_TOUCH";
> +					regulator-min-microvolt =3D <2800000>;
> +					regulator-max-microvolt =3D <2800000>;
> +				};
> +
> +				ldo10 {
> +					regulator-name =3D "+2.8V_RUN_CAM_AF";
> +					regulator-min-microvolt =3D <2800000>;
> +					regulator-max-microvolt =3D <2800000>;
> +				};
> +
> +				ldo11 {
> +					regulator-name =3D "+1.8V_RUN_VPP_FUSE";
> +					regulator-min-microvolt =3D <1800000>;
> +					regulator-max-microvolt =3D <1800000>;
> +				};
> +			};
> +		};
> +	};
> +
> +	spi@0,7000d400 {
> +		status =3D "okay";
> +
> +		cros_ec: cros-ec@0 {
> +			compatible =3D "google,cros-ec-spi";
> +			spi-max-frequency =3D <3000000>;
> +			interrupt-parent =3D <&gpio>;
> +			interrupts =3D <TEGRA_GPIO(C, 7) IRQ_TYPE_LEVEL_LOW>;
> +			reg =3D <0>;
> +
> +			google,cros-ec-spi-msg-delay =3D <2000>;
> +
> +			i2c-tunnel {
> +				compatible =3D "google,cros-ec-i2c-tunnel";
> +				#address-cells =3D <1>;
> +				#size-cells =3D <0>;
> +
> +				google,remote-bus =3D <0>;
> +
> +				charger: bq24735@9 {
> +					compatible =3D "ti,bq24735";
> +					reg =3D <0x9>;
> +					interrupt-parent =3D <&gpio>;
> +					interrupts =3D <TEGRA_GPIO(J, 0)
> +							GPIO_ACTIVE_HIGH>;
> +					ti,ac-detect-gpios =3D <&gpio
> +							TEGRA_GPIO(J, 0)
> +							GPIO_ACTIVE_HIGH>;
> +				};
> +
> +				battery: sbs-battery@b {
> +					compatible =3D "sbs,sbs-battery";
> +					reg =3D <0xb>;
> +					sbs,i2c-retry-count =3D <2>;
> +					sbs,poll-retry-count =3D <10>;
> +					power-supplies =3D <&charger>;
> +				};
> +			};
> +		};
> +	};
> +
> +	spi@0,7000da00 {
> +		status =3D "okay";
> +		spi-max-frequency =3D <25000000>;
> +
> +		flash@0 {
> +			compatible =3D "winbond,w25q32dw";
> +			reg =3D <0>;
> +		};
> +	};
> +
> +	pmc@0,7000e400 {
> +		nvidia,invert-interrupt;
> +		nvidia,suspend-mode =3D <0>;
> +		nvidia,cpu-pwr-good-time =3D <500>;
> +		nvidia,cpu-pwr-off-time =3D <300>;
> +		nvidia,core-pwr-good-time =3D <641 3845>;
> +		nvidia,core-pwr-off-time =3D <61036>;
> +		nvidia,core-power-req-active-high;
> +		nvidia,sys-clock-req-active-high;
> +	};
> +
> +	hda@0,70030000 {
> +		status =3D "okay";
> +	};
> +
> +	sdhci@0,700b0000 { /* WiFi/BT on this bus */
> +		status =3D "okay";
> +		power-gpios =3D <&gpio TEGRA_GPIO(X, 7) GPIO_ACTIVE_HIGH>;
> +		bus-width =3D <4>;
> +		no-1-8-v;
> +		non-removable;
> +	};
> +
> +	sdhci@0,700b0400 { /* SD Card on this bus */
> +		status =3D "okay";
> +		cd-gpios =3D <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_LOW>;
> +		power-gpios =3D <&gpio TEGRA_GPIO(R, 0) GPIO_ACTIVE_HIGH>;
> +		wp-gpios =3D <&gpio TEGRA_GPIO(Q, 4) GPIO_ACTIVE_LOW>;
> +		bus-width =3D <4>;
> +		no-1-8-v;
> +		vqmmc-supply =3D <&vddio_sdmmc3>;
> +	};
> +
> +	sdhci@0,700b0600 { /* eMMC on this bus */
> +		status =3D "okay";
> +		bus-width =3D <8>;
> +		no-1-8-v;
> +		non-removable;
> +	};
> +
> +	ahub@0,70300000 {
> +		i2s@0,70301100 {
> +			status =3D "okay";
> +		};
> +	};
> +
> +	usb@0,7d000000 { /* Rear external USB port. */
> +		status =3D "okay";
> +	};
> +
> +	usb-phy@0,7d000000 {
> +		status =3D "okay";
> +		vbus-supply =3D <&vdd_usb1_vbus>;
> +	};
> +
> +	usb@0,7d004000 { /* Internal webcam. */
> +		status =3D "okay";
> +	};
> +
> +	usb-phy@0,7d004000 {
> +		status =3D "okay";
> +		vbus-supply =3D <&vdd_run_cam>;
> +	};
> +
> +	usb@0,7d008000 { /* Left external USB port. */
> +		status =3D "okay";
> +	};
> +
> +	usb-phy@0,7d008000 {
> +		status =3D "okay";
> +		vbus-supply =3D <&vdd_usb3_vbus>;
> +	};
> +
> +	backlight: backlight {
> +		compatible =3D "pwm-backlight";
> +
> +		enable-gpios =3D <&gpio TEGRA_GPIO(H, 2) GPIO_ACTIVE_HIGH>;
> +		power-supply =3D <&vdd_led>;
> +		pwms =3D <&pwm 1 1000000>;
> +
> +		default-brightness-level =3D <224>;
> +		brightness-levels =3D
> +			<  0   1   2   3   4   5   6   7
> +			   8   9  10  11  12  13  14  15
> +			  16  17  18  19  20  21  22  23
> +			  24  25  26  27  28  29  30  31
> +			  32  33  34  35  36  37  38  39
> +			  40  41  42  43  44  45  46  47
> +			  48  49  50  51  52  53  54  55
> +			  56  57  58  59  60  61  62  63
> +			  64  65  66  67  68  69  70  71
> +			  72  73  74  75  76  77  78  79
> +			  80  81  82  83  84  85  86  87
> +			  88  89  90  91  92  93  94  95
> +			  96  97  98  99 100 101 102 103
> +			 104 105 106 107 108 109 110 111
> +			 112 113 114 115 116 117 118 119
> +			 120 121 122 123 124 125 126 127
> +			 128 129 130 131 132 133 134 135
> +			 136 137 138 139 140 141 142 143
> +			 144 145 146 147 148 149 150 151
> +			 152 153 154 155 156 157 158 159
> +			 160 161 162 163 164 165 166 167
> +			 168 169 170 171 172 173 174 175
> +			 176 177 178 179 180 181 182 183
> +			 184 185 186 187 188 189 190 191
> +			 192 193 194 195 196 197 198 199
> +			 200 201 202 203 204 205 206 207
> +			 208 209 210 211 212 213 214 215
> +			 216 217 218 219 220 221 222 223
> +			 224 225 226 227 228 229 230 231
> +			 232 233 234 235 236 237 238 239
> +			 240 241 242 243 244 245 246 247
> +			 248 249 250 251 252 253 254 255
> +			 256>;
> +	};
> +
> +	clocks {
> +		compatible =3D "simple-bus";
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +
> +		clk32k_in: clock@0 {
> +			compatible =3D "fixed-clock";
> +			reg =3D <0>;
> +			#clock-cells =3D <0>;
> +			clock-frequency =3D <32768>;
> +		};
> +	};
> +
> +	gpio-keys {
> +		compatible =3D "gpio-keys";
> +
> +		lid {
> +			label =3D "Lid";
> +			gpios =3D <&gpio TEGRA_GPIO(R, 4) GPIO_ACTIVE_LOW>;
> +			linux,input-type =3D <5>;
> +			linux,code =3D <KEY_RESERVED>;
> +			debounce-interval =3D <1>;
> +			gpio-key,wakeup;
> +		};
> +
> +		power {
> +			label =3D "Power";
> +			gpios =3D <&gpio TEGRA_GPIO(Q, 0) GPIO_ACTIVE_LOW>;
> +			linux,code =3D <KEY_POWER>;
> +			debounce-interval =3D <30>;
> +			gpio-key,wakeup;
> +		};
> +	};
> +
> +	panel: panel {
> +		compatible =3D "auo,b133xtn01";
> +
> +		backlight =3D <&backlight>;
> +		ddc-i2c-bus =3D <&dpaux>;
> +	};

Back when we merged the nyan-big DTS there was some discussion and it
was concluded that the devices are very similar, with the panel being
one notable exception. So I think that this belongs in the nyan-big
DTS and you need to add a similar property to the nyan-blaze DTS with
the compatible for the panel used in the design. And you might need
to add an entry for the panel in the panel-simple driver, too.

Thierry

> +
> +	regulators {
> +		compatible =3D "simple-bus";
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +
> +		vdd_mux: regulator@0 {
> +			compatible =3D "regulator-fixed";
> +			reg =3D <0>;
> +			regulator-name =3D "+VDD_MUX";
> +			regulator-min-microvolt =3D <12000000>;
> +			regulator-max-microvolt =3D <12000000>;
> +			regulator-always-on;
> +			regulator-boot-on;
> +		};
> +
> +		vdd_5v0_sys: regulator@1 {
> +			compatible =3D "regulator-fixed";
> +			reg =3D <1>;
> +			regulator-name =3D "+5V_SYS";
> +			regulator-min-microvolt =3D <5000000>;
> +			regulator-max-microvolt =3D <5000000>;
> +			regulator-always-on;
> +			regulator-boot-on;
> +			vin-supply =3D <&vdd_mux>;
> +		};
> +
> +		vdd_3v3_sys: regulator@2 {
> +			compatible =3D "regulator-fixed";
> +			reg =3D <2>;
> +			regulator-name =3D "+3.3V_SYS";
> +			regulator-min-microvolt =3D <3300000>;
> +			regulator-max-microvolt =3D <3300000>;
> +			regulator-always-on;
> +			regulator-boot-on;
> +			vin-supply =3D <&vdd_mux>;
> +		};
> +
> +		vdd_3v3_run: regulator@3 {
> +			compatible =3D "regulator-fixed";
> +			reg =3D <3>;
> +			regulator-name =3D "+3.3V_RUN";
> +			regulator-min-microvolt =3D <3300000>;
> +			regulator-max-microvolt =3D <3300000>;
> +			regulator-always-on;
> +			regulator-boot-on;
> +			gpio =3D <&pmic 1 GPIO_ACTIVE_HIGH>;
> +			enable-active-high;
> +			vin-supply =3D <&vdd_3v3_sys>;
> +		};
> +
> +		vdd_3v3_hdmi: regulator@4 {
> +			compatible =3D "regulator-fixed";
> +			reg =3D <4>;
> +			regulator-name =3D "+3.3V_AVDD_HDMI_AP_GATED";
> +			regulator-min-microvolt =3D <3300000>;
> +			regulator-max-microvolt =3D <3300000>;
> +			vin-supply =3D <&vdd_3v3_run>;
> +		};
> +
> +		vdd_led: regulator@5 {
> +			compatible =3D "regulator-fixed";
> +			reg =3D <5>;
> +			regulator-name =3D "+VDD_LED";
> +			gpio =3D <&gpio TEGRA_GPIO(P, 2) GPIO_ACTIVE_HIGH>;
> +			enable-active-high;
> +			vin-supply =3D <&vdd_mux>;
> +		};
> +
> +		vdd_5v0_ts: regulator@6 {
> +			compatible =3D "regulator-fixed";
> +			reg =3D <6>;
> +			regulator-name =3D "+5V_VDD_TS_SW";
> +			regulator-min-microvolt =3D <5000000>;
> +			regulator-max-microvolt =3D <5000000>;
> +			regulator-boot-on;
> +			gpio =3D <&gpio TEGRA_GPIO(K, 1) GPIO_ACTIVE_HIGH>;
> +			enable-active-high;
> +			vin-supply =3D <&vdd_5v0_sys>;
> +		};
> +
> +		vdd_usb1_vbus: regulator@7 {
> +			compatible =3D "regulator-fixed";
> +			reg =3D <7>;
> +			regulator-name =3D "+5V_USB_HS";
> +			regulator-min-microvolt =3D <5000000>;
> +			regulator-max-microvolt =3D <5000000>;
> +			gpio =3D <&gpio TEGRA_GPIO(N, 4) GPIO_ACTIVE_HIGH>;
> +			enable-active-high;
> +			gpio-open-drain;
> +			vin-supply =3D <&vdd_5v0_sys>;
> +		};
> +
> +		vdd_usb3_vbus: regulator@8 {
> +			compatible =3D "regulator-fixed";
> +			reg =3D <8>;
> +			regulator-name =3D "+5V_USB_SS";
> +			regulator-min-microvolt =3D <5000000>;
> +			regulator-max-microvolt =3D <5000000>;
> +			gpio =3D <&gpio TEGRA_GPIO(N, 5) GPIO_ACTIVE_HIGH>;
> +			enable-active-high;
> +			gpio-open-drain;
> +			vin-supply =3D <&vdd_5v0_sys>;
> +		};
> +
> +		vdd_3v3_panel: regulator@9 {
> +			compatible =3D "regulator-fixed";
> +			reg =3D <9>;
> +			regulator-name =3D "+3.3V_PANEL";
> +			regulator-min-microvolt =3D <3300000>;
> +			regulator-max-microvolt =3D <3300000>;
> +			gpio =3D <&pmic 4 GPIO_ACTIVE_HIGH>;
> +			enable-active-high;
> +			vin-supply =3D <&vdd_3v3_run>;
> +		};
> +
> +		vdd_3v3_lp0: regulator@10 {
> +			compatible =3D "regulator-fixed";
> +			reg =3D <10>;
> +			regulator-name =3D "+3.3V_LP0";
> +			regulator-min-microvolt =3D <3300000>;
> +			regulator-max-microvolt =3D <3300000>;
> +			/*
> +			 * TODO: find a way to wire this up with the USB EHCI
> +			 * controllers so that it can be enabled on demand.
> +			 */
> +			regulator-always-on;
> +			gpio =3D <&pmic 2 GPIO_ACTIVE_HIGH>;
> +			enable-active-high;
> +			vin-supply =3D <&vdd_3v3_sys>;
> +		};
> +
> +		vdd_hdmi_pll: regulator@11 {
> +			compatible =3D "regulator-fixed";
> +			reg =3D <11>;
> +			regulator-name =3D "+1.05V_RUN_AVDD_HDMI_PLL";
> +			regulator-min-microvolt =3D <1050000>;
> +			regulator-max-microvolt =3D <1050000>;
> +			gpio =3D <&gpio TEGRA_GPIO(H, 7) GPIO_ACTIVE_LOW>;
> +			vin-supply =3D <&vdd_1v05_run>;
> +		};
> +
> +		vdd_5v0_hdmi: regulator@12 {
> +			compatible =3D "regulator-fixed";
> +			reg =3D <12>;
> +			regulator-name =3D "+5V_HDMI_CON";
> +			regulator-min-microvolt =3D <5000000>;
> +			regulator-max-microvolt =3D <5000000>;
> +			gpio =3D <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_HIGH>;
> +			enable-active-high;
> +			vin-supply =3D <&vdd_5v0_sys>;
> +		};
> +	};
> +
> +	sound {
> +		compatible =3D "nvidia,tegra-audio-max98090-nyan-big",
> +			     "nvidia,tegra-audio-max98090";
> +
> +		nvidia,audio-routing =3D
> +			"Headphones", "HPR",
> +			"Headphones", "HPL",
> +			"Speakers", "SPKR",
> +			"Speakers", "SPKL",
> +			"Mic Jack", "MICBIAS",
> +			"DMICL", "Int Mic",
> +			"DMICR", "Int Mic",
> +			"IN34", "Mic Jack";
> +
> +		nvidia,i2s-controller =3D <&tegra_i2s1>;
> +		nvidia,audio-codec =3D <&acodec>;
> +
> +		clocks =3D <&tegra_car TEGRA124_CLK_PLL_A>,
> +			 <&tegra_car TEGRA124_CLK_PLL_A_OUT0>,
> +			 <&tegra_car TEGRA124_CLK_EXTERN1>;
> +		clock-names =3D "pll_a", "pll_a_out0", "mclk";
> +
> +		nvidia,hp-det-gpios =3D <&gpio TEGRA_GPIO(I, 7) GPIO_ACTIVE_HIGH>;
> +	};
> +};
> +
> +#include "cros-ec-keyboard.dtsi"
> --=20
> 1.9.3
>=20

--CXFpZVxO6m2Ol4tQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUq93wAAoJEN0jrNd/PrOh7CUP/1EbC0zsE6EDnqWUiqTWB1ez
MkJNJMeTxGi6QDiyXvGRA24WCO24j3WuZoZ4TzOro9SSz0FbKkCOTARZKtg+nyRe
ow8Aa7MTAwTGi3ZxyCaKQMKbvhmx8lceLpwRmxv4ftb5jwQpLF2gvJxKIgtb4hYX
5sCQS1z56bxZMcv//XcV9oiqj11yFdqd5xdcEQAsFNSPtbNkFNFxycAvXntYNPos
KAnBgUyJsaVhVogD/TIhxiG8r2MFhELwcjXHqmr55EM2knu8auvO5jAu1UYH1f5y
Opd5rfwQ/PwjuKktyYdu1I7xHjIkDzzJu5u+RUX2E/jSzvw4MgDGEkwIwuEbuddV
YefPjJagxfEFk8eXWWur9Q8NVeGN6dG9CSPhjm1obU4v+WyNnC/T5NnhTBJykGTs
CQ1XUaTi5HdYDbI5+Mqobgxi324b/wSt/x2i73JkQyzI+gdGE44Zsb8m0R0ohfuc
X4pRtnVlFnSqeJJW4J9dMYh3B7zdcBklY5H2a+jqznCvamlxoZYzYsr2AnvPloSt
60MVmGurmJWPvjUEodBZKx79JcoTzrwQF6kRF2ab4yquWTezsWL1uWPgVzC68GcX
oM0Jk7dymcDOK8x6I1pozwSHA/mtVSvpbfgaqdEfy6BDSRPBMDQWQJ/tnKPF1wPP
h9BTSntfDLniZG3Wh+2Q
=ryyM
-----END PGP SIGNATURE-----

--CXFpZVxO6m2Ol4tQ--
