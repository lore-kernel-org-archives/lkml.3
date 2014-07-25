Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbaGYL3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:29:32 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:42915 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaGYL3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:29:30 -0400
MIME-Version: 1.0
In-Reply-To: <53D1A371.1000108@codeaurora.org>
References: <1405610748-7583-5-git-send-email-iivanov@mm-sol.com>
	<1405626085-14069-1-git-send-email-iivanov@mm-sol.com>
	<20140722214643.GH19700@sonymobile.com>
	<53D04996.2030902@codeaurora.org>
	<CACRpkdbNqNO8Hy5XndWs4gLBGWR+2_VaQveBUaeREUeVXv27dQ@mail.gmail.com>
	<53D1A371.1000108@codeaurora.org>
Date: Fri, 25 Jul 2014 13:29:29 +0200
Message-ID: <CACRpkdYLhrZGMHosUc7nQGebHQSENCmDCq3X5jB0oM3zuBM-yg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 1/4] pinctrl: Update Qualcomm pm8xxx GPIO
 parameters definitions
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 2:23 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 07/24/14 08:40, Linus Walleij wrote:
>> On Thu, Jul 24, 2014 at 1:47 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>
>>>> Please add these constants to the table of valid power-source values and use
>>>> something like I did to translate them to register values - it makes the DT
>>>> much more readable.
>>> The DT could be similarly readable if we had a bunch of #defines for the
>>> different VIN settings that resolved to the final register value for
>>> that pmic. Something like PM8921_GPIO1_14_VPH, PM8921_GPIO19_36_VPH,
>>> etc. There would be a lot of them, but then the driver could be really
>>> simple and just jam whatever value is in the DT into the register
>>> without having to bounce through a mapping table in software to figure
>>> out the register value. If we did this for the functions also then I
>>> believe we achieve readability without requiring a bunch of drivers for
>>> each and every single pmic?
>> Not sure but it sounds like you want to make the device tree a jam table,
>> (know about individual register offsets, sequences etc). That has been
>> throrougly NACKed in the past, because DT is not Open Firmware.
>>
>> The exception is pinctrl-single which is restricted to single register
>> per pin use cases and is still a point of contention...
>>
>
> I'm not proposing a jam table. I'm proposing that we make the
> function/source property convenient to the driver by having the actual
> function field value encoded there instead of some string that has to be
> translated through a table in a driver. There's still going to be
> shifting and masking of bits in the driver to put the value in the right
> place in the register, but we avoid needing N number of drivers for each
> pmic just to translate strings into integers (for functions) and
> integers into other integers (for the power source). From what I can
> tell there isn't any benefit to having the function property be a string
> vs. a #define number besides having a human readable string in pinctrl
> debugfs. Is there some other benefit?

OK I get it ... I think.

One good reason to use strings is that it apart from debugfs makes
for quite readable debug messages if used the right way.

I feel sort of lukewarm on the issue, so I'd let the driver author
decide the most elegant way to deal with this from an end-user
point of view. If it helps people configure and debug their board
set-ups is a crucial factor to me, and I suspect both Ivan and
Björn has some experience with this.

Yours,
Linus Walleij
