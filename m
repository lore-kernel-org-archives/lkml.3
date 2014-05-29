Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbaE2SYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:24:14 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:51529 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbaE2SYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:24:10 -0400
MIME-Version: 1.0
In-Reply-To: <09409B75-BBE3-47A6-8B4A-4E3DD29F81CD@codeaurora.org>
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1401211721-19712-2-git-send-email-bjorn.andersson@sonymobile.com>
	<09409B75-BBE3-47A6-8B4A-4E3DD29F81CD@codeaurora.org>
Date: Thu, 29 May 2014 11:24:09 -0700
Message-ID: <CAJAp7OgvChWSWgj6XRhqFC6i+T26PUCTLg5Ff722-oXDCgVuww@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT binding
From: Bjorn Andersson <bjorn@kryo.se>
To: Kumar Gala <galak@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 9:34 AM, Kumar Gala <galak@codeaurora.org> wrote:
>
> On May 27, 2014, at 12:28 PM, Bjorn Andersson <bjorn.andersson@sonymobile.com> wrote:
>
>> Add binding for the Qualcomm Resource Power Manager (RPM) found in 8660, 8960
>> and 8064 based devices. The binding currently describes the rpm itself and the
>> regulator subnodes.
>>
>> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>> ---
>> Documentation/devicetree/bindings/mfd/qcom,rpm.txt | 284 +++++++++++++++++++++
>> include/dt-bindings/mfd/qcom_rpm.h                 | 142 +++++++++++
>> 2 files changed, 426 insertions(+)
>> create mode 100644 Documentation/devicetree/bindings/mfd/qcom,rpm.txt
>> create mode 100644 include/dt-bindings/mfd/qcom_rpm.h
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/qcom,rpm.txt b/Documentation/devicetree/bindings/mfd/qcom,rpm.txt
>> new file mode 100644
>> index 0000000..3908a5d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mfd/qcom,rpm.txt
>> @@ -0,0 +1,284 @@
>> +Qualcomm Resource Power Manager (RPM)
>> +
>> +This driver is used to interface with the Resource Power Manager (RPM) found in
>> +various Qualcomm platforms. The RPM allows each component in the system to vote
>> +for state of the system resources, such as clocks, regulators and bus
>> +frequencies.
>> +
>> +- compatible:
>> +     Usage: required
>> +     Value type: <string>
>> +     Definition: must be one of:
>> +                 "qcom,rpm-apq8064"
>> +                 "qcom,rpm-msm8660"
>> +                 "qcom,rpm-msm8960"
>> +
>> +- reg:
>> +     Usage: required
>> +     Value type: <prop-encoded-array>
>> +     Definition: two entries specifying the RPM's message ram and ipc register
>> +
>> +- reg-names:
>> +     Usage: required
>> +     Value type: <string-array>
>> +     Definition: must contain the following, in order:
>> +                 "msg_ram"
>> +                 “ipc"
>
> If order maters, it should be on reg not reg-names.  If order doesn’t mater than this should say the names should match the reg

The DT guys have been clear on that the order of the reg property must
be fixed, no matter if you have reg-names or not. But I will make sure
to clarify this by being specific in the definition of "reg" as well.

>
>> +
>> +- interrupts:
>> +     Usage: required
>> +     Value type: <prop-encoded-array>
>> +     Definition: three entries specifying the RPM's:
>> +                 1. acknowledgement interrupt
>> +                 2. error interrupt
>> +                 3. wakeup interrupt
>> +
>> +- interrupt-names:
>> +     Usage: required
>> +     Value type: <string-array>
>> +     Definition: must be the three strings "ack", "err" and "wakeup", in order
>
> again, if order maters it should be with the interrupts prop, not the name.

I'll add something to the definition of "interrupts" to clarify this fact.

>
>> +
>> +- #address-cells:
>> +     Usage: required
>> +     Value type: <u32>
>> +     Definition: must be 1
>> +
>> +- #size-cells:
>> +     Usage: required
>> +     Value type: <u32>
>> +     Definition: must be 0
>> +
>> +
>> += SUBDEVICES
>> +
>> +The RPM exposes resources to its subnodes. The below bindings specify the set
>> +of valid subnodes that can operate on these resources.
>> +
>> +== Switch-mode Power Supply regulator
>> +
>> +- compatible:
>> +     Usage: required
>> +     Value type: <string>
>> +     Definition: must be one of:
>> +                 "qcom,rpm-pm8058-smps"
>> +                 "qcom,rpm-pm8901-ftsmps"
>> +                 "qcom,rpm-pm8921-smps"
>> +                 "qcom,rpm-pm8921-ftsmps"
>> +
>> +- reg:
>> +     Usage: required
>> +     Value type: <u32>
>> +     Definition: resource as defined in <dt-bindings/mfd/qcom_rpm.h>
>
> Can we provide a bit more description about what “namespace” this reg is work in.

Based on that I split this up in the different regulator types I
should be able to glob the possible resources here now; I'll give it a
try.

>
>> +
>> +- qcom,switch-mode-frequency:
>> +     Usage: required
>> +     Value type: <u32>
>> +     Definition: Frequency (Hz) of the switch-mode power supply;
>> +                 must be one of:
>> +                 19200000, 9600000, 6400000, 4800000, 3840000, 3200000,
>> +                 2740000, 2400000, 2130000, 1920000, 1750000, 1600000,
>> +                 1480000, 1370000, 1280000, 1200000
>> +
>> +- qcom,hpm-threshold:
>> +     Usage: optional
>> +     Value type: <u32>
>> +     Definition: indicates the breaking point at which the regulator should
>> +                 switch to high power mode
>
> in what units?

Thanks

>
>> +
>> +- qcom,load-bias:
>> +     Usage: optional
>> +     Value type: <u32>
>> +     Definition: specifies a base load on the specific regulator
>
> in what units?

Thanks

>
>> +
>> +- qcom,boot-load:
>> +     Usage: optional
>> +     Value type: <u32>
>> +     Definition: specifies the configured load on boot for the specific
>> +                 regulator
>
> in what units?

Thanks

>
>> +
>> +- qcom,force-mode-none:
>> +     Usage: optional (default if no other qcom,force-mode is specified)
>> +     Value type: <empty>
>> +     Defintion: indicates that the regulator should not be forced to any
>> +                particular mode
>> +
>> +- qcom,force-mode-lpm:
>> +     Usage: optional
>> +     Value type: <empty>
>> +     Definition: indicates that the regulator should be forced to operate in
>> +                 low-power-mode
>> +
>> +- qcom,force-mode-auto:
>> +     Usage: optional (only available for 8960/8064)
>> +     Value type: <empty>
>> +     Definition: indicates that the regulator should be automatically pick
>> +                 operating mode
>> +
>> +- qcom,force-mode-hpm:
>> +     Usage: optional (only available for 8960/8064)
>> +     Value type: <empty>
>> +     Definition: indicates that the regulator should be forced to operate in
>> +                 high-power-mode
>> +
>> +- qcom,force-mode-bypass: (only for 8960/8064)
>> +     Usage: optional (only available for 8960/8064)
>> +     Value type: <empty>
>> +     Definition: indicates that the regulator should be forced to operate in
>> +                 bypass mode
>> +
>
> Is force-mode really an enum?  Or can we really have multiple force-mode’s set?
>

Force mode is an enum, you can only set one of these.

Looking around you can find three ways of doing this:
1) Make it an int and provide defines in a dt-bindings header file
2) Make it a string and list the possible values
3) Make it a set of boolean properties

I just spent some time in the pinctrl struff that implements 3), I
like the feel of it and I like how the dts ended up looking like.

But if there's a strong opinion regarding this I could change it.

>> +- qcom,power-mode-hysteretic:
>> +     Usage: optional
>> +     Value type: <empty>
>> +     Definition: indicates that the power supply should operate in hysteretic
>> +                 mode (defaults to qcom,power-mode-pwm if not specified)
>> +
>> +- qcom,power-mode-pwm:
>> +     Usage: optional
>> +     Value type: <empty>
>> +     Definition: indicates that the power supply should operate in pwm mode
>> +
>
> Same question here is power-mode either pwm or hysteretic or can we set both?
>

Same as for force-mode

>> +Standard regulator bindings are used inside switch mode power supply subnodes.
>> +Check Documentation/devicetree/bindings/regulator/regulator.txt for more
>> +details.
>> +

[...]

>> diff --git a/include/dt-bindings/mfd/qcom_rpm.h b/include/dt-bindings/mfd/qcom_rpm.h
>> new file mode 100644
>> index 0000000..277e789
>> --- /dev/null
>> +++ b/include/dt-bindings/mfd/qcom_rpm.h
[...]
>> +#define QCOM_RPM_SYS_FABRIC_CLK                      128
>> +#define QCOM_RPM_SYS_FABRIC_HALT             129
>> +#define QCOM_RPM_SYS_FABRIC_IOCTL            130
>> +#define QCOM_RPM_SYS_FABRIC_MODE             131
>> +#define QCOM_RPM_USB_OTG_SWITCH                      132
>> +#define QCOM_RPM_VDDMIN_GPIO                 133
>
> Are these values arbitrary or do they mean something to hw?

They are just arbitrary values, similar to what you find in e.g. the
clock definitions.

Thanks for the review.

Regards,
Bjorn
