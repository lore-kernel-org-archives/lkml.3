Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaHSQFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:05:35 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:55398 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaHSQFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:05:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140819072220.GE12859@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
	<1408381749-14156-5-git-send-email-dianders@chromium.org>
	<20140819072220.GE12859@ulmo>
Date: Tue, 19 Aug 2014 09:05:31 -0700
X-Google-Sender-Auth: _YobA9ljUUuH_N6V3dZsRaJ7y9U
Message-ID: <CAD=FV=Vis=0bOMTMxSp4Vqv13dpdB-akiumNoOuiR9ZxtOemow@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM: dts: Enable pwm backlight on rk3288-EVB
From: Doug Anderson <dianders@chromium.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <eddie.cai@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry,

On Tue, Aug 19, 2014 at 12:22 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Aug 18, 2014 at 10:09:09AM -0700, Doug Anderson wrote:
>> The pwm0 is the PWM associated with the LCD backlight.  Enable it.
>
> In the subject, s/pwm/PWM/.

Done.


>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  arch/arm/boot/dts/rk3288-evb.dtsi | 53 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 53 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
>> index 2964370..242e1a9 100644
>> --- a/arch/arm/boot/dts/rk3288-evb.dtsi
>> +++ b/arch/arm/boot/dts/rk3288-evb.dtsi
>> @@ -10,6 +10,7 @@
>>   * GNU General Public License for more details.
>>   */
>>
>> +#include <dt-bindings/pwm/pwm.h>
>>  #include "rk3288.dtsi"
>>
>>  / {
>> @@ -17,6 +18,48 @@
>>               reg = <0x0 0x80000000>;
>>       };
>>
>> +        backlight {
>
> Indentation seems to be off here.

Good catch.  Done.


>> +             compatible = "pwm-backlight";
>> +             brightness-levels = <
>> +                       0   1   2   3   4   5   6   7
>> +                       8   9  10  11  12  13  14  15
>> +                      16  17  18  19  20  21  22  23
>> +                      24  25  26  27  28  29  30  31
>> +                      32  33  34  35  36  37  38  39
>> +                      40  41  42  43  44  45  46  47
>> +                      48  49  50  51  52  53  54  55
>> +                      56  57  58  59  60  61  62  63
>> +                      64  65  66  67  68  69  70  71
>> +                      72  73  74  75  76  77  78  79
>> +                      80  81  82  83  84  85  86  87
>> +                      88  89  90  91  92  93  94  95
>> +                      96  97  98  99 100 101 102 103
>> +                     104 105 106 107 108 109 110 111
>> +                     112 113 114 115 116 117 118 119
>> +                     120 121 122 123 124 125 126 127
>> +                     128 129 130 131 132 133 134 135
>> +                     136 137 138 139 140 141 142 143
>> +                     144 145 146 147 148 149 150 151
>> +                     152 153 154 155 156 157 158 159
>> +                     160 161 162 163 164 165 166 167
>> +                     168 169 170 171 172 173 174 175
>> +                     176 177 178 179 180 181 182 183
>> +                     184 185 186 187 188 189 190 191
>> +                     192 193 194 195 196 197 198 199
>> +                     200 201 202 203 204 205 206 207
>> +                     208 209 210 211 212 213 214 215
>> +                     216 217 218 219 220 221 222 223
>> +                     224 225 226 227 228 229 230 231
>> +                     232 233 234 235 236 237 238 239
>> +                     240 241 242 243 244 245 246 247
>> +                     248 249 250 251 252 253 254 255>;
>> +             default-brightness-level = <128>;
>> +             enable-gpios = <&gpio7 2 GPIO_ACTIVE_HIGH>;
>> +             pinctrl-names = "default";
>> +             pinctrl-0 = <&bl_en>;
>> +             pwms = <&pwm0 0 1000000 PWM_POLARITY_INVERTED>;
>> +        };
>
> And here.

Done.
