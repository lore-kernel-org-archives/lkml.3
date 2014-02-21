Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbaBUA7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:59:10 -0500
Received: from ozlabs.org ([203.10.76.45]:42694 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbaBUA7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 19:59:04 -0500
Date: Fri, 21 Feb 2014 11:58:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Subject: linux-next: manual merge of the arm-soc tree with the arm-perf tree
Message-Id: <20140221115857.3ea3d7277d03c5b6b4d26488@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Feb_2014_11_58_57_+1100_7Nk3/p1gg16h_nhG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Feb_2014_11_58_57_+1100_7Nk3/p1gg16h_nhG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/qcom-msm8960-cdp.dts between commit a1d711938959 ("ARM:
dts: msm: Add krait-pmu to platforms with Krait CPUs") from the arm-perf
tree and commit cc60a1a4d47a ("ARM: dts: msm: split out msm8660 and
msm8960 soc into dts include") from the arm-soc tree.

I fixed it up (probably not the best way ... see below) and can carry the
fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/qcom-msm8960-cdp.dts
index 66c59a6a722c,a58fb88315f6..000000000000
--- a/arch/arm/boot/dts/qcom-msm8960-cdp.dts
+++ b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
@@@ -7,70 -3,4 +3,10 @@@
  / {
  	model =3D "Qualcomm MSM8960 CDP";
  	compatible =3D "qcom,msm8960-cdp", "qcom,msm8960";
- 	interrupt-parent =3D <&intc>;
 +
 +	cpu-pmu {
 +		compatible =3D "qcom,krait-pmu";
 +		interrupts =3D <1 10 0x304>;
 +		qcom,no-pc-write;
 +	};
-=20
- 	intc: interrupt-controller@2000000 {
- 		compatible =3D "qcom,msm-qgic2";
- 		interrupt-controller;
- 		#interrupt-cells =3D <3>;
- 		reg =3D < 0x02000000 0x1000 >,
- 		      < 0x02002000 0x1000 >;
- 	};
-=20
- 	timer@200a000 {
- 		compatible =3D "qcom,kpss-timer", "qcom,msm-timer";
- 		interrupts =3D <1 1 0x301>,
- 			     <1 2 0x301>,
- 			     <1 3 0x301>;
- 		reg =3D <0x0200a000 0x100>;
- 		clock-frequency =3D <27000000>,
- 				  <32768>;
- 		cpu-offset =3D <0x80000>;
- 	};
-=20
- 	msmgpio: gpio@800000 {
- 		compatible =3D "qcom,msm-gpio";
- 		gpio-controller;
- 		#gpio-cells =3D <2>;
- 		ngpio =3D <150>;
- 		interrupts =3D <0 16 0x4>;
- 		interrupt-controller;
- 		#interrupt-cells =3D <2>;
- 		reg =3D <0x800000 0x4000>;
- 	};
-=20
- 	gcc: clock-controller@900000 {
- 		compatible =3D "qcom,gcc-msm8960";
- 		#clock-cells =3D <1>;
- 		#reset-cells =3D <1>;
- 		reg =3D <0x900000 0x4000>;
- 	};
-=20
- 	clock-controller@4000000 {
- 		compatible =3D "qcom,mmcc-msm8960";
- 		reg =3D <0x4000000 0x1000>;
- 		#clock-cells =3D <1>;
- 		#reset-cells =3D <1>;
- 	};
-=20
- 	serial@16440000 {
- 		compatible =3D "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
- 		reg =3D <0x16440000 0x1000>,
- 		      <0x16400000 0x1000>;
- 		interrupts =3D <0 154 0x0>;
- 		clocks =3D <&gcc GSBI5_UART_CLK>, <&gcc GSBI5_H_CLK>;
- 		clock-names =3D "core", "iface";
- 	};
-=20
- 	qcom,ssbi@500000 {
- 		compatible =3D "qcom,ssbi";
- 		reg =3D <0x500000 0x1000>;
- 		qcom,controller-type =3D "pmic-arbiter";
- 	};
  };

--Signature=_Fri__21_Feb_2014_11_58_57_+1100_7Nk3/p1gg16h_nhG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTBqTVAAoJEMDTa8Ir7ZwVah4P/jWmnF5oh+jXTMgA8oX3kkFI
qfZNXHMDfn+XClTwZu0jP8qam3tOEINn48m7aA5uJPFEyoIXgmUOHMR1ez7eD0pa
8ZzM4yJTw+0BgwOfBHr/gNUqkSOqoVJt1iaUrHDXsPZ3Yt5HuyuMsFwTaI5JrZl3
6n5ZlhbTDA0PJGELXOi6G0BXlTV+vq0phGH2yNwofmO25BuJQAWfynsL1s3WJuhG
2qvyDbTu8+wYoglZTra4tZj3yTtdCtNiRZX+/Mdj28atU/Js7/t9SrinZdhzL2ti
HKX5FpBm/VFIEhWPDuL9F0CjPj17RB0Qrv5mCGnmCx2i9M2VYTVHo71OVPM/etXV
az1Kkph8CUKpQi+jW1hsplRl30vAYnDIEJjPQjNXpf7D7isIVjs0OfVBa/SJycOW
NtHLC7Ds/qbUrhFECvEexmsOXqd9S4snHefF1DonXeRaFL4zxMIAgeDsa9rGC665
Sq9B78bKPKgwU5S8HMT6NVUHHkMAkDFp0ZBGB1A5T7rYAaQn4LnJ2Jr1m5IkEnFw
dTkfUBQVuZj78JWuDl5GfLV3enpwn2ZH6gmYeAvzd/Odff0agzcYOtnQ1K6Z9wMh
RRY58Rb17ZsD8JnorhxUygnzHVieJK2xFIMuWgBHcuIG5hOzepzJ3MNG24MYZf+k
yJPk2zxUtN46M96v0Dkz
=irkH
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Feb_2014_11_58_57_+1100_7Nk3/p1gg16h_nhG--
