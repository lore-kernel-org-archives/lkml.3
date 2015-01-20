Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbbATJTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:19:54 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60398 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbbATJTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:19:50 -0500
Message-ID: <1421745586.6818.34.camel@collabora.co.uk>
Subject: Re: [PATCH v2] ARM: dts: exynos5422-odroidxu3: add on-board INA231
 sensors
From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
To: Kevin Hilman <khilman@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linaro-kernel@lists.linaro.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene@kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 20 Jan 2015 10:19:46 +0100
In-Reply-To: <1421284089-421-1-git-send-email-khilman@kernel.org>
References: <1421284089-421-1-git-send-email-khilman@kernel.org>
Organization: Collabora Ltd.
Content-Type: multipart/signed; micalg="sha-1"; protocol="application/x-pkcs7-signature";
	boundary="=-0xSPRf9H6tBAu/pb/5DC"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0xSPRf9H6tBAu/pb/5DC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-01-14 at 17:08 -0800, Kevin Hilman wrote:
> From: Kevin Hilman <khilman@linaro.org>
>=20
> The odroid-xu3 has 4 INA231 current sensors on board which can be
> accessed from the Linux via the hwmon interface.
>=20
> There is one sensor for each of these power rails:
>=20
> - A15 cluster: VDD_ARM
> - A7 cluster: VDD_KFC
> - GPU: VDD_G3D
> - memory: VDD_MEM
>=20
> In addition to adding the sensors, LDO26 from the PMIC needs to be
> enabled because it's powering these sensor.

I haven't tested whether the sensor values are correct, but based on the
schematics & the hardkernel dts this describes the hardware correctly.

Reviewed-By: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

> Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
> v2: use "ti,ina231" as compatible string.
>=20
> Applies on top of "ARM: dts: Add dts file for odroid XU3 board" from Sjoe=
rd Simons.
>=20
>  arch/arm/boot/dts/exynos5422-odroidxu3.dts | 39 ++++++++++++++++++++++++=
++++++
>  1 file changed, 39 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3.dts b/arch/arm/boot/d=
ts/exynos5422-odroidxu3.dts
> index c29123c0734d..50353d023225 100644
> --- a/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> +++ b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> @@ -174,6 +174,13 @@
>  					regulator-always-on;
>  				};
> =20
> +				ldo26_reg: LDO26 {
> +					regulator-name =3D "vdd_ldo26";
> +					regulator-min-microvolt =3D <3000000>;
> +					regulator-max-microvolt =3D <3000000>;
> +					regulator-always-on;
> +				};
> +
>  				buck1_reg: BUCK1 {
>  					regulator-name =3D "vdd_mif";
>  					regulator-min-microvolt =3D <800000>;
> @@ -257,6 +264,38 @@
>  		};
>  	};
> =20
> +	i2c_0: i2c@12C60000 {
> +		status =3D "okay";
> +
> +		/* A15 cluster: VDD_ARM */
> +		ina231@40 {
> +			compatible =3D "ti,ina231";
> +			reg =3D <0x40>;
> +			shunt-resistor =3D <10000>;
> +		};
> +
> +		/* memory: VDD_MEM */
> +		ina231@41 {
> +			compatible =3D "ti,ina231";
> +			reg =3D <0x41>;
> +			shunt-resistor =3D <10000>;
> +		};
> +
> +		/* GPU: VDD_G3D */
> +		ina231@44 {
> +			compatible =3D "ti,ina231";
> +			reg =3D <0x44>;
> +			shunt-resistor =3D <10000>;
> +		};
> +
> +		/* A7 cluster: VDD_KFC */
> +		ina231@45 {
> +			compatible =3D "ti,ina231";
> +			reg =3D <0x45>;
> +			shunt-resistor =3D <10000>;
> +		};
> +	};
> +
>  	i2c_2: i2c@12C80000 {
>  		samsung,i2c-sda-delay =3D <100>;
>  		samsung,i2c-max-bus-freq =3D <66000>;



--=-0xSPRf9H6tBAu/pb/5DC
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIUzDCCBsIw
ggWqoAMCAQICEAoE3yF0XU0rjOozcgUAUOkwDQYJKoZIhvcNAQEFBQAwZTELMAkGA1UEBhMCVVMx
FTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEkMCIGA1UE
AxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4XDTA2MTExMDAwMDAwMFoXDTIxMTExMDAw
MDAwMFowYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3
LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0xMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6IItmfnKwkKVpYBzQHDSnlZUXKnE0kEGj8kz/E1FkVyB
n+0snPgWWd+etSQVwpi5tHdJ3InECtqvy15r7a2wcTHrzzpADEZNk+yLejYIA6sMNP4YSYL+x8cx
SIB8HqIPkg5QycaH6zY/2DDD/6b3+6LNb3Mj/qxWBZDwMiEWicZwiPkFl32jx0PdAug7Pe2xQaPt
P77blUjE7h6z8rwMK5nQxl0SQoHhg26Ccz8mSxSQrllmCsSNvtLOBq6thG9IhJtPQLnxTPKvmPv2
zkBdXPao8S+v7Iki8msYZbHBc63X8djPHgp0XEK4aH631XcKJ1Z8D2KkPzIUYJX9BwSiCQIDAQAB
o4IDbzCCA2swDgYDVR0PAQH/BAQDAgGGMDsGA1UdJQQ0MDIGCCsGAQUFBwMBBggrBgEFBQcDAgYI
KwYBBQUHAwMGCCsGAQUFBwMEBggrBgEFBQcDCDCCAcYGA1UdIASCAb0wggG5MIIBtQYLYIZIAYb9
bAEDAAQwggGkMDoGCCsGAQUFBwIBFi5odHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9zc2wtY3BzLXJl
cG9zaXRvcnkuaHRtMIIBZAYIKwYBBQUHAgIwggFWHoIBUgBBAG4AeQAgAHUAcwBlACAAbwBmACAA
dABoAGkAcwAgAEMAZQByAHQAaQBmAGkAYwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0AGUAcwAg
AGEAYwBjAGUAcAB0AGEAbgBjAGUAIABvAGYAIAB0AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMA
UAAvAEMAUABTACAAYQBuAGQAIAB0AGgAZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkAIABB
AGcAcgBlAGUAbQBlAG4AdAAgAHcAaABpAGMAaAAgAGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkA
dAB5ACAAYQBuAGQAIABhAHIAZQAgAGkAbgBjAG8AcgBwAG8AcgBhAHQAZQBkACAAaABlAHIAZQBp
AG4AIABiAHkAIAByAGUAZgBlAHIAZQBuAGMAZQAuMA8GA1UdEwEB/wQFMAMBAf8wfQYIKwYBBQUH
AQEEcTBvMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wRwYIKwYBBQUHMAKG
O2h0dHA6Ly93d3cuZGlnaWNlcnQuY29tL0NBQ2VydHMvRGlnaUNlcnRBc3N1cmVkSURSb290Q0Eu
Y3J0MIGBBgNVHR8EejB4MDqgOKA2hjRodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRB
c3N1cmVkSURSb290Q0EuY3JsMDqgOKA2hjRodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNl
cnRBc3N1cmVkSURSb290Q0EuY3JsMB0GA1UdDgQWBBQVABIrE5iymQftHt+ivlcNK2cCzTAfBgNV
HSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzANBgkqhkiG9w0BAQUFAAOCAQEAhGFOQR64dgQq
tbbvj/JVhbldVv4KmObkvWWKfUAp0/yxXUX9OrgqWzNLJFzNubTkc61hXXatdDOKZtUjr0wfcm5F
2XVAu6I7z41JL8BBsOIpo1E4Q1CZFKwzBjViiX13qVIH5WwgV7aBum+8s8KU7XYCgNl8zoWoHOzH
Q0pLsVfPcs7f9SU8yyJP/Z9S0TfLCLs4PuDVPm95Ca1bfDGzdzXD5GP5aAqYB+dGOHeE0j6XvAqg
qKwlT0RukeHSWq9r7zAcjaNEQrMQiyP61+Y1dDesz+urWB/JiCP/NtQH6jRqR+qdlWyeKU9T7eMr
lSBOKs+WYHr4LIDwlVLOKZaBYjCCBv8wggXnoAMCAQICEA2fwUKNhvkL8dN88tUFvVwwDQYJKoZI
hvcNAQEFBQAwYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQ
d3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0xMB4XDTE0
MDIxNzAwMDAwMFoXDTE1MDMxMjEyMDAwMFowgaQxCzAJBgNVBAYTAkdCMRcwFQYDVQQIEw5DYW1i
cmlkZ2VzaGlyZTESMBAGA1UEBxMJQ2FtYnJpZGdlMRYwFAYDVQQKEw1Db2xsYWJvcmEgTHRkMQow
CAYDVQQLEwExMRYwFAYDVQQDEw1Tam9lcmQgU2ltb25zMSwwKgYJKoZIhvcNAQkBFh1zam9lcmQu
c2ltb25zQGNvbGxhYm9yYS5jby51azCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN4Q
EHeW1NbogMVZpHedG7o509/L4VBhqQd8j8JViWd+yvLlxOBw/gY+7ioHMatrQY2VvY6QOLle2Xqs
CDvELcXMxwyFpBC0Ia+CVE+5pF+0IMuVkGIL1T8LHeKZYeRP+uFXtmWzas12hsMILNRmK7Q5PACm
+v/6HFn111hLKkANBtRHIRiDbFQOiluNeR2bq+ck1y2+X//SGumA1XZFdCB/1VcRJXDdFnYdU3j/
RkoiGggo3MSq3mJ6yV7sqzk04fTLFvfL0KadCMauputeGBybEiFAt6rCm5TkyUqoDOTU07byOEXO
M32EGeYeV515RzARTpOSE9sdmRq0jNNAqGsCAwEAAaOCA2wwggNoMB8GA1UdIwQYMBaAFBUAEisT
mLKZB+0e36K+Vw0rZwLNMB0GA1UdDgQWBBRaTG8RXMDSFO5XcrjqYs/YDlmqSDAoBgNVHREEITAf
gR1zam9lcmQuc2ltb25zQGNvbGxhYm9yYS5jby51azAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMH0GA1UdHwR2MHQwOKA2oDSGMmh0dHA6Ly9jcmwzLmRpZ2lj
ZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRENBLTEuY3JsMDigNqA0hjJodHRwOi8vY3JsNC5kaWdp
Y2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURDQS0xLmNybDCCAcUGA1UdIASCAbwwggG4MIIBtAYK
YIZIAYb9bAQBAjCCAaQwOgYIKwYBBQUHAgEWLmh0dHA6Ly93d3cuZGlnaWNlcnQuY29tL3NzbC1j
cHMtcmVwb3NpdG9yeS5odG0wggFkBggrBgEFBQcCAjCCAVYeggFSAEEAbgB5ACAAdQBzAGUAIABv
AGYAIAB0AGgAaQBzACAAQwBlAHIAdABpAGYAaQBjAGEAdABlACAAYwBvAG4AcwB0AGkAdAB1AHQA
ZQBzACAAYQBjAGMAZQBwAHQAYQBuAGMAZQAgAG8AZgAgAHQAaABlACAARABpAGcAaQBDAGUAcgB0
ACAAQwBQAC8AQwBQAFMAIABhAG4AZAAgAHQAaABlACAAUgBlAGwAeQBpAG4AZwAgAFAAYQByAHQA
eQAgAEEAZwByAGUAZQBtAGUAbgB0ACAAdwBoAGkAYwBoACAAbABpAG0AaQB0ACAAbABpAGEAYgBp
AGwAaQB0AHkAIABhAG4AZAAgAGEAcgBlACAAaQBuAGMAbwByAHAAbwByAGEAdABlAGQAIABoAGUA
cgBlAGkAbgAgAGIAeQAgAHIAZQBmAGUAcgBlAG4AYwBlAC4wdwYIKwYBBQUHAQEEazBpMCQGCCsG
AQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQQYIKwYBBQUHMAKGNWh0dHA6Ly9jYWNl
cnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRENBLTEuY3J0MAwGA1UdEwEB/wQCMAAw
DQYJKoZIhvcNAQEFBQADggEBAAc8CwXSms3RbIx+bhxFsGQoN+RpHtjnPvMPPAobv7rxdhQPPz+N
6h3hpVzegeW2XhyZVC8MT0U6uWXrk+1uQUAXrJEG+W2X8yTEoHDS/SCF/POOsj/ekaDuNE9JJB/9
cspoa4W+W8pX1sRurBDFHL0DBudUQ1PgvTSLPOHtfKQpu4gRb2u8KpJermp/IvPLImX9xSCbYKQM
2L0wbpStFIYdyKCKuXuQxOX3BdBKLCFvcIDE6hjj3UpOlThCbeul2Tz5jARCfRK4OUxnXyb/Tp5j
tshIAa2ZMGaTH9ApeY7P6C2ONF+Mh5yV/raWXOnJ9dEg6/sXcbdiieqzLKYBIgQwggb/MIIF56AD
AgECAhANn8FCjYb5C/HTfPLVBb1cMA0GCSqGSIb3DQEBBQUAMGIxCzAJBgNVBAYTAlVTMRUwEwYD
VQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERp
Z2lDZXJ0IEFzc3VyZWQgSUQgQ0EtMTAeFw0xNDAyMTcwMDAwMDBaFw0xNTAzMTIxMjAwMDBaMIGk
MQswCQYDVQQGEwJHQjEXMBUGA1UECBMOQ2FtYnJpZGdlc2hpcmUxEjAQBgNVBAcTCUNhbWJyaWRn
ZTEWMBQGA1UEChMNQ29sbGFib3JhIEx0ZDEKMAgGA1UECxMBMTEWMBQGA1UEAxMNU2pvZXJkIFNp
bW9uczEsMCoGCSqGSIb3DQEJARYdc2pvZXJkLnNpbW9uc0Bjb2xsYWJvcmEuY28udWswggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDeEBB3ltTW6IDFWaR3nRu6OdPfy+FQYakHfI/CVYln
fsry5cTgcP4GPu4qBzGra0GNlb2OkDi5Xtl6rAg7xC3FzMcMhaQQtCGvglRPuaRftCDLlZBiC9U/
Cx3imWHkT/rhV7Zls2rNdobDCCzUZiu0OTwApvr/+hxZ9ddYSypADQbURyEYg2xUDopbjXkdm6vn
JNctvl//0hrpgNV2RXQgf9VXESVw3RZ2HVN4/0ZKIhoIKNzEqt5iesle7Ks5NOH0yxb3y9CmnQjG
rqbrXhgcmxIhQLeqwpuU5MlKqAzk1NO28jhFzjN9hBnmHledeUcwEU6TkhPbHZkatIzTQKhrAgMB
AAGjggNsMIIDaDAfBgNVHSMEGDAWgBQVABIrE5iymQftHt+ivlcNK2cCzTAdBgNVHQ4EFgQUWkxv
EVzA0hTuV3K46mLP2A5ZqkgwKAYDVR0RBCEwH4Edc2pvZXJkLnNpbW9uc0Bjb2xsYWJvcmEuY28u
dWswDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMEBggrBgEFBQcDAjB9BgNVHR8E
djB0MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURDQS0x
LmNybDA4oDagNIYyaHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEQ0Et
MS5jcmwwggHFBgNVHSAEggG8MIIBuDCCAbQGCmCGSAGG/WwEAQIwggGkMDoGCCsGAQUFBwIBFi5o
dHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9zc2wtY3BzLXJlcG9zaXRvcnkuaHRtMIIBZAYIKwYBBQUH
AgIwggFWHoIBUgBBAG4AeQAgAHUAcwBlACAAbwBmACAAdABoAGkAcwAgAEMAZQByAHQAaQBmAGkA
YwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0AGUAcwAgAGEAYwBjAGUAcAB0AGEAbgBjAGUAIABv
AGYAIAB0AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMAUAAvAEMAUABTACAAYQBuAGQAIAB0AGgA
ZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkAIABBAGcAcgBlAGUAbQBlAG4AdAAgAHcAaABp
AGMAaAAgAGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkAdAB5ACAAYQBuAGQAIABhAHIAZQAgAGkA
bgBjAG8AcgBwAG8AcgBhAHQAZQBkACAAaABlAHIAZQBpAG4AIABiAHkAIAByAGUAZgBlAHIAZQBu
AGMAZQAuMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQu
Y29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
cmVkSURDQS0xLmNydDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4IBAQAHPAsF0prN0WyM
fm4cRbBkKDfkaR7Y5z7zDzwKG7+68XYUDz8/jeod4aVc3oHltl4cmVQvDE9FOrll65PtbkFAF6yR
Bvltl/MkxKBw0v0ghfzzjrI/3pGg7jRPSSQf/XLKaGuFvlvKV9bEbqwQxRy9AwbnVENT4L00izzh
7XykKbuIEW9rvCqSXq5qfyLzyyJl/cUgm2CkDNi9MG6UrRSGHcigirl7kMTl9wXQSiwhb3CAxOoY
491KTpU4Qm3rpdk8+YwEQn0SuDlMZ18m/06eY7bISAGtmTBmkx/QKXmOz+gtjjRfjIeclf62llzp
yfXRIOv7F3G3YonqsyymASIEMYIDEDCCAwwCAQEwdjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMM
RGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2Vy
dCBBc3N1cmVkIElEIENBLTECEA2fwUKNhvkL8dN88tUFvVwwCQYFKw4DAhoFAKCCAW8wGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwMTIwMDkxOTQ2WjAjBgkqhkiG
9w0BCQQxFgQUp831Lpn1lOUByQktJ+e8IVpYq1kwgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UE
BhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEh
MB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0xAhANn8FCjYb5C/HTfPLVBb1cMIGHBgsq
hkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcG
A1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBDQS0x
AhANn8FCjYb5C/HTfPLVBb1cMA0GCSqGSIb3DQEBAQUABIIBAK2LrJwweQfKtQVY4nW9ZmhAQNYv
1RyrKjMATz2DocMmdCHCFxpX/FBQJeIfvgE8q1aSB8bdA5qGME9z5DzpuqrPhtW2kB2/qlmKxCzL
X2Svk5WVAyDcpHxU8cku+J81TytZuE5QW7ZDOiMhzfLB53hKoRoY0yiq/+OwWT4RWjyOD5ADAg16
j7YNHs7yCi/ucLSSQk0Rglm+j0O0+FhOgANZZxvo8asdbC7Vcpf4Cr41W8+8RdWI6L4Qykkq0da8
1QOHF5df8JFzF8HLC9/UbCTjU0FQsQDig6JGiCF8hYmHgi86AQ364jDP2fi9rUSv/+AjjIufAeWT
F4AjDAhAg0sAAAAAAAA=


--=-0xSPRf9H6tBAu/pb/5DC--
