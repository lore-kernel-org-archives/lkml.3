Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaE2Wc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:32:27 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50395 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaE2WcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:32:24 -0400
Message-ID: <5387B575.2040803@gmail.com>
Date: Thu, 29 May 2014 15:32:21 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: Kumar Gala <galak@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT binding
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com> <1401211721-19712-2-git-send-email-bjorn.andersson@sonymobile.com> <09409B75-BBE3-47A6-8B4A-4E3DD29F81CD@codeaurora.org> <CAJAp7OgvChWSWgj6XRhqFC6i+T26PUCTLg5Ff722-oXDCgVuww@mail.gmail.com>
In-Reply-To: <CAJAp7OgvChWSWgj6XRhqFC6i+T26PUCTLg5Ff722-oXDCgVuww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/2014 11:24 AM, Bjorn Andersson wrote:
> On Wed, May 28, 2014 at 9:34 AM, Kumar Gala <galak@codeaurora.org> wrote:
>>
>> On May 27, 2014, at 12:28 PM, Bjorn Andersson <bjorn.andersson@sonymobile.com> wrote:
>>
>>> Add binding for the Qualcomm Resource Power Manager (RPM) found in 8660, 8960
>>> and 8064 based devices. The binding currently describes the rpm itself and the
>>> regulator subnodes.
>>>
>>> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>>> ---
>>> Documentation/devicetree/bindings/mfd/qcom,rpm.txt | 284 +++++++++++++++++++++
>>> include/dt-bindings/mfd/qcom_rpm.h                 | 142 +++++++++++
>>> 2 files changed, 426 insertions(+)
>>> create mode 100644 Documentation/devicetree/bindings/mfd/qcom,rpm.txt
>>> create mode 100644 include/dt-bindings/mfd/qcom_rpm.h
>>>
>>> diff --git a/Documentation/devicetree/bindings/mfd/qcom,rpm.txt b/Documentation/devicetree/bindings/mfd/qcom,rpm.txt
>>> new file mode 100644
>>> index 0000000..3908a5d
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/mfd/qcom,rpm.txt

< snip >

>>> +
>>> +- qcom,force-mode-none:
>>> +     Usage: optional (default if no other qcom,force-mode is specified)
>>> +     Value type: <empty>
>>> +     Defintion: indicates that the regulator should not be forced to any
>>> +                particular mode
>>> +
>>> +- qcom,force-mode-lpm:
>>> +     Usage: optional
>>> +     Value type: <empty>
>>> +     Definition: indicates that the regulator should be forced to operate in
>>> +                 low-power-mode
>>> +
>>> +- qcom,force-mode-auto:
>>> +     Usage: optional (only available for 8960/8064)
>>> +     Value type: <empty>
>>> +     Definition: indicates that the regulator should be automatically pick
>>> +                 operating mode
>>> +
>>> +- qcom,force-mode-hpm:
>>> +     Usage: optional (only available for 8960/8064)
>>> +     Value type: <empty>
>>> +     Definition: indicates that the regulator should be forced to operate in
>>> +                 high-power-mode
>>> +
>>> +- qcom,force-mode-bypass: (only for 8960/8064)
>>> +     Usage: optional (only available for 8960/8064)
>>> +     Value type: <empty>
>>> +     Definition: indicates that the regulator should be forced to operate in
>>> +                 bypass mode
>>> +
>>
>> Is force-mode really an enum?  Or can we really have multiple force-mode’s set?
>>
> 
> Force mode is an enum, you can only set one of these.
> 
> Looking around you can find three ways of doing this:
> 1) Make it an int and provide defines in a dt-bindings header file
> 2) Make it a string and list the possible values
> 3) Make it a set of boolean properties
> 
> I just spent some time in the pinctrl struff that implements 3), I
> like the feel of it and I like how the dts ended up looking like.
> 
> But if there's a strong opinion regarding this I could change it.

The problem with separate properties is that there is not a way to
detect the error of specifying multiple conflicting force-modes
at compile time.

It also means you can not override the default force-mode from one
.dts/.dtsi in another .dts/.dtsi.

< snip >

-Frank

