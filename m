Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbaIKOaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:30:20 -0400
Received: from gloria.sntech.de ([95.129.55.99]:41445 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430AbaIKOaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:30:16 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: rui.zhang@intel.com, edubezval@gmail.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        huangtao@rock-chips.com, cf@rock-chips.com, dianders@chromium.org,
        dtor@chromium.org, zyw@rock-chips.com, addy.ke@rock-chips.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH v4 3/4] ARM: dts: add main Thermal info to rk3288
Date: Thu, 11 Sep 2014 15:58:04 +0200
Message-ID: <6563337.jht9ZmlHCg@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <540FBC21.2090504@rock-chips.com>
References: <1409710239-19941-1-git-send-email-caesar.wang@rock-chips.com> <3426113.Zcq8V2S7cg@diego> <540FBC21.2090504@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

Am Mittwoch, 10. September 2014, 10:49:05 schrieb Caesar Wang:
> Hi Heiko,
> 
> 在 2014年09月09日 19:37, Heiko Stübner 写道:
> > Am Mittwoch, 3. September 2014, 10:10:38 schrieb Caesar Wang:
> >> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> >> ---
> >> 
> >>   arch/arm/boot/dts/rk3288.dtsi | 18 ++++++++++++++++++
> >>   1 file changed, 18 insertions(+)
> >> 
> >> diff --git a/arch/arm/boot/dts/rk3288.dtsi
> >> b/arch/arm/boot/dts/rk3288.dtsi
> >> index 36be7bb..3d672e3 100644
> >> --- a/arch/arm/boot/dts/rk3288.dtsi
> >> +++ b/arch/arm/boot/dts/rk3288.dtsi

[...]

> >> @@ -611,5 +622,12 @@
> >> 
> >>   				rockchip,pins = <5 15 3 &pcfg_pull_none>;
> >>   			
> >>   			};
> >>   		
> >>   		};
> >> 
> >> +
> >> +		tsadc {
> >> +			tsadc_int: tsadc-int {
> >> +				rockchip,pins = <0 10 RK_FUNC_1 &pcfg_pull_up>;
> >> +			};
> >> +		};
> > 
> > After looking this up in the schematics I see that this is the
> > overtemperature-protection output pin ... labeled OTP_OUT.
> > So I'd think the pinconfig should reflect this pin-name, especially as
> > tsadc-int suggests, that this would be an interrupt leading into the
> > tsadc, while in fact it is an output to a separate circuit.
> 
> Maybe,I guess  your mean as the follows .
> Please correct it and  Laugh out if I got it wrong.

I'll never laugh ... just try get the best solution / trying to understand 
backgrounds.

> 
> tsadc {
>              otp_out: otp-out {
>                  rockchip,pins = <0 10 RK_FUNC_GPIO &pcfg_pull_none>;
>              };
> 
>              tsadc_int: tsadc-int {
>                  rockchip,pins = <0 10 RK_FUNC_1 &pcfg_pull_none>;
>              };
>          };
> Then,I deal with the otp_out in thermal driver.
> I believe The "otp_out" will restart board if it's a high active.
> 
> tsadc_int: tsadc-int {
> +				rockchip,pins = <0 10 RK_FUNC_1 &pcfg_pull_up>;
> +			};
> 
> But,I think the about will be implemented in thermal driver.

I only meant the pin name (tsadc-int -> otp-out). In the schmatics the pin 
(controlled by the tsadc) is labeled otp_out and leads to the overtemperature 
protection circuit as expected. And as it's controlled by the tsadc, it should 
of course stay as the desired func_1.


Heiko
