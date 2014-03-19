Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbaCSBGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:06:08 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:59027 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366AbaCSBGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:06:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAAYSxhri0evgrbCPew6-MTXVmpzm7Oa6TpmJTSGZpTcV=876HQ@mail.gmail.com>
References: <1394655346-30048-1-git-send-email-tim.kryger@linaro.org>
	<1394655346-30048-3-git-send-email-tim.kryger@linaro.org>
	<20140318215231.GH5917@mithrandir>
	<CAAYSxhri0evgrbCPew6-MTXVmpzm7Oa6TpmJTSGZpTcV=876HQ@mail.gmail.com>
Date: Tue, 18 Mar 2014 18:06:03 -0700
Message-ID: <CAAYSxhpW-N7UdpsGE7JHvOJxQcvURRPdAOhiVkK=4EHc7E03gQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] pwm: kona: Introduce Kona PWM controller support
From: Tim Kryger <tim.kryger@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 4:47 PM, Tim Kryger <tim.kryger@linaro.org> wrote:
> On Tue, Mar 18, 2014 at 2:52 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>> On Wed, Mar 12, 2014 at 01:15:43PM -0700, Tim Kryger wrote:

>>> +
>>> +     /* There is polarity support in HW but it is easier to manage in SW */
>>> +     if (pwm->polarity == PWM_POLARITY_INVERSED)
>>> +             duty_ns = period_ns - duty_ns;
>>
>> No, this is wrong. You're not actually changing the *polarity* here.
>
> Please elaborate.  I don't understand what is wrong here.
>
> Does polarity influence the output while a PWM is disabled?
>

>>> +static int kona_pwmc_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
>>> +                               enum pwm_polarity polarity)
>>> +{
>>> +     /*
>>> +      * The framework only allows the polarity to be changed when a PWM is
>>> +      * disabled so no immediate action is required here.  When a channel is
>>> +      * enabled, the polarity gets handled as part of the re-config step.
>>> +      */
>>> +
>>> +     return 0;
>>> +}
>>
>> See above. If you don't want to implement the hardware support for
>> inversed polarity, then simply don't implement this.
>
> I had originally planned to omit polarity support but because it
> affects the binding (which is treated as ABI), it wouldn't be possible
> to add it in later without defining a new compatible string.

I would like to get this right but it occurred to me that there may be
a way to defer the implementation of this feature without disrupting
the binding.

Would it be acceptable to continue using #pwm-cells = <3> and
of_pwm_xlate_with_flags but return -EINVAL from kona_pwmc_set_polarity
if PWM_POLARITY_INVERSED is specified?
