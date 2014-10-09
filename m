Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbaJIPE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:04:59 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:53970 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785AbaJIPEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:04:41 -0400
Message-ID: <5436A403.1050109@collabora.co.uk>
Date: Thu, 09 Oct 2014 17:04:35 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Mark Brown <broonie@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/5] regulator: dt-bindings: Add regulator-initial-mode
 support
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk> <1412775847-15213-4-git-send-email-javier.martinez@collabora.co.uk> <1412844355.1316.15.camel@AMDC1943>
In-Reply-To: <1412844355.1316.15.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

Thanks a lot for your feedback.

On 10/09/2014 10:45 AM, Krzysztof Kozlowski wrote:
> On śro, 2014-10-08 at 15:44 +0200, Javier Martinez Canillas wrote:
>> --- a/Documentation/devicetree/bindings/regulator/regulator.txt
>> +++ b/Documentation/devicetree/bindings/regulator/regulator.txt
>> @@ -23,6 +23,14 @@ Optional properties:
>>    state among following defined suspend states:
>>    <3>: PM_SUSPEND_MEM - Setup regulator according to regulator-state-mem
>>    <4>: PM_SUSPEND_MAX - Setup regulator according to regulator-state-disk
>> +- regulator-initial-mode: initial regulator operating mode. One of following:
>> +	<1>: REGULATOR_MODE_FAST    - Regulator can handle fast changes.
>> +	<2>: REGULATOR_MODE_NORMAL  - Normal regulator power supply mode.
>> +	<4>: REGULATOR_MODE_IDLE    - Regulator runs in a more efficient mode.
>> +	<8>: REGULATOR_MODE_STANDBY - Regulator runs in the most efficient mode.
>> +  modes are defined in the dt-bindings/regulator/regulator.h header and can be
>> +  used in device tree sources files. If no mode is defined, then the OS will not
>> +  manage the operating mode and the HW default values will be used instead.
>>  - regulator-state-mem sub-root node for Suspend-to-RAM mode
>>    : suspend to memory, the device goes to sleep, but all data stored in memory,
>>    only some external interrupt can wake the device.
> 
> I agree with the need and the idea of generic bindings for operating
> modes for regulators. At least for Exynos-based boards the PMICs have
> quite similar opmodes.
> 
> However the regulator mode from consumer.h (and in above doc) does not
> match well with these opmodes. Example is yours patch 4/5:
>  - idle ("more efficient mode") maps to "low power mode in suspend",
>  - standby ("the most efficient mode") maps to "OFF in suspend".
> 
> Actually we are not enable "efficient modes" but we configure how the
> regulator will behave when AP says - I'm suspending.
>

Agree, Mark also pointed out that there is a difference between changing
how the regulator will behave on runtime vs changing how the regulator
will behave during system suspend. AFAIU from his explanation, the modes
defined in consumer.h only applies to the former and conceptually there
should be a difference between those two cases even when the Maxim PMIC
seems to mix it both in the data-sheet and by using the same field.

I answered Mark on patch #5 with a suggestion on how to handle this in
a generic way to avoid each driver having their own custom DT binding
and duplicating the parsing code.

Could you please answer there with your thoughts?
 
> 
> Another issue: is "initial_state" not doing all this already?
> 

One of the options I indeed evaluated was if using initial_state could be
possible. But currently the .set_suspend_mode function handler is only
called for the STANDBY, MEM and MAX suspend modes. While is true that this
could be extended to also support PM_SUSPEND_ON, I don't think that it
makes sense conceptually. Since is not the same to set a mode to be used
at runtime than setting a mode to be used during suspend.

AFAIU that is the reason why there are separate .set_suspend_mode and
.set_mode operations and that's why there are both an .initial_state
and an .initial_mode.

> Best regards,
> Krzysztof
>

Best regards,
Javier
