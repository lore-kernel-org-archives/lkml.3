Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab3E1Mck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:32:40 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:45368 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933827Ab3E1Mcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:32:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130528100941.GK22683@gmail.com>
References: <1369661455-17839-1-git-send-email-gabriel.fernandez.st@gmail.com>
	<1369661455-17839-3-git-send-email-gabriel.fernandez.st@gmail.com>
	<20130528100941.GK22683@gmail.com>
Date: Tue, 28 May 2013 14:32:37 +0200
Message-ID: <CAGo1xzDuvwwPpkwAsoj4ENV_Tu0JOs0a07N1eoGug2vYCzb+Xg@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: u8540: Add Pinctrl Device Tree settings for
 uart0, uart2
From: Gabriel Fernandez <gabriel.fernandez.st@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2013 12:09, Lee Jones <lee.jones@linaro.org> wrote:
> On Mon, 27 May 2013, Gabriel Fernandez wrote:
>
>> From: Gabriel Fernandez <gabriel.fernandez@st.com>
>>
>> This patch adds pinctrl device tree settings for uart0 and uart2
>> for ccu8540 board.
>>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
>> ---
>>  arch/arm/boot/dts/ccu8540-pinctrl.dtsi     | 77 ++++++++++++++++++++++++
>>  arch/arm/boot/dts/ccu8540.dts              |  7 +++
>>  arch/arm/boot/dts/dbx5x0.dtsi              |  2 +-
>>  arch/arm/boot/dts/ste-nomadik-pinctrl.dtsi | 95 ++++++++++++++++++++++++++++++
>
> This is starting to get a bit confusing. How intrusive would it be to
> place the ccu8540-pinctrl information inside ccu8540.dts instead of
> breaking it out into different files and convoluting the issue?
>
> Also, please correct me if I'm wrong, but isn't what we call the
> Nomadik Pinctrl/GPIO really the same as DBX500 Pinctrl/GPIO? I wonder
> if this would be a better naming convention?
>
> Linus, what do you think?
>
>>  include/dt-bindings/pinctrl/nomadik.h      | 36 +++++++++++
>>  5 files changed, 216 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm/boot/dts/ccu8540-pinctrl.dtsi
>>  create mode 100644 arch/arm/boot/dts/ste-nomadik-pinctrl.dtsi
>>  create mode 100644 include/dt-bindings/pinctrl/nomadik.h
>>
>> diff --git a/arch/arm/boot/dts/ccu8540-pinctrl.dtsi b/arch/arm/boot/dts/ccu8540-pinctrl.dtsi
>> new file mode 100644
>> index 0000000..26e718b
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/ccu8540-pinctrl.dtsi
>> @@ -0,0 +1,77 @@
>> +/*
>> + * Copyright 2012 ST-Ericsson
>> + *
>> + * The code contained herein is licensed under the GNU General Public
>> + * License. You may obtain a copy of the GNU General Public License
>> + * Version 2 or later at the following locations:
>> + *
>> + * http://www.opensource.org/licenses/gpl-license.html
>> + * http://www.gnu.org/copyleft/gpl.html
>> + */
>> +#include "ste-nomadik-pinctrl.dtsi"
>> +
>> +&pinctrl_dbx500 {
>
> What does the '&' do?
>
'&pinctrl_dbx500 {' is a shortcut, avoid writing :

soc {
    princtrl {
     ...
    };
};

>> +     uart0 {
>> +             uart0_default_mux: uart0_mux {
>> +                     default_mux {
>> +                             ste,function = "u0";
>> +                             ste,pins = "u0_a_1";
>> +                     };
>> +             };
>> +
>> +             uart0_default_mode: uart0_default {
>> +                     default_cfg1 {
>> +                             ste,pins = "GPIO0", "GPIO2";
>> +                             ste,config = <&in_pu>;
>> +                     };
>> +
>> +                     default_cfg2 {
>> +                             ste,pins = "GPIO1", "GPIO3";
>> +                             ste,config = <&out_hi>;
>> +                     };
>> +             };
>> +
>> +             uart0_sleep_mode: uart0_sleep {
>> +                     sleep_cfg1 {
>> +                             ste,pins = "GPIO0", "GPIO2";
>> +                             ste,config = <&slpm_in_pu>;
>> +                     };
>> +
>> +                     sleep_cfg2 {
>> +                             ste,pins = "GPIO1", "GPIO3";
>> +                             ste,config = <&slpm_out_hi>;
>> +                     };
>> +             };
>> +     };
>> +
>> +     uart2 {
>> +             uart2_default_mode: uart2_default {
>> +                     default_mux {
>> +                             ste,function = "u2";
>> +                             ste,pins = "u2txrx_a_1";
>> +                     };
>> +
>> +                     default_cfg1 {
>> +                             ste,pins = "GPIO120";
>> +                             ste,config = <&in_pu>;
>> +                     };
>> +
>> +                     default_cfg2 {
>> +                             ste,pins = "GPIO121";
>> +                             ste,config = <&out_hi>;
>> +                     };
>> +             };
>> +
>> +             uart2_sleep_mode: uart2_sleep {
>> +                     sleep_cfg1 {
>> +                             ste,pins = "GPIO120";
>> +                             ste,config = <&slpm_in_pu>;
>> +                     };
>> +
>> +                     sleep_cfg2 {
>> +                             ste,pins = "GPIO121";
>> +                             ste,config = <&slpm_out_hi>;
>> +                     };
>> +             };
>> +     };
>> +};
>> diff --git a/arch/arm/boot/dts/ccu8540.dts b/arch/arm/boot/dts/ccu8540.dts
>> index 5de9e1e..4f93795 100644
>> --- a/arch/arm/boot/dts/ccu8540.dts
>> +++ b/arch/arm/boot/dts/ccu8540.dts
>> @@ -11,6 +11,7 @@
>>
>>  /dts-v1/;
>>  #include "dbx5x0.dtsi"
>> +#include "ccu8540-pinctrl.dtsi"
>>
>>  / {
>>       model = "ST-Ericsson U8540 platform with Device Tree";
>> @@ -27,6 +28,9 @@
>>               };
>>
>>               uart@80120000 {
>> +                     pinctrl-names = "default", "sleep";
>> +                     pinctrl-0 = <&uart0_default_mux>, <&uart0_default_mode>;
>> +                     pinctrl-1 = <&uart0_sleep_mode>;
>>                       status = "okay";
>>               };
>>
>> @@ -35,6 +39,9 @@
>>               };
>>
>>               uart@80007000 {
>> +                     pinctrl-names = "default", "sleep";
>> +                     pinctrl-0 = <&uart2_default_mode>;
>> +                     pinctrl-1 = <&uart2_sleep_mode>;
>>                       status = "okay";
>>               };
>>       };
>> diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
>> index f85ff85..7507148 100644
>> --- a/arch/arm/boot/dts/dbx5x0.dtsi
>> +++ b/arch/arm/boot/dts/dbx5x0.dtsi
>> @@ -170,7 +170,7 @@
>>                       gpio-bank = <8>;
>>               };
>>
>> -             pinctrl {
>> +             pinctrl_dbx500: pinctrl {
>>                       compatible = "stericsson,nmk-pinctrl";
>>                       prcm = <&prcmu>;
>>               };
>> diff --git a/arch/arm/boot/dts/ste-nomadik-pinctrl.dtsi b/arch/arm/boot/dts/ste-nomadik-pinctrl.dtsi
>> new file mode 100644
>> index 0000000..efddee9
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/ste-nomadik-pinctrl.dtsi
>> @@ -0,0 +1,95 @@
>> +/*
>> + * Copyright 2012 ST-Ericsson
>> + *
>> + * The code contained herein is licensed under the GNU General Public
>> + * License. You may obtain a copy of the GNU General Public License
>> + * Version 2 or later at the following locations:
>> + *
>> + * http://www.opensource.org/licenses/gpl-license.html
>> + * http://www.gnu.org/copyleft/gpl.html
>> + */
>> +#include <dt-bindings/pinctrl/nomadik.h>
>> +
>> +/ {
>> +     in_nopull: in_nopull {
>> +             ste,input = <INPUT_NOPULL>;
>> +     };
>> +
>> +     in_pu: input_pull_up {
>> +             ste,input = <INPUT_PULLUP>;
>> +     };
>> +
>> +     in_pd: input_pull_down {
>> +             ste,input = <INPUT_PULLDOWN>;
>> +     };
>> +
>> +     out_hi: output_high {
>> +             ste,output = <OUTPUT_HIGH>;
>> +     };
>> +
>> +     out_lo: output_low {
>> +             ste,output = <OUTPUT_LOW>;
>> +     };
>> +
>> +     gpio_out_lo: gpio_output_low {
>> +             ste,gpio = <GPIOMODE_ENABLED>;
>> +             ste,output = <OUTPUT_LOW>;
>> +     };
>> +
>> +     slpm_in_pu: slpm_in_pu {
>> +             ste,sleep = <SLPM_ENABLED>;
>> +             ste,sleep-input = <SLPM_INPUT_PULLUP>;
>> +             ste,sleep-wakeup = <SLPM_WAKEUP_ENABLE>;
>> +     };
>> +
>> +     slpm_in_wkup_pdis: slpm_in_wkup_pdis {
>> +             ste,sleep = <SLPM_ENABLED>;
>> +             ste,sleep-input = <SLPM_DIR_INPUT>;
>> +             ste,sleep-wakeup = <SLPM_WAKEUP_ENABLE>;
>> +             ste,sleep-pull-disable = <SLPM_PDIS_DISABLED>;
>> +     };
>> +
>> +     slpm_out_lo: slpm_out_lo {
>> +             ste,sleep = <SLPM_ENABLED>;
>> +             ste,sleep-output = <SLPM_OUTPUT_LOW>;
>> +             ste,sleep-wakeup = <SLPM_WAKEUP_ENABLE>;
>> +     };
>> +
>> +     slpm_out_hi: slpm_out_hi {
>> +             ste,sleep = <SLPM_ENABLED>;
>> +             ste,sleep-output = <SLPM_OUTPUT_HIGH>;
>> +             ste,sleep-wakeup = <SLPM_WAKEUP_ENABLE>;
>> +     };
>> +
>> +     slpm_out_hi_wkup_pdis: slpm_out_hi_wkup_pdis {
>> +             ste,sleep = <SLPM_ENABLED>;
>> +             ste,sleep-output = <SLPM_OUTPUT_HIGH>;
>> +             ste,sleep-wakeup = <SLPM_WAKEUP_ENABLE>;
>> +             ste,sleep-pull-disable = <SLPM_PDIS_DISABLED>;
>> +     };
>> +
>> +     slpm_out_wkup_pdis: slpm_out_wkup_pdis {
>> +             ste,sleep = <SLPM_ENABLED>;
>> +             ste,sleep-output = <SLPM_DIR_OUTPUT>;
>> +             ste,sleep-wakeup = <SLPM_WAKEUP_ENABLE>;
>> +             ste,sleep-pull-disable = <SLPM_PDIS_DISABLED>;
>> +     };
>> +
>> +     in_wkup_pdis: in_wkup_pdis {
>> +             ste,sleep-input = <SLPM_DIR_INPUT>;
>> +             ste,sleep-wakeup = <SLPM_WAKEUP_ENABLE>;
>> +             ste,sleep-pull-disable = <SLPM_PDIS_DISABLED>;
>> +     };
>> +
>> +     out_hi_wkup_pdis: out_hi_wkup_pdis {
>> +             ste,sleep-output = <SLPM_OUTPUT_HIGH>;
>> +             ste,sleep-wakeup = <SLPM_WAKEUP_ENABLE>;
>> +             ste,sleep-pull-disable = <SLPM_PDIS_DISABLED>;
>> +     };
>> +
>> +     out_wkup_pdis: out_wkup_pdis {
>> +             ste,sleep-output = <SLPM_DIR_OUTPUT>;
>> +             ste,sleep-wakeup = <SLPM_WAKEUP_ENABLE>;
>> +             ste,sleep-pull-disable = <SLPM_PDIS_DISABLED>;
>> +     };
>> +};
>
> Nodes look pretty good, except shouldn't 'ste' really be 'stericsson'?
>
> Yes, it's not as succinct, but it is the standard.
>
yes it's more succint...;)
in Documentation/devicetree/bindings/vendor-prefixes.txt we have both
(ste and stericsson for ST-Ericsson)

>> diff --git a/include/dt-bindings/pinctrl/nomadik.h b/include/dt-bindings/pinctrl/nomadik.h
>> new file mode 100644
>> index 0000000..638fb32
>> --- /dev/null
>> +++ b/include/dt-bindings/pinctrl/nomadik.h
>> @@ -0,0 +1,36 @@
>> +/*
>> + * nomadik.h
>> + *
>> + * Copyright (C) ST-Ericsson SA 2013
>> + * Author: Gabriel Fernandez <gabriel.fernandez@st.com> for ST-Ericsson.
>> + * License terms:  GNU General Public License (GPL), version 2
>> + */
>> +
>> +#define INPUT_NOPULL         0
>> +#define INPUT_PULLUP         1
>> +#define INPUT_PULLDOWN               2
>> +
>> +#define OUTPUT_LOW           0
>> +#define OUTPUT_HIGH          1
>> +#define DIR_OUTPUT           2
>> +
>> +#define SLPM_DISABLED                0
>> +#define SLPM_ENABLED         1
>> +
>> +#define SLPM_INPUT_NOPULL    0
>> +#define SLPM_INPUT_PULLUP    1
>> +#define SLPM_INPUT_PULLDOWN  2
>> +#define SLPM_DIR_INPUT               3
>> +
>> +#define SLPM_OUTPUT_LOW              0
>> +#define SLPM_OUTPUT_HIGH     1
>> +#define SLPM_DIR_OUTPUT              2
>> +
>> +#define SLPM_WAKEUP_DISABLE  0
>> +#define SLPM_WAKEUP_ENABLE   1
>> +
>> +#define GPIOMODE_DISABLED    0
>> +#define GPIOMODE_ENABLED     1
>> +
>> +#define SLPM_PDIS_DISABLED   0
>> +#define SLPM_PDIS_ENABLED    1
>
> Some stray tabbing above.

once the patch has been applied, all values are aligned in the source file.
(due to '+' character i think)

>
> --
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
