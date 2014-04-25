Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaDYNoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:44:03 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:59250 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaDYNoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:44:00 -0400
MIME-Version: 1.0
In-Reply-To: <1398432541.4724.243.camel@iivanov-dev>
References: <1398429171-8566-1-git-send-email-iivanov@mm-sol.com>
	<CAL_JsqJMs1ULgLMAia6ojz+i3b=7W6hxyqSTMATo96i0cS2n0g@mail.gmail.com>
	<1398432541.4724.243.camel@iivanov-dev>
Date: Fri, 25 Apr 2014 08:43:59 -0500
Message-ID: <CAL_Jsq+biEgbb7MmDuMsZ-bjocX0u=vvgZQHb6D696eGWDF7WA@mail.gmail.com>
Subject: Re: [RFC PATCH] mfd: pm8x41: Naive function devices registration
From: Rob Herring <robherring2@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 8:29 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> On Fri, 2014-04-25 at 08:00 -0500, Rob Herring wrote:
>> On Fri, Apr 25, 2014 at 7:32 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
>> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>> >
>> > Currently functions that exist in both the controller at the
>> > same address offset can not be specified with the same names.
>> >
>> > Adding Unique Slave ID device address to prefix function
>> > device names fixes this.
>> >
>> > Function devices are SPMI devices, so register them on
>> > SPMI bus.
>> >
>> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>> > ---
>> >  drivers/mfd/pm8x41.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++----
>>
>> No, this should be fixed in the core, not the driver.
>
> I think that at core level they are no issues.

By core, I mean the device naming conventions used by the DT platform
device code. There is a problem and it should be handled.

As I mentioned in the other thread, either we should not use the
address on non-translatable addresses like this or append the parent
address.

> There is no name clashes with "top level" devices.
>
> spmi@...{
>         ...
>         child@0 {
>                 compatible = "qcom,pm8941";
>                 reg = <0x0 SPMI_USID>;
>
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>
>                 revid@100 {
>                         compatible = "qcom,qpnp-revid";
>                         reg = <0x100>;
>                 };
>         };
>
>         child@4 {
>                 compatible = "qcom,pm8841";
>                 reg = <0x4 SPMI_USID>;
>
>                 #address-cells = <1>;
>                 #size-cells = <0>;
>
>                 revid@100 {
>                         compatible = "qcom,qpnp-revid";
>                         reg = <0x100>;
>                 };
>         };
> };
>
> I don't have experience with SPMI devices, but it looks
> like address partitioning is specific to this "PMIC"
> controllers.
>
> Regards,
> Ivan
>
>>
>> Rob
>
>
