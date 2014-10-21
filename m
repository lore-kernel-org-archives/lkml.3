Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbaJUJXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:23:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40819 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbaJUJXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:23:48 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-9a-544626224fd1
Message-id: <1413883424.26980.7.camel@AMDC1943>
Subject: Re: [PATCH 2/2] ARM: dts: exynos4412-trats: Add suspend configuration
 for max77686 regulators
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Date: Tue, 21 Oct 2014 11:23:44 +0200
In-reply-to: <54461FC0.9020904@samsung.com>
References: <1413879912-26606-1-git-send-email-k.kozlowski@samsung.com>
 <1413879912-26606-3-git-send-email-k.kozlowski@samsung.com>
 <54461FC0.9020904@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xq7pKam4hBhNWsFlsnLGe1WLSugNM
	FlMfPmGzuP7lOavF0d8FFr0LrrJZnG16w27x7UoHk8Wmx9dYLS7vmsNmMeP8PiaL25d5LdYe
	uctusWrXH0YHPo+W5h42j7/Pr7N4/F31gtlj56y77B6bVnWyeWxeUu/Rt2UVo8fnTXIBHFFc
	NimpOZllqUX6dglcGSufrGMsaCuqmP1sIVMD4yf/LkZODgkBE4l9G/ewQ9hiEhfurWfrYuTi
	EBJYyijx/kEDK0hCSOAzo8SbvRIgNq+AvsS7tn6gBg4OYYEMib7XWiBhNgFjic3Ll7CB2CIC
	GhIz/15hBJnDLDCLReLSjueMIPUsAqoSs9bagtRwCmhLNMxcDLVrGaPEra8TWUASzALqEpPm
	LWIGqZcQUJZo7HeDWCso8WPyPagSeYnNa94yT2AUmIWkYxaSsllIyhYwMq9iFE0tTS4oTkrP
	NdQrTswtLs1L10vOz93ECImgLzsYFx+zOsQowMGoxMO7YZlriBBrYllxZe4hRgkOZiUR3lxh
	txAh3pTEyqrUovz4otKc1OJDjEwcnFINjCkll9Ter2Ov7XjmnRARI3ZL2tWA7VJaV2a46qc6
	Rda0trLLZlv+1q8Ift1i90H2mMiLn29ifydsMRbR7yyZOEX80sXHHl2nnhbd+n1gxwTlhbdc
	MlumH7WpY7ey8T13k4U30OpK0nMXTRv/8H5hgaW3J2d559/aVVAZlStuY6sTybx6WWCvEktx
	RqKhFnNRcSIAhfdArn4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-10-21 at 17:56 +0900, Chanwoo Choi wrote:
> Hi Krzysztof,
> 
> I think that the state of some regulators should be changed in suspend state.
> 
> On 10/21/2014 05:25 PM, Krzysztof Kozlowski wrote:
> > Add suspend to RAM configuration for max77686 regulators. Some LDOs and
> > bucks are disabled. This reduces energy consumption during S2R,
> > approximately from 17 mA to 9 mA.
> > 
> > Additionally remove old and not supported bindings:
> >  - regulator-mem-off
> >  - regulator-mem-idle
> >  - regulator-mem-on
> > The max77686 driver does not parse them and they are not documented
> > anywere.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  arch/arm/boot/dts/exynos4412-trats2.dts | 135 +++++++++++++++++++++++++-------
> >  1 file changed, 105 insertions(+), 30 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
> > index dd9ac66770f7..c2fbee36021a 100644
> > --- a/arch/arm/boot/dts/exynos4412-trats2.dts
> > +++ b/arch/arm/boot/dts/exynos4412-trats2.dts
> > @@ -225,7 +225,9 @@
> >  					regulator-min-microvolt = <1000000>;
> >  					regulator-max-microvolt = <1000000>;
> >  					regulator-always-on;
> > -					regulator-mem-on;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo2_reg: ldo2 {
> > @@ -234,7 +236,9 @@
> >  					regulator-min-microvolt = <1200000>;
> >  					regulator-max-microvolt = <1200000>;
> >  					regulator-always-on;
> > -					regulator-mem-on;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo3_reg: ldo3 {
> > @@ -243,7 +247,9 @@
> >  					regulator-min-microvolt = <1800000>;
> >  					regulator-max-microvolt = <1800000>;
> >  					regulator-always-on;
> > -					regulator-mem-on;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo4_reg: ldo4 {
> > @@ -252,7 +258,9 @@
> >  					regulator-min-microvolt = <2800000>;
> >  					regulator-max-microvolt = <2800000>;
> >  					regulator-always-on;
> > -					regulator-mem-on;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo5_reg: ldo5 {
> > @@ -261,7 +269,9 @@
> >  					regulator-min-microvolt = <1800000>;
> >  					regulator-max-microvolt = <1800000>;
> >  					regulator-always-on;
> > -					regulator-mem-on;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo6_reg: ldo6 {
> > @@ -270,7 +280,9 @@
> >  					regulator-min-microvolt = <1000000>;
> >  					regulator-max-microvolt = <1000000>;
> >  					regulator-always-on;
> > -					regulator-mem-on;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo7_reg: ldo7 {
> > @@ -279,7 +291,9 @@
> >  					regulator-min-microvolt = <1000000>;
> >  					regulator-max-microvolt = <1000000>;
> >  					regulator-always-on;
> > -					regulator-mem-on;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo8_reg: ldo8 {
> > @@ -287,7 +301,9 @@
> >  					regulator-name = "VMIPI_1.0V";
> >  					regulator-min-microvolt = <1000000>;
> >  					regulator-max-microvolt = <1000000>;
> > -					regulator-mem-off;
> > +					regulator-state-mem {
> > +						regulator-off-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo9_reg: ldo9 {
> > @@ -295,7 +311,9 @@
> >  					regulator-name = "CAM_ISP_MIPI_1.2V";
> >  					regulator-min-microvolt = <1200000>;
> >  					regulator-max-microvolt = <1200000>;
> > -					regulator-mem-idle;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> 
> CAM_ISP_MIPI_1.2V is used for camera, I think this regulator should turn off in suspend state
> because camear could not be used in suspend state.

LDO9 does not support off in suspend mode controlled by PWRREQ. It
supports only switching to low power mode if PWRREQ level goes low.

Thus the driver does not provide set_suspend_enable or
set_suspend_disable for LDO0. Do you want to add such function to the
max77686 driver which will explicitly disable the regulator (write 0x0
to control reg)?


> > +					};
> >  				};
> >  
> >  				ldo10_reg: ldo10 {
> > @@ -303,7 +321,9 @@
> >  					regulator-name = "VMIPI_1.8V";
> >  					regulator-min-microvolt = <1800000>;
> >  					regulator-max-microvolt = <1800000>;
> > -					regulator-mem-off;
> > +					regulator-state-mem {
> > +						regulator-off-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo11_reg: ldo11 {
> > @@ -312,7 +332,9 @@
> >  					regulator-min-microvolt = <1950000>;
> >  					regulator-max-microvolt = <1950000>;
> >  					regulator-always-on;
> > -					regulator-mem-off;
> > +					regulator-state-mem {
> > +						regulator-off-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo12_reg: ldo12 {
> > @@ -320,7 +342,9 @@
> >  					regulator-name = "VUOTG_3.0V";
> >  					regulator-min-microvolt = <3000000>;
> >  					regulator-max-microvolt = <3000000>;
> > -					regulator-mem-off;
> > +					regulator-state-mem {
> > +						regulator-off-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo13_reg: ldo13 {
> > @@ -328,7 +352,9 @@
> >  					regulator-name = "NFC_AVDD_1.8V";
> >  					regulator-min-microvolt = <1800000>;
> >  					regulator-max-microvolt = <1800000>;
> > -					regulator-mem-idle;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> 
> NFC_AVDD_1.8V is used for NFC feature, If user of smartphone want to use NFC feature
> and then enable NFC on the setting menu, NFC_AVDD_1.8V should turn on in suspend state.
> 
> But, If NFC is not used, NFC_AVDD_1.8V should turn off in suspend state.
> So, I think this regulator should be controlled by NFC device driver without 'regulator-state-mem' property.

Currently there is no API for regulator consumers for managing the
suspend state. Consumer cannot change suspend mode or suspend state for
regulator.

> 
> > +					};
> >  				};
> >  
> >  				ldo14_reg: ldo14 {
> > @@ -337,7 +363,9 @@
> >  					regulator-min-microvolt = <1950000>;
> >  					regulator-max-microvolt = <1950000>;
> >  					regulator-always-on;
> > -					regulator-mem-off;
> > +					regulator-state-mem {
> > +						regulator-off-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo15_reg: ldo15 {
> > @@ -345,7 +373,9 @@
> >  					regulator-name = "VHSIC_1.0V";
> >  					regulator-min-microvolt = <1000000>;
> >  					regulator-max-microvolt = <1000000>;
> > -					regulator-mem-off;
> > +					regulator-state-mem {
> > +						regulator-off-in-suspend;
> 
> VHSIC_1.8V was used for CP (Modem), CP (Modem) have to maintain the power in suspend state.
> - off -> on

OK.

> 
> > +					};
> >  				};
> >  
> >  				ldo16_reg: ldo16 {
> > @@ -353,7 +383,9 @@
> >  					regulator-name = "VHSIC_1.8V";
> >  					regulator-min-microvolt = <1800000>;
> >  					regulator-max-microvolt = <1800000>;
> > -					regulator-mem-off;
> > +					regulator-state-mem {
> > +						regulator-off-in-suspend;
> 
> ditto (off -> on) for CP (MODEM)

OK.

> 
> > +					};
> >  				};
> >  
> >  				ldo17_reg: ldo17 {
> > @@ -361,7 +393,9 @@
> >  					regulator-name = "CAM_SENSOR_CORE_1.2V";
> >  					regulator-min-microvolt = <1200000>;
> >  					regulator-max-microvolt = <1200000>;
> > -					regulator-mem-idle;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> 
> ditto. (on -> off) because camera is not used in supend state.

LDO17 does not support off mode controlled by PWRREQ. Same as for LDO9.
> 
> > +					};
> >  				};
> >  
> >  				ldo18_reg: ldo18 {
> > @@ -369,7 +403,9 @@
> >  					regulator-name = "CAM_ISP_SEN_IO_1.8V";
> >  					regulator-min-microvolt = <1800000>;
> >  					regulator-max-microvolt = <1800000>;
> > -					regulator-mem-idle;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> 
> ditto. (on -> off) because camera is not used in supend state.

LDO18 does not support off mode controlled by PWRREQ. Same as for LDO9.

> 
> > +					};
> >  				};
> >  
> >  				ldo19_reg: ldo19 {
> > @@ -377,7 +413,9 @@
> >  					regulator-name = "VT_CAM_1.8V";
> >  					regulator-min-microvolt = <1800000>;
> >  					regulator-max-microvolt = <1800000>;
> > -					regulator-mem-idle;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> 
> ditto. (on -> off) because camera is not used in supend state.

LDO19 does not support off mode controlled by PWRREQ. Same as for LDO9.

> 
> > +					};
> >  				};
> >  
> >  				ldo20_reg: ldo20 {
> > @@ -385,7 +423,9 @@
> >  					regulator-name = "VDDQ_PRE_1.8V";
> >  					regulator-min-microvolt = <1800000>;
> >  					regulator-max-microvolt = <1800000>;
> > -					regulator-mem-idle;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo21_reg: ldo21 {
> > @@ -393,7 +433,9 @@
> >  					regulator-name = "VTF_2.8V";
> >  					regulator-min-microvolt = <2800000>;
> >  					regulator-max-microvolt = <2800000>;
> > -					regulator-mem-idle;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo22_reg: ldo22 {
> > @@ -401,6 +443,9 @@
> >  					regulator-name = "VMEM_VDD_2.8V";
> >  					regulator-min-microvolt = <2800000>;
> >  					regulator-max-microvolt = <2800000>;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				ldo23_reg: ldo23 {
> > @@ -408,7 +453,9 @@
> >  					regulator-name = "TSP_AVDD_3.3V";
> >  					regulator-min-microvolt = <3300000>;
> >  					regulator-max-microvolt = <3300000>;
> > -					regulator-mem-idle;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> 
> ditto. (on -> off) because touchscreen is not used in suspend state.
LDO23 does not support off mode controlled by PWRREQ. Same as for LDO9.

> 
> > +					};
> >  				};
> >  
> >  				ldo24_reg: ldo24 {
> > @@ -416,7 +463,9 @@
> >  					regulator-name = "TSP_VDD_1.8V";
> >  					regulator-min-microvolt = <1800000>;
> >  					regulator-max-microvolt = <1800000>;
> > -					regulator-mem-idle;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> 
> ditto. (on -> off)
LDO24 does not support off mode controlled by PWRREQ. Same as for LDO9.

> 
> > +					};
> >  				};
> >  
> >  				ldo25_reg: ldo25 {
> > @@ -424,7 +473,9 @@
> >  					regulator-name = "LCD_VCC_3.3V";
> >  					regulator-min-microvolt = <2800000>;
> >  					regulator-max-microvolt = <2800000>;
> > -					regulator-mem-idle;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> 
> LDC_VCC_3.3V may not be used in susepnd state. I think this regulator should turn off in suspend state.

LDO25 does not support off mode controlled by PWRREQ. Same as for LDO9.

> 
> >  				};
> >  
> >  				ldo26_reg: ldo26 {
> > @@ -432,7 +483,9 @@
> >  					regulator-name = "MOTOR_VCC_3.0V";
> >  					regulator-min-microvolt = <3000000>;
> >  					regulator-max-microvolt = <3000000>;
> > -					regulator-mem-idle;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> 
> If MOTOR_VCC_3.0V is used for haptic, I think this regulator should turn off in suspend state.

LDO26 does not support off mode controlled by PWRREQ. Same as for LDO9.

Thanks for feedback!
Best regards,
Krzysztof

> 
> >  				};
> >  
> >  				buck1_reg: buck1 {
> > @@ -442,7 +495,9 @@
> >  					regulator-max-microvolt = <1100000>;
> >  					regulator-always-on;
> >  					regulator-boot-on;
> > -					regulator-mem-off;
> > +					regulator-state-mem {
> > +						regulator-off-in-suspend;
> > +					};
> >  				};
> >  
> >  				buck2_reg: buck2 {
> > @@ -452,7 +507,9 @@
> >  					regulator-max-microvolt = <1500000>;
> >  					regulator-always-on;
> >  					regulator-boot-on;
> > -					regulator-mem-off;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				buck3_reg: buck3 {
> > @@ -462,7 +519,9 @@
> >  					regulator-max-microvolt = <1150000>;
> >  					regulator-always-on;
> >  					regulator-boot-on;
> > -					regulator-mem-off;
> > +					regulator-state-mem {
> > +						regulator-off-in-suspend;
> > +					};
> >  				};
> >  
> >  				buck4_reg: buck4 {
> > @@ -471,7 +530,9 @@
> >  					regulator-min-microvolt = <850000>;
> >  					regulator-max-microvolt = <1150000>;
> >  					regulator-boot-on;
> > -					regulator-mem-off;
> > +					regulator-state-mem {
> > +						regulator-off-in-suspend;
> > +					};
> >  				};
> >  
> >  				buck5_reg: buck5 {
> > @@ -480,6 +541,9 @@
> >  					regulator-min-microvolt = <1200000>;
> >  					regulator-max-microvolt = <1200000>;
> >  					regulator-always-on;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				buck6_reg: buck6 {
> > @@ -488,6 +552,9 @@
> >  					regulator-min-microvolt = <1350000>;
> >  					regulator-max-microvolt = <1350000>;
> >  					regulator-always-on;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				buck7_reg: buck7 {
> > @@ -496,6 +563,9 @@
> >  					regulator-min-microvolt = <2000000>;
> >  					regulator-max-microvolt = <2000000>;
> >  					regulator-always-on;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				buck8_reg: buck8 {
> > @@ -503,6 +573,9 @@
> >  					regulator-name = "VMEM_VDDF_3.0V";
> >  					regulator-min-microvolt = <2850000>;
> >  					regulator-max-microvolt = <2850000>;
> > +					regulator-state-mem {
> > +						regulator-on-in-suspend;
> > +					};
> >  				};
> >  
> >  				buck9_reg: buck9 {
> > @@ -510,7 +583,9 @@
> >  					regulator-name = "CAM_ISP_CORE_1.2V";
> >  					regulator-min-microvolt = <1000000>;
> >  					regulator-max-microvolt = <1200000>;
> > -					regulator-mem-off;
> > +					regulator-state-mem {
> > +						regulator-off-in-suspend;
> > +					};
> >  				};
> >  			};
> >  		};
> > 
> 
> Thanks,
> Chanwoo Choi

